//
//  WarehouseTransformerFactory.swift
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
internal class WarehouseTransformerFactory
{
    /// MARK: - Types
    
    ///
    /// Used to wrap Codable object
    ///
    internal struct CodableWrapper<CodableType: Codable>: Codable
    {
        enum CodingKeys : String , CodingKey
        {
            case object
        }
        
        internal let object : CodableType
        internal init(object: CodableType) {
            self.object = object
        }
    }
    
    ///
    ///
    ///
    private init() { }
    
    ///
    ///
    ///
    internal static func forCodable<Item: Codable>(ofType: Item.Type) -> StorehouseTransformer<Item>
    {    
        let   toData : (Item) throws -> Data = { object in
            
            let wrapper = CodableWrapper<Item>(object: object)
            let encoder = JSONEncoder()
            return try encoder.encode(wrapper)
        }
        let fromData : (Data) throws -> Item = { data in
            
            let decoder = JSONDecoder()
            return try decoder.decode(CodableWrapper<Item>.self, from: data).object
        }
        
        return StorehouseTransformer<Item>(toData: toData, fromData: fromData)
    }
    
    ///
    ///
    ///
    internal static func forCoding<Item: NSCoding>(ofType: Item.Type) -> StorehouseTransformer<Item>
    {
        let   toData : (Item) throws -> Data = { (object) in
            
            let data = NSMutableData()
            //let archiver = NSKeyedArchiver(forWritingWith: data)
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.requiresSecureCoding = false
            
            archiver.encode(object, forKey: NSKeyedArchiveRootObjectKey)
            archiver.finishEncoding()
            return data as Data
        }
        let fromData : (Data) throws -> Item = { (data) in
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            unarchiver.requiresSecureCoding = false
            
            let object = unarchiver.decodeObject(of: [Item.self], forKey: NSKeyedArchiveRootObjectKey)
            unarchiver.finishDecoding()
            return try (object as? Item).cld_unwrapOrThrow(error: StorehouseError.decodingFailed)
        }
        
        return StorehouseTransformer<Item>(toData: toData, fromData: fromData)
    }
    
    ///
    ///
    ///
    internal static func forSecuredCoding<Item: NSCoding>(ofType: Item.Type) -> StorehouseTransformer<Item>
    {
        let   toData : (Item) throws -> Data = { (object) in
            
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.requiresSecureCoding = true
            
            archiver.encode(object, forKey: NSKeyedArchiveRootObjectKey)
            archiver.finishEncoding()
            return data as Data
        }
        let fromData : (Data) throws -> Item = { (data) in
            
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            unarchiver.requiresSecureCoding = true
            
            let object = unarchiver.decodeObject(of: [Item.self], forKey: NSKeyedArchiveRootObjectKey)
            unarchiver.finishDecoding()
            return try (object as? Item).cld_unwrapOrThrow(error: StorehouseError.decodingFailed)
        }
        
        return StorehouseTransformer<Item>(toData: toData, fromData: fromData)
    }
}
