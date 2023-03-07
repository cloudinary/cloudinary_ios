//
//  ExtensionCLDNHeaders.swift
//  Cloudinary
//
//  Created by Adi Mizrahi on 07/03/2023.
//

import Foundation
extension CLDNHTTPHeaders {
    mutating func buildIfModifiedSinceHeader(_ lastModifiedDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")

        let ifModifiedSinceHeader = dateFormatter.string(from: lastModifiedDate)
        self["If-Modified-Since"] = ifModifiedSinceHeader
    }
}
