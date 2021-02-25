//
//  CLDURLCacheConfiguration.swift
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

@objcMembers
@objc(CLDURLCacheConfiguration)
internal class CLDURLCacheConfiguration : NSObject {
    
    internal enum LogingScope {
        case all
        case debugOnly
        case none
    }
    
    ///
    /// Used to mark if the cache should use secure disk storage or not
    ///
    /// Note: defualts to false
    ///
    internal var securedStorage : Bool
    
    ///
    /// The default maximum age of a cached file in seconds. (3 days)
    ///
    internal var minCacheResponseAge : TimeInterval
    
    ///
    /// The default maximum age of a cached file in seconds. (1 week)
    ///
    internal var maxCacheResponseAge : TimeInterval
    
    ///
    /// Default cache expiration delay if none defined (1 hour)
    ///
    internal var expirationDelayDefault : TimeInterval
    
    ///
    /// Minimum cache expiration delay toused if not specifieyid in the responce 5 minute
    ///
    internal var expirationDelayMinimum : TimeInterval
    
    ///
    /// Default modification fraction is 10% since Last-Modified suggested by RFC2616 section 13.2.4
    ///
    internal var lastModificationFraction : Double
    
    ///
    /// Default loging scope is debug only 
    ///
    internal var logingScope : LogingScope
    
    ///
    ///
    ///
    internal class var defualt : CLDURLCacheConfiguration {
        return CLDURLCacheConfiguration()
    }
    
    ///
    ///
    ///
    internal override init()
    {
        self.securedStorage           = false
        self.minCacheResponseAge      = TimeInterval(604800)
        self.maxCacheResponseAge      = TimeInterval(259200)
        self.expirationDelayDefault   = TimeInterval(5 * 60 * 60) // 1 hours
        self.expirationDelayMinimum   = TimeInterval(5 * 60     ) // 5 minutes
        self.lastModificationFraction = Double(0.1)
        self.logingScope              = .debugOnly
        super.init()
    }
}
