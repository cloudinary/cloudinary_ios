//
//  StorehouseAccessor.swift
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
///
///
public class StorehouseAccessor<StoredItem>
{
    /// MARK: - Typealias
    public typealias Item = StoredItem
    
    /// MARK: - Public Properties
    public var storehouse  : StorehouseHybrid<Item>
    public let accessQueue : DispatchQueue
    
    public var memoryCapacity : Int {
        var value : Int!
        accessQueue.sync { value = storehouse.memoryCapacity }
        return value
    }
    
    public var diskCapacity : Int {
        var value : Int!
        accessQueue.sync { value = storehouse.diskCapacity }
        return value
    }
    
    public var currentMemoryUsage : Int {
        var value : Int!
        accessQueue.sync { value = storehouse.currentMemoryUsage }
        return value
    }
    
    public var currentDiskUsage: Int {
        var value : Int!
        accessQueue.sync { value = storehouse.currentDiskUsage }
        return value
    }
    
    /// MARK: - Initializers
    public init(storage: StorehouseHybrid<Item>, queue: DispatchQueue)
    {
        self.storehouse  = storage
        self.accessQueue = queue
    }
    
    internal func replaceStorage(_ storage: StorehouseHybrid<Item>)
    {
        accessQueue.sync(flags: [.barrier]) {
            self.storehouse = storage
        }
    }
}
extension StorehouseAccessor : StorehouseProtocol
{
    @discardableResult
    public func entry(forKey key: String) throws -> StorehouseEntry<Item>
    {
        var entry : StorehouseEntry<Item>!
        try accessQueue.sync {
            entry = try storehouse.entry(forKey: key)
        }
        return entry
    }
    
    public func removeObject(forKey key: String) throws
    {
        try accessQueue.sync(flags: [.barrier]) {
            try self.storehouse.removeObject(forKey: key)
        }
    }
    
    public func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry? = nil) throws
    {
        try accessQueue.sync(flags: [.barrier]) {
            try storehouse.setObject(object, forKey: key, expiry: expiry)
        }
    }
    
    public func removeAll() throws
    {
        try accessQueue.sync(flags: [.barrier]) {
            try storehouse.removeAll()
        }
    }
    
    public func removeExpiredObjects() throws
    {
        try accessQueue.sync(flags: [.barrier]) {
            try storehouse.removeExpiredObjects()
        }
    }
    
    public func removeStoredObjects(since date: Date) throws
    {
        try accessQueue.sync(flags: [.barrier]) {
            try storehouse.removeStoredObjects(since: date)
        }
    }
    
    public func removeObjectIfExpired(forKey key: String) throws
    {
        try accessQueue.sync(flags: [.barrier]) {
            try storehouse.removeObjectIfExpired(forKey: key)
        }
    }
}
