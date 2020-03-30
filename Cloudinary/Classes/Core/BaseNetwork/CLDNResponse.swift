//
//  CLDNResponse.swift
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

/// Used to store all data associated with an non-serialized response of a data or upload request.
internal struct CLDNDefaultDataResponse {
    /// The URL request sent to the server.
    internal let request: URLRequest?

    /// The server's response to the URL request.
    internal let response: HTTPURLResponse?

    /// The data returned by the server.
    internal let data: Data?

    /// The error encountered while executing or validating the request.
    internal let error: Error?

    /// The timeline of the complete lifecycle of the request.
    internal let timeline: CLDNTimeline

    var _metrics: AnyObject?

    /// Creates a `CLDNDefaultDataResponse` instance from the specified parameters.
    ///
    /// - Parameters:
    ///   - request:  The URL request sent to the server.
    ///   - response: The server's response to the URL request.
    ///   - data:     The data returned by the server.
    ///   - error:    The error encountered while executing or validating the request.
    ///   - timeline: The timeline of the complete lifecycle of the request. `CLDNTimeline()` by default.
    ///   - metrics:  The task metrics containing the request / response statistics. `nil` by default.
    internal init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        error: Error?,
        timeline: CLDNTimeline = CLDNTimeline(),
        metrics: AnyObject? = nil)
    {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
        self.timeline = timeline
    }
}

// MARK: -

/// Used to store all data associated with a serialized response of a data or upload request.
internal struct CLDNDataResponse<Value> {
    /// The URL request sent to the server.
    internal let request: URLRequest?

    /// The server's response to the URL request.
    internal let response: HTTPURLResponse?

    /// The data returned by the server.
    internal let data: Data?

    /// The result of response serialization.
    internal let result: CLDNResult<Value>

    /// The timeline of the complete lifecycle of the request.
    internal let timeline: CLDNTimeline

    /// Returns the associated value of the result if it is a success, `nil` otherwise.
    internal var value: Value? { return result.value }

    /// Returns the associated error value if the result if it is a failure, `nil` otherwise.
    internal var error: Error? { return result.error }

    var _metrics: AnyObject?

    /// Creates a `CLDNDataResponse` instance with the specified parameters derived from response serialization.
    ///
    /// - parameter request:  The URL request sent to the server.
    /// - parameter response: The server's response to the URL request.
    /// - parameter data:     The data returned by the server.
    /// - parameter result:   The result of response serialization.
    /// - parameter timeline: The timeline of the complete lifecycle of the `CLDNRequest`. Defaults to `CLDNTimeline()`.
    ///
    /// - returns: The new `CLDNDataResponse` instance.
    internal init(
        request: URLRequest?,
        response: HTTPURLResponse?,
        data: Data?,
        result: CLDNResult<Value>,
        timeline: CLDNTimeline = CLDNTimeline())
    {
        self.request = request
        self.response = response
        self.data = data
        self.result = result
        self.timeline = timeline
    }
}

// MARK: -

extension CLDNDataResponse: CustomStringConvertible, CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    internal var description: String {
        return result.debugDescription
    }

    /// The debug textual representation used when written to an output stream, which includes the URL request, the URL
    /// response, the server data, the response serialization result and the timeline.
    internal var debugDescription: String {
        let requestDescription = request.map { "\($0.httpMethod ?? "GET") \($0)"} ?? "nil"
        let requestBody = request?.httpBody.map { String(decoding: $0, as: UTF8.self) } ?? "None"
        let responseDescription = response.map { "\($0)" } ?? "nil"
        let responseBody = data.map { String(decoding: $0, as: UTF8.self) } ?? "None"

        return """
        [Request]: \(requestDescription)
        [Request Body]: \n\(requestBody)
        [Response]: \(responseDescription)
        [Response Body]: \n\(responseBody)
        [Result]: \(result)
        [Timeline]: \(timeline.debugDescription)
        """
    }
}

// MARK: -

protocol CLDNResponse {
    /// The task metrics containing the request / response statistics.
    var _metrics: AnyObject? { get set }
    mutating func CLDN_Add(_ metrics: AnyObject?)
}

extension CLDNResponse {
    mutating func CLDN_Add(_ metrics: AnyObject?) {
        #if !os(watchOS)
            guard #available(iOS 10.0, macOS 10.12, tvOS 10.0, *) else { return }
            guard let metrics = metrics as? URLSessionTaskMetrics else { return }

            _metrics = metrics
        #endif
    }
}

// MARK: -

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension CLDNDefaultDataResponse: CLDNResponse {
#if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    internal var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}

@available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
extension CLDNDataResponse: CLDNResponse {
#if !os(watchOS)
    /// The task metrics containing the request / response statistics.
    internal var metrics: URLSessionTaskMetrics? { return _metrics as? URLSessionTaskMetrics }
#endif
}
