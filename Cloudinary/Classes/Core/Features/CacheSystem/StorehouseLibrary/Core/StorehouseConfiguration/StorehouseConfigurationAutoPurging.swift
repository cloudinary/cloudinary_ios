//
//  StorehouseConfigurationAutoPurging.swift
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
internal struct StorehouseConfigurationAutoPurging
{
    ///
    /// Expiry date that will be applied by default for every added object
    /// if it's not overridden in the add(key: object: expiry: completion:) method
    ///
    internal let expiry         : StorehouseExpiry
    
    ///
    /// In-memory capacity of the receiver.
    /// At the time this call is made, the in-memory cache will truncate its contents to the size given, if necessary.
    /// The in-memory capacity, measured in bytes, for the receiver.
    ///
    internal let memoryCapacity : Int
    
    ///
    /// The preferred memory usage after purge in bytes.
    /// During a purge, objects will be purged until the memory capacity drops below this limit.
    ///
    internal let preferredMemoryUsageAfterPurge : Int
    
    ///
    /// Initialies the `StorehouseConfigurationAutoPurging` instance with the given memory capacity and
    /// preferred memory usage after purge limit.
    ///
    /// Please note, the memory capacity must always be greater than or equal to the preferred memory usage after purge.
    ///
    /// - Parameters:
    ///     - expiry        : Expiry date that will be applied by default for every added object
    ///     - capacity      : The total memory capacity of the cache in bytes. `100 MB` by default.
    ///     - preferredUsage: The preferred memory usage after purge in bytes. ` 60 MB` by default.
    ///
    /// - Returns: The new `StorehouseConfigurationAutoPurging` instance.
    ///
    internal init(expiry: StorehouseExpiry = .never,
                memory capacity: Int = 100_000_000,
                preferredMemoryUsageAfterPurge preferredUsage: Int = 60_000_000
        )
    {
        self.expiry                         = expiry
        self.memoryCapacity                 = capacity
        self.preferredMemoryUsageAfterPurge = preferredUsage
    }
}
