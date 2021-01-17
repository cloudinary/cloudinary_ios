//
//  StorehouseHybrid.swift
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
/// Use both memory and disk storage. Try on memory first.
///
public final class StorehouseHybrid<StoredItem> : StorehouseAny <StoredItem>
{
    /// MARK: - Public Properties
    public let memoryStorage : StorehouseAnyInMemory<Item>
    public let   diskStorage : StorehouseAnyFileSystem<Item>
    
    /// MARK: - Computed Public Properties
    public var memoryCapacity : Int {
        return memoryStorage.memoryCapacity
    }
    
    public var diskCapacity : Int {
        return diskStorage.diskCapacity
    }
    
    public var currentMemoryUsage : Int {
        return memoryStorage.currentMemoryUsage
    }
    
    public var currentDiskUsage: Int {
        return diskStorage.currentDiskUsage
    }
    
    /// MARK: - Initializers
    public init(inMemory memory: StorehouseAnyInMemory<Item>, onDisk disk: StorehouseAnyFileSystem<Item>)
    {    
        self.memoryStorage = memory
        self.diskStorage   =   disk
    }
    // MARK: - StorehouseHybridProtocol
    @discardableResult
    public override func entry(forKey key: String) throws -> StorehouseEntry<Item>
    {
        do {
            return try memoryStorage.entry(forKey: key)
        }
        catch {
            let entry = try diskStorage.entry(forKey: key)
            // set back to memoryStorage
            try memoryStorage.setObject(entry.object, forKey: key, expiry: entry.expiry)
            return entry
        }
    }
    
    public override func removeObject(forKey key: String) throws
    {
        try memoryStorage.removeObject(forKey: key)
        try   diskStorage.removeObject(forKey: key)
    }
    
    public override func setObject(_ object: Item, forKey key: String, expiry: StorehouseExpiry? = nil) throws
    {
        try memoryStorage.setObject(object, forKey: key, expiry: expiry)
        try   diskStorage.setObject(object, forKey: key, expiry: expiry)
    }
    
    public override func removeAll() throws
    {
        try memoryStorage.removeAll()
        try   diskStorage.removeAll()
    }

    public override func removeExpiredObjects() throws
    {
        try memoryStorage.removeExpiredObjects()
        try   diskStorage.removeExpiredObjects()
    }
    
    public override func removeStoredObjects(since date: Date) throws
    {
        try memoryStorage.removeStoredObjects(since: date)
        try   diskStorage.removeStoredObjects(since: date)
    }
    
    public override func removeObjectIfExpired(forKey key: String) throws
    {    
        try memoryStorage.removeObjectIfExpired(forKey: key)
        try   diskStorage.removeObjectIfExpired(forKey: key)
    }
}
