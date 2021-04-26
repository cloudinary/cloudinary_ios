//
//  StorehouseAutoPurging.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

import Foundation
///
/// The `StorehouseAutoPurging` in an in-memory storehouse used to store StoredItem up to a given memory capacity. When
/// the memory capacity is reached, the cache is sorted by last access date, then the oldest entry is continuously
/// purged until the preferred memory usage after purge is met. Each time an entry is accessed through the cache, the
/// internal access date of the entry is updated.
///
internal final class StorehouseAutoPurging<StoredItem> : StorehouseAnyInMemory<StoredItem>
{
    // MARK: - Types
    
    ///
    ///
    ///
    fileprivate class MemoryCapsule
    {
        ///
        ///
        ///
        fileprivate let identifier     : String
        
        ///
        ///
        ///
        fileprivate let content        : StorehouseEntry<Item>
        
        ///
        ///
        ///
        fileprivate let totalBytes     : Int
        
        ///
        ///
        ///
        fileprivate var lastAccessDate : Date
        
        ///
        ///
        ///
        fileprivate let transformer    : StorehouseTransformer<Item>
        
        ///
        ///
        ///
        fileprivate init(identifier: String, content entry: StorehouseEntry<Item>, transformer: StorehouseTransformer<Item>) throws
        {
            let object     = entry.object
            let storedData = try transformer.toData(object)
            
            self.identifier     = identifier
            self.content        = entry
            self.lastAccessDate = Date()
            self.transformer    = transformer
            self.totalBytes     = storedData.count
        }
        
        func accessContent() -> StorehouseEntry<Item> {
            
            lastAccessDate = Date()
            return content
        }
    }
    
    // MARK: - Properties
    
    ///
    /// The total memory capacity of the cache in bytes.
    ///
    internal override var memoryCapacity : Int {
        return configuration.memoryCapacity
    }
    
    ///
    /// The current total memory usage in bytes of all images stored within the cache.
    ///
    internal override var currentMemoryUsage : Int {
        var value : Int = 0
        synchronizationQueue.sync { value = self.memoryUsage }
        return value
    }
    
    ///
    /// The preferred memory usage after purge in bytes.
    /// During a purge , images will be purged until the memory capacity drops below this limit.
    ///
    internal var preferredMemoryUsageAfterPurge : Int {
        return configuration.preferredMemoryUsageAfterPurge
    }
    
    /// MARK: - Fileprivate Properties
    
    ///
    /// The current memory usage, for internal use
    ///
    fileprivate var memoryUsage : Int
    
    /// Memory cache keys
    fileprivate var keys = Set<String>()
    
    /// Memory cache
    fileprivate var cachedMemoryCapsules : [String:MemoryCapsule]
    
    ///
    fileprivate let synchronizationQueue : DispatchQueue
    
    ///
    /// Configuration
    ///
    fileprivate let configuration : StorehouseConfigurationAutoPurging
    
    ///
    /// Transformer
    ///
    fileprivate let transformer   : StorehouseTransformer<StoredItem>
    
    // MARK: - Initializers
    
    ///
    /// Initialies the `StorehouseAutoPurging` instance with the given memory capacity and preferred memory usage
    /// after purge limit.
    /// Please note, the memory capacity must always be greater than or equal to the preferred memory usage after purge.
    ///
    /// - Parameters:
    ///     - configuration: A settings object  for the auto purging storehouse
    ///     - transformer  : A transformer used for conversion into Data and back
    ///
    /// - Returns: The new `StorehouseAutoPurging` instance.
    ///
    internal init(configuration: StorehouseConfigurationAutoPurging, transformer : StorehouseTransformer<Item>)
    {
        precondition(configuration.memoryCapacity >= configuration.preferredMemoryUsageAfterPurge,
                     "The `memoryCapacity` must be greater than or equal to `preferredMemoryUsageAfterPurge`")
        
        self.configuration = configuration
        self.transformer   = transformer
        
        self.cachedMemoryCapsules = [String:MemoryCapsule]()
        self.memoryUsage   = 0
        
        self.synchronizationQueue = {
            
            let queueName = String(format: "com.cloudinary.autopurgingcache-%08x%08x", arc4random(), arc4random())
            return DispatchQueue(label: queueName, attributes: .concurrent)
        }()
        
        super.init()
        
        #if os(iOS) || os(tvOS)
        #if swift(>=4.2)
        let notification = UIApplication.didReceiveMemoryWarningNotification
        #else
        let notification = Notification.Name.UIApplicationDidReceiveMemoryWarning
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(StorehouseAutoPurging.removeAll), name: notification, object: nil)
        #endif
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Fileprivate methods
    
    ///
    ///
    ///
    fileprivate func removeObjectIfExpired(forKey key: String, since date: Date) throws
    {
        guard synchronizationQueue.sync(flags: [.barrier], execute: {
            !cachedMemoryCapsules.isEmpty
        }) else { return }
        
        let identifier = key
        
        var capsule : StorehouseAutoPurging<Item>.MemoryCapsule?
        synchronizationQueue.sync {
            capsule = cachedMemoryCapsules[identifier]
        }
        
        let content = try capsule.cld_unwrapOrThrow(error: StorehouseError.notFound).accessContent()
        
        guard content.expiry.isExpired(for: date) else { return }
        try removeObject(forKey: key)
    }
    
    ///
    /// Purge stored capsules they are expired
    ///
    fileprivate func purgeStoredObjectsIfNeeded()
    {
        guard memoryUsage > memoryCapacity else { return }
        
        let bytesToPurge   = memoryUsage - preferredMemoryUsageAfterPurge
        
        var sortedCapsules = cachedMemoryCapsules.map { $1 }
        sortedCapsules.sort {
            
            let date1 = $0.lastAccessDate
            let date2 = $1.lastAccessDate
            
            return date1.timeIntervalSince(date2) < 0.0
        }
        
        var bytesPurged = Int(0)
        
        clearOverflow: for capsule in sortedCapsules {
            
            cachedMemoryCapsules.removeValue(forKey: capsule.identifier)
            bytesPurged += capsule.totalBytes
            
            guard bytesPurged >= bytesToPurge else { continue }
            break clearOverflow
        }
        
        memoryUsage -= bytesPurged
    }

    // MARK: - StorehouseProtocol
    
    @discardableResult
    internal override func entry(forKey key: String) throws -> StorehouseEntry<Item>
    {
        var capsule : StorehouseEntry<Item>?
        
        let identifier = key
        synchronizationQueue.sync {
            
            guard let cachedCapsule = cachedMemoryCapsules[identifier] else { return }
            capsule = cachedCapsule.accessContent()
        }
        return try capsule.cld_unwrapOrThrow(error: StorehouseError.notFound)
    }
    
    internal override func removeObject(forKey key: String) throws
    {
        let identifier = key
        synchronizationQueue.sync(flags: [.barrier]) {
            
            guard let cachedCapsule = cachedMemoryCapsules.removeValue(forKey: identifier) else { return }
            self.memoryUsage -= cachedCapsule.totalBytes
            keys.remove(key)
        }
    }
    
    internal override func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry?) throws
    {
        let identifier = key
        try synchronizationQueue.sync(flags: [.barrier]) {
        
            let entry   = StorehouseEntry<Item>(object: object, expiry: .date(expiry?.date ?? configuration.expiry.date))
            let capsule = try MemoryCapsule(identifier: identifier, content: entry, transformer: transformer)
            
            if let previousCachedCapsule = cachedMemoryCapsules[identifier] {
                memoryUsage -= previousCachedCapsule.totalBytes
            }
            cachedMemoryCapsules[identifier] = capsule
            keys.insert(key)
            
            memoryUsage += capsule.totalBytes
        }
        
        synchronizationQueue.async(flags: [.barrier]) {
            self.purgeStoredObjectsIfNeeded()
        }
    }
    
    @objc
    internal override func removeAll() throws
    {
        synchronizationQueue.sync(flags: [.barrier]) {
            
            guard !self.cachedMemoryCapsules.isEmpty else { return }
            self.cachedMemoryCapsules.removeAll()
            self.memoryUsage = 0
            self.keys.removeAll()
        }
    }
    
    internal override func removeExpiredObjects() throws
    {
        let now     = Date()
        let allKeys = keys
        try allKeys.forEach {
            try removeObjectIfExpired(forKey: $0, since: now)
        }
    }
    
    internal override func removeStoredObjects(since date: Date) throws
    {
        let now     = Date()
        let allKeys = keys
        try allKeys.forEach {
            try removeObjectIfExpired(forKey: $0, since: now)
        }
    }
    
    internal override func removeObjectIfExpired(forKey key: String) throws
    {
        try removeObjectIfExpired(forKey: key, since: Date())
    }
}
