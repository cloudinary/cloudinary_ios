//
//  ExtensionDateFormatter.swift
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

extension DateFormatter {
    
    fileprivate static let cld_posixLocale       = Locale(identifier: "en_US_POSIX")
    
    fileprivate static let cld_gregorianCalendar : Calendar = {
        
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()
    
    ///
    ///
    ///
    internal static let cld_rfc1123 : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.locale     = cld_posixLocale
        formatter.calendar   = cld_gregorianCalendar
        formatter.timeZone   = cld_gregorianCalendar.timeZone
        formatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        formatter.isLenient  = false
        return formatter
    }()
    
    ///
    ///
    ///
    internal static let cld_rfc850  : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.locale     = cld_posixLocale
        formatter.calendar   = cld_gregorianCalendar
        formatter.timeZone   = cld_gregorianCalendar.timeZone
        formatter.dateFormat = "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss 'GMT'"
        formatter.isLenient  = false
        // From RFC 2616 Section 19.3 Tolerant Applications:
        // > HTTP/1.1 clients and caches SHOULD assume that an RFC-850 date
        // > which appears to be more than 50 years in the future is in fact
        // > in the past (this helps solve the "year 2000" problem).
        //DateComponents(year: -49)
        var dateComponents  = DateComponents()
        dateComponents.year = -49
        formatter.twoDigitStartDate = (cld_gregorianCalendar as NSCalendar).date(byAdding: dateComponents, to: Date(), options: [])
        return formatter
    }()
    
    ///
    ///
    ///
    internal static let cld_asctime : DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.locale   = cld_posixLocale
        formatter.calendar = cld_gregorianCalendar
        formatter.timeZone = cld_gregorianCalendar.timeZone
        // NB: asctime specifies day as ( 2DIGIT | ( SP 1DIGIT ) ). There's no way to represent this with a
        // date format, ICU seems to treat stretches of consecutive whitespace all as a single space, so this should
        // still parse just fine. Luckily we don't have to generate these strings.
        formatter.dateFormat = "EEE MMM dd HH':'mm':'ss yyyy"
        formatter.isLenient  = false
        return formatter
    }()
}
