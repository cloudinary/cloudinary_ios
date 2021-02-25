//
//  StorehouseProtocol.swift
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
/// A protocol used for saving and loading from storehouse
///
internal protocol StorehouseProtocol
{
    /// The generic type of the protocol
    associatedtype Item
    
    ///
    /// Tries to retrieve the object from the Storehouse.
    /// - Parameter key: Unique key to identify the object in the cache
    /// - Returns: Cached object or nil if not found
    ///
    @discardableResult
    func object(forKey key: String) throws -> Item
    
    ///
    /// Get cache entry which includes object with metadata.
    /// - Parameter key: Unique key to identify the object in the cache
    /// - Returns: Object wrapper with metadata or nil if not found
    ///
    @discardableResult
    func entry(forKey key: String) throws -> StorehouseEntry<Item>
    
    ///
    /// Removes the object by the given key.
    /// - Parameter key: Unique key to identify the object.
    ///
    func removeObject(forKey key: String) throws
    
    ///
    /// Saves passed object.
    /// - Parameter key: Unique key to identify the object in the cache.
    /// - Parameter object: Object that needs to be cached.
    /// - Parameter expiry: Overwrite expiry for this object only.
    ///
    func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry?) throws
    
    ///
    /// Check if an object exist by the given key.
    /// - Parameter key: Unique key to identify the object.
    ///
    @discardableResult
    func existsObject(forKey key: String) throws -> Bool
    
    ///
    /// Removes all objects from the cache storage.
    ///
    func removeAll() throws
    
    ///
    /// Clears all expired objects.
    ///
    func removeExpiredObjects() throws
    
    ///
    /// Clears all expired objects.
    ///
    func removeStoredObjects(since date: Date) throws
    
    ///
    /// Removed object for a given key only if it's expired
    ///
    /// - Parameter key: Unique key to identify the object in the storehouse
    ///
    func removeObjectIfExpired(forKey key: String) throws
    
    ///
    /// Check if an expired object by the given key.
    /// - Parameter key: Unique key to identify the object.
    ///
    @discardableResult
    func isExpiredObject(forKey key: String) throws -> Bool
}
internal extension StorehouseProtocol
{
    @discardableResult
    func object(forKey key: String) throws -> Item {
        
        return try entry(forKey: key).object
    }
    
    @discardableResult
    func existsObject(forKey key: String) throws -> Bool {
        
        do {
            try object(forKey: key)
            return true
        }
        catch {
            return false
        }
    }
    
    @discardableResult
    func isExpiredObject(forKey key: String) throws -> Bool {
        
        do {
            let anEntry = try entry(forKey: key)
            return anEntry.expiry.isExpired
        }
        catch {
            return true
        }
    }
}
///
/// A protocol used for saving and loading from in memory storehouse
///
internal protocol StorehouseMemoryProtocol : StorehouseProtocol
{
    var     memoryCapacity : Int { get }
    var currentMemoryUsage : Int { get }
}
///
/// A protocol used for saving and loading from file system storehouse
///
internal protocol StorehouseFileSystemProtocol : StorehouseProtocol
{
    var     diskCapacity : Int { get }
    var currentDiskUsage : Int { get }
}

///
/// A protocol used for saving and loading from a hybrid storehouse
///
internal typealias StorehouseHybridProtocol = StorehouseMemoryProtocol & StorehouseFileSystemProtocol
