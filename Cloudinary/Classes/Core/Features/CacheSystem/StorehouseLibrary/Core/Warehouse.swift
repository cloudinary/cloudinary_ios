//
//  Warehouse.swift
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
import Dispatch
///
/// Manage a storehouse with wares, generic over SoredType.
///
internal final class Warehouse<SoredType>
{
    /// MARK: - Typealias
    internal typealias Item = SoredType
    
    /// MARK: - Private Properties
    private let   accessor : StorehouseAccessor<Item>
    private let storehouse : StorehouseHybrid  <Item>
    
    /// MARK: - Public Computed Properties
    internal var memoryCapacity : Int {
        return accessor.memoryCapacity
    }
    internal var   diskCapacity : Int {
        return accessor.diskCapacity
    }
    
    internal var currentMemoryUsage : Int {
        return accessor.currentMemoryUsage
    }
    
    internal var currentDiskUsage: Int {
        return accessor.currentDiskUsage
    }
    
    /// MARK: - Initializers
    
    ///
    /// Initialize a warehouse with configuration options.
    ///
    /// - Parameters:
    ///   - memoryConfig: In memory storehouse configuration
    ///   - diskConfig  : Disk storehouse configuration
    ///   - transformer : A transformer to use for conversion of the stored data into the file system
    ///
    /// - Throws: Throw StorehouseError if any.
    ///
    internal convenience init(memoryConfig: StorehouseConfigurationInMemory, diskConfig: StorehouseConfigurationDisk, transformer: StorehouseTransformer<Item>) throws
    {
        let disk    = try StorehouseOnDisk<Item>(configuration:   diskConfig, transformer: transformer)
        let memory  = StorehouseInMemory<Item>(configuration: memoryConfig)
        let storage = StorehouseHybrid<Item>(inMemory: memory, onDisk: disk)
        self.init(hybrid: storage)
    }
    
    ///
    /// Initialize a warehouse with configuration options.
    ///
    /// - Parameters:
    ///   - memoryConfig: In memory storehouse configuration
    ///   - diskConfig  : Disk storehouse configuration
    ///   - transformer : A transformer to use for conversion of the stored data into the file system
    ///
    /// - Throws: Throw StorehouseError if any.
    ///
    internal convenience init(purgingConfig: StorehouseConfigurationAutoPurging, diskConfig: StorehouseConfigurationDisk, transformer: StorehouseTransformer<Item>) throws
    {
        let disk    = try StorehouseOnDisk (configuration:    diskConfig, transformer: transformer)
        let memory  = StorehouseAutoPurging(configuration: purgingConfig, transformer: transformer)
        let storage = StorehouseHybrid(inMemory: memory, onDisk: disk)
        self.init(hybrid: storage)
    }
    
    ///
    /// Initialise a warehouse with a prepared storehouse.
    ///
    /// - Parameter storage: The storehouse to use
    internal init(hybrid storage: StorehouseHybrid<Item>)
    {
        let queue = DispatchQueue(label: "com.cloudinary.accessQueue", attributes: [.concurrent])
        self.storehouse = storage
        self.accessor   = StorehouseAccessor(storage: storage, queue: queue)
    }
    
    internal func updateCacheCapacity(purgingConfig: StorehouseConfigurationAutoPurging, diskConfig: StorehouseConfigurationDisk, transformer: StorehouseTransformer<Item>) throws {
        
        let disk    = try StorehouseOnDisk (configuration:    diskConfig, transformer: transformer)
        let memory  = StorehouseAutoPurging(configuration: purgingConfig, transformer: transformer)
        let storage = StorehouseHybrid(inMemory: memory, onDisk: disk)
        
        accessor.replaceStorage(storage)
    }
}

extension Warehouse : StorehouseProtocol
{
    @discardableResult
    internal func entry(forKey key: String) throws -> StorehouseEntry<Item>
    {
        return try accessor.entry(forKey: key)
    }
    
    internal func removeObject(forKey key: String) throws
    {
        try accessor.removeObject(forKey: key)
    }
    
    internal func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry? = nil) throws
    {
        try accessor.setObject(object, forKey: key, expiry: expiry)
    }
    
    internal func removeAll() throws
    {
        try accessor.removeAll()
    }
    
    internal func removeExpiredObjects() throws
    {
        try accessor.removeExpiredObjects()
    }
    
    internal func removeStoredObjects(since date: Date) throws
    {
        try accessor.removeStoredObjects(since: date)
    }
    
    internal func removeObjectIfExpired(forKey key: String) throws
    {
        try accessor.removeObjectIfExpired(forKey: key)
    }
}
