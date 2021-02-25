//
//  StorehouseConfigurationDisk.swift
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
internal struct StorehouseConfigurationDisk
{
    ///
    /// The name of disk storage, this will be used as folder name within directory
    ///
    internal let name           : String
    
    ///
    /// Expiry date that will be applied by default for every added object
    /// if it's not overridden in the add(key: object: expiry:) method
    ///
    internal let expiry         : StorehouseExpiry
    
    ///
    /// Maximum size of the disk cache storage (in bytes)
    ///
    internal let maximumSize    : Int
    
    ///
    /// Data protection is used to store files in an encrypted format on disk and to decrypt them on demand.
    /// Support only on iOS and tvOS.
    ///
    internal let protectionType : FileProtectionType?
    
    ///
    ///
    ///
    internal init(name: String,
                expiry: StorehouseExpiry = .never,
                maxSize: Int = 0,
                protectionType: FileProtectionType? = nil)
    {
        self.name           = name
        self.expiry         = expiry
        self.maximumSize    = maxSize
        self.protectionType = protectionType
    }
}
