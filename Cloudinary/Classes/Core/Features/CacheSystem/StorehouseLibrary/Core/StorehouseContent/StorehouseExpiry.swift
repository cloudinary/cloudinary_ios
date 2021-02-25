//
//  StorehouseExpiry.swift
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
/// Helper enum to set the expiration date
///
internal enum StorehouseExpiry
{    
    ///
    /// Object will be expired in the nearest future
    ///
    case never
    
    ///
    /// Object will be expired in the nearest future
    ///
    case secondsFrom1970(TimeInterval)
    
    ///
    /// Object will be expired on the specified date
    ///
    case date(Date)
    
    ///
    /// Returns the appropriate date object
    ///
    internal var date : Date {
        
        switch self {
        case .never:
            // Ref: http://lists.apple.com/archives/cocoa-dev/2005/Apr/msg01833.html
            return Date(timeIntervalSince1970: 60 * 60 * 24 * 365 * 68) // Date.distantFuture
            
        case .secondsFrom1970(let interval):
            return Date(timeIntervalSince1970: interval)
            
        case .date(let date):
            return date
        }
    }
    
    ///
    /// Checks if cached object is expired according to expiration date
    ///
    internal var isExpired : Bool {
        return date.cld_inThePast
    }
    ///
    /// Checks if cached object is expired according to expiration date
    ///
    internal func isExpired(for base: Date) -> Bool {
        return date.timeIntervalSince1970 - base.timeIntervalSince1970 < 0
    }
}
