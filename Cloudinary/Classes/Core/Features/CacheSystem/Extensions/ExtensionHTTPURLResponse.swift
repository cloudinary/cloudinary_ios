//
//  ExtensionHTTPURLResponse.swift
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

extension HTTPURLResponse {
    
    struct Header {
        
        struct CacheControl : Equatable {
            
            var  noCache : Bool { return values.contains("no-cache") }
            var  noStore : Bool { return values.contains("no-store") }
            var `public` : Bool { return values.contains("public" ) }
            var `private`: Bool { return values.contains("private") }
            var   maxAge : Int? { return value(for: "max-age" ).flatMap(Int.init) }
            var  sMaxAge : Int? { return value(for: "s-maxage").flatMap(Int.init) }
            var     noTransform : Bool { return values.contains("no-transform"    ) }
            var  mustRevalidate : Bool { return values.contains("must-revalidate" ) }
            var proxyRevalidate : Bool { return values.contains("proxy-revalidate") }
            
            init(string: String) {
                values = string.replacingOccurrences(of: " ", with: String()).split(separator: ",")
            }
            
            private let  values : [Substring]
            private func value(for key: String) -> String? {
                return values.filter { $0.contains(key) }.first.flatMap { $0.split(separator: "=").last }.map(String.init)
            }
        }
        struct FieldKey     : Equatable {
            
            static let cacheControl = FieldKey("Cache-Control")
            static let contentType  = FieldKey("Content-Type")
            static let date         = FieldKey("Date")
            static let lastModified = FieldKey("Last-Modified")
            static let expires      = FieldKey("Expires")
            static let pragma       = FieldKey("Pragma")
            static let etag         = FieldKey("Etag")
            
            let rawValue: String
            
            init(_ key: String) {
                rawValue = key
            }
            
            static func == (lhs: FieldKey, rhs: FieldKey) -> Bool {
                return lhs.rawValue == rhs.rawValue
            }
        }
        
        
        let fields : [AnyHashable:Any]
        
        func value(for key: FieldKey) -> String? {
            return fields[key.rawValue] as? String
        }
        
        /// MARK: - Computed Properties
        var cacheControl: CacheControl? { return value(for: .cacheControl).flatMap(CacheControl.init) }
        
        var contentType : String? { return value(for: .contentType) }
        
        var date         : Date? {
            
            guard let dateString = value(for: .date) else { return nil }
            return DateFormatter.cld_rfc1123.date(from: dateString) ?? DateFormatter.cld_rfc850.date(from: dateString) ?? DateFormatter.cld_asctime.date(from: dateString)
        }
        var expires      : Date? {
            
            guard let dateString = value(for: .expires) else { return nil }
            return DateFormatter.cld_rfc1123.date(from: dateString) ?? DateFormatter.cld_rfc850.date(from: dateString) ?? DateFormatter.cld_asctime.date(from: dateString)
        }
        var lastModified : Date? {
            
            guard let dateString = value(for: .lastModified) else { return nil }
            return DateFormatter.cld_rfc1123.date(from: dateString) ?? DateFormatter.cld_rfc850.date(from: dateString) ?? DateFormatter.cld_asctime.date(from: dateString)
        }
        
        var pragma : String? { return value(for: .pragma) }
        var etag   : String? { return value(for: .etag  ) }
    }
    
    var cld_header : Header {
        return Header(fields: allHeaderFields)
    }
    
    fileprivate var cld_validStatusCode: Bool {
        switch statusCode
        {
        case 200:fallthrough
        case 203:fallthrough
        case 300:fallthrough
        case 301:fallthrough
        case 302:fallthrough
        case 307:fallthrough
        case 410:return true
        default:
            // Uncacheable response status code
            return false
        }
    }
    
    var cld_code : HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
    
    /// Parses a header value that is formatted like the "Date" HTTP header.
    ///
    /// This parses the specific format allowed for the "Date" header, and any
    /// other header that uses the `HTTP-date` production.
    ///
    /// See [section 3.3.1 of RFC 2616][RFC] for details.
    ///
    /// [RFC]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
    ///
    /// - Parameter dateString: The string value of the HTTP header.
    /// - Returns: An `Date`, or `nil` if `dateString` contains an invalid format.

    internal func cld_expirationDate(forCache configuration: CLDURLCacheConfiguration) -> Date?
    {
        // Check Pragma: no-cache
        if let pragma = cld_header.pragma , pragma.lowercased().contains("no-cache")
        {
            // Uncacheable response
            return nil;
        }
        
        // Define "now" based on the request
        let currentDate = cld_header.date ?? Date()
        
        // Look at info from the Cache-Control: max-age=n header
        if let cacheControl = cld_header.cacheControl {
            
            if cacheControl.noStore {
                // Can't be cached
                return nil
            }
            
            if let maxAge = cacheControl.maxAge {
                
                switch maxAge > 0 {
                case true : return Date(timeInterval: TimeInterval(maxAge), since: currentDate)
                case false: return nil
                }
            }
        }
        
        // If not Cache-Control found, look at the Expires header
        if let expiresDate = cld_header.expires {

            let expirationInterval = expiresDate.timeIntervalSince(currentDate)
            switch expirationInterval > 0 {
            case true :
                // Convert remote expiration date to local expiration date
                return Date(timeIntervalSinceNow: expirationInterval)
            case false:
                // If the Expires header can't be parsed or is expired, do not cache
                return nil
            }
        }
        
        switch statusCode
        {
        case 302: fallthrough
        case 307:
            // If not explict cache control defined, do not cache those status
            return nil;
        default: break
        }
        
        // If no cache control defined, try some heristic to determine an expiration date
        if let lastModifiedDate = cld_header.lastModified {
            
            // Define the age of the document by comparing the Date header with the Last-Modified header
            let lastModifiedInterval = currentDate.timeIntervalSince(lastModifiedDate)
            
            switch lastModifiedInterval > 0
            {
            case true : return Date(timeIntervalSinceNow: lastModifiedInterval * configuration.lastModificationFraction)
            case false: return nil
            }
        }
        
        // If nothing permitted to define the cache expiration delay nor to restrict its cacheability, use a default cache expiration delay
        return Date(timeInterval: TimeInterval(configuration.expirationDelayDefault), since: currentDate)
    }
}
