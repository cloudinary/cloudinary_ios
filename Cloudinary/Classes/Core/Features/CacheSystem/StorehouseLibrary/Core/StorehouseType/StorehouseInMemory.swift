//
//  StorehouseInMemory.swift
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

import Foundation
///
///
///
internal final class StorehouseInMemory<StoredItem>: StorehouseAnyInMemory<StoredItem>
{
    /// MARK: - Types
    ///
    /// Helper class to hold cached instance and expiry date.
    /// Used in memory storage to work with NSCache.
    ///
    fileprivate class MemoryCapsule : NSObject
    {    
        ///
        /// Object to be cached
        ///
        let object : Any
        
        ///
        /// Expiration date
        ///
        let expiry : StorehouseExpiry
        
        ///
        /// Creates a new instance of Capsule.
        ///
        /// - Parameter value : Object to be cached
        /// - Parameter expiry: Expiration date
        ///
        init(value: Any, expiry: StorehouseExpiry) {
            self.object = value
            self.expiry = expiry
        }
    }
    
    internal override var memoryCapacity : Int {
        return NSNotFound
    }
    
    internal override var currentMemoryUsage : Int {
        return NSNotFound
    }
    
    /// MARK: - Fileprivate Properties
    
    /// Memory cache keys
    fileprivate var keys  = Set<String>()
    
    /// Memory cache
    fileprivate let cache = NSCache<NSString, MemoryCapsule>()
    
    /// Configuration
    fileprivate let configuration : StorehouseConfigurationInMemory
    
    /// MARK: - Initializers
    internal init(configuration: StorehouseConfigurationInMemory)
    {
        self.configuration        = configuration
        self.cache.countLimit     = Int(configuration.countLimit)
        self.cache.totalCostLimit = Int(configuration.totalCostLimit)
        super.init()
    }
    
    fileprivate func removeObjectIfExpired(forKey key: String, since date: Date) throws
    {
        let aKey = NSString(string: key)
        
        guard let capsule = cache.object(forKey: aKey) else { return }
        guard capsule.expiry.isExpired(for: date)      else { return }
        try removeObject(forKey: key)
    }

    // MARK: - StorehouseProtocol

    @discardableResult
    internal override func entry(forKey key: String) throws -> StorehouseEntry<Item>
    {
        let aKey = NSString(string: key)
        guard let capsule = cache.object(forKey: aKey) else { throw StorehouseError.notFound     }
        guard let object  = capsule.object as? Item    else { throw StorehouseError.typeNotMatch }
        return StorehouseEntry(object: object, expiry: capsule.expiry)
    }
    
    internal override func removeObject(forKey key: String) throws
    {
        let aKey = NSString(string: key)
        cache.removeObject(forKey: aKey)
        keys.remove(key)
    }
    
    internal override func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry? = nil) throws
    {
        let capsule = MemoryCapsule(value: object, expiry: .date(expiry?.date ?? configuration.expiry.date))
        cache.setObject(capsule, forKey: NSString(string: key))
        keys.insert(key)
    }
    
    internal override func removeAll() throws
    {
        cache.removeAllObjects()
        keys.removeAll()
    }
    
    internal override func removeExpiredObjects() throws
    {
        let now = Date()
        try removeStoredObjects(since: now)
    }
    
    internal override func removeStoredObjects(since date: Date) throws
    {
        let allKeys = keys
        
        try allKeys.forEach {
            try removeObjectIfExpired(forKey: $0, since: date)
        }
    }
    
    internal override func removeObjectIfExpired(forKey key: String) throws
    {
        try removeObjectIfExpired(forKey: key, since: Date())
    }
}
