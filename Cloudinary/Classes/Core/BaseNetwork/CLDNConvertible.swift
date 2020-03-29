//
//  CLDNConvertible.swift
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// Types adopting the `CLDNURLConvertible` protocol can be used to construct URLs, which are then used to construct
/// URL requests.
internal protocol CLDNURLConvertible {
    /// Returns a URL that conforms to RFC 2396 or throws an `Error`.
    ///
    /// - throws: An `Error` if the type cannot be converted to a `URL`.
    ///
    /// - returns: A URL or throws an `Error`.
    func CLDN_AsURL() throws -> URL
}

extension String: CLDNURLConvertible {
    /// Returns a URL if `self` represents a valid URL string that conforms to RFC 2396 or throws an `CLDNError`.
    ///
    /// - throws: An `CLDNError.invalidURL` if `self` is not a valid URL string.
    ///
    /// - returns: A URL or throws an `CLDNError`.
    internal func CLDN_AsURL() throws -> URL {
        guard let url = URL(string: self) else { throw CLDNError.invalidURL(url: self) }
        return url
    }
}

extension URL: CLDNURLConvertible {
    /// Returns self.
    internal func CLDN_AsURL() throws -> URL { return self }
}

extension URLComponents: CLDNURLConvertible {
    /// Returns a URL if `url` is not nil, otherwise throws an `Error`.
    ///
    /// - throws: An `CLDNError.invalidURL` if `url` is `nil`.
    ///
    /// - returns: A URL or throws an `CLDNError`.
    internal func CLDN_AsURL() throws -> URL {
        guard let url = url else { throw CLDNError.invalidURL(url: self) }
        return url
    }
}

// MARK: -

/// Types adopting the `CLDNURLRequestConvertible` protocol can be used to construct URL requests.
internal protocol CLDNURLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    ///
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    ///
    /// - returns: A URL request.
    func CLDN_AsURLRequest() throws -> URLRequest
}

extension CLDNURLRequestConvertible {
    /// The URL request.
    internal var urlRequest: URLRequest? { return try? CLDN_AsURLRequest() }
}

extension URLRequest: CLDNURLRequestConvertible {
    /// Returns a URL request or throws if an `Error` was encountered.
    internal func CLDN_AsURLRequest() throws -> URLRequest { return self }
}

// MARK: -

extension URLRequest {
    /// Creates an instance with the specified `method`, `urlString` and `headers`.
    ///
    /// - parameter url:     The URL.
    /// - parameter method:  The HTTP method.
    /// - parameter headers: The HTTP headers. `nil` by default.
    ///
    /// - returns: The new `URLRequest` instance.
    internal init(url: CLDNURLConvertible, method: CLDNHTTPMethod, headers: CLDNHTTPHeaders? = nil) throws {
        let url = try url.CLDN_AsURL()

        self.init(url: url)

        httpMethod = method.rawValue

        if let headers = headers {
            for (headerField, headerValue) in headers {
                setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
    }

    func adapt(using adapter: CLDNRequestAdapter?) throws -> URLRequest {
        guard let adapter = adapter else { return self }
        return try adapter.CLDN_Adapt(self)
    }
}
