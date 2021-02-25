//
//  StorehouseConfigurationInMemory.swift
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
internal struct StorehouseConfigurationInMemory
{
    ///
    /// Expiry date that will be applied by default for every added object
    /// if it's not overridden in the add(key: object: expiry: completion:) method
    ///
    internal let expiry         : StorehouseExpiry
    
    ///
    /// The maximum number of objects in memory the cache should hold.
    /// If 0, there is no count limit. The default value is 0.
    ///
    internal let countLimit     : UInt
    
    ///
    /// The maximum total cost that the cache can hold before it starts evicting objects.
    /// If 0, there is no total cost limit. The default value is 0
    ///
    internal let totalCostLimit : UInt
    
    ///
    ///
    ///
    internal init(expiry: StorehouseExpiry = .never,
                countLimit: UInt = 0,
                totalCostLimit: UInt = 0)
    {
        self.expiry         = expiry
        self.countLimit     = countLimit
        self.totalCostLimit = totalCostLimit
    }
}
