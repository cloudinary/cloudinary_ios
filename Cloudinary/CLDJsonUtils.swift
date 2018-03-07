//
//  CLDJsonUtils.swift
//
//  Copyright (c) 2018 Cloudinary (http://cloudinary.com)
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

internal func fromJson<T:Decodable>(object: [String: String]) -> T? {
    if let jsonData = try? JSONSerialization.data(withJSONObject: object),
       let object = try? getJsonDecoder().decode(T.self, from: jsonData) {
        return object
    }

    return nil
}

internal func asJsonArray<T:Encodable>(arr: [T]) -> String {
    return "[\(arr.map {asJson(object: $0)}.joined(separator: ","))]"
}

internal func asJson<T:Encodable>(object: T) -> String {
    return String(data: try! getJsonEncoder().encode(object), encoding: String.Encoding.utf8)!
}

fileprivate func getJsonDecoder() -> JSONDecoder {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(getDateFormatter())
    return jsonDecoder
}

fileprivate func getJsonEncoder() -> JSONEncoder {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .formatted(getDateFormatter())
    return jsonEncoder
}

fileprivate func getDateFormatter() -> DateFormatter {
    let iso8601Formatter = DateFormatter()
    iso8601Formatter.calendar = Calendar(identifier: .iso8601)
    iso8601Formatter.locale = Locale(identifier: "en_US_POSIX")
    iso8601Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXX"
    iso8601Formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return iso8601Formatter
}

