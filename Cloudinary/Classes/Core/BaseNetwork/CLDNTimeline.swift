//
//  CLDNTimeline.swift
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

/// Responsible for computing the timing metrics for the complete lifecycle of a `CLDNRequest`.
internal struct CLDNTimeline {
    /// The time the request was initialized.
    internal let requestStartTime: CFAbsoluteTime

    /// The time the first bytes were received from or sent to the server.
    internal let initialResponseTime: CFAbsoluteTime

    /// The time when the request was completed.
    internal let requestCompletedTime: CFAbsoluteTime

    /// The time when the response serialization was completed.
    internal let serializationCompletedTime: CFAbsoluteTime

    /// The time interval in seconds from the time the request started to the initial response from the server.
    internal let latency: TimeInterval

    /// The time interval in seconds from the time the request started to the time the request completed.
    internal let requestDuration: TimeInterval

    /// The time interval in seconds from the time the request completed to the time response serialization completed.
    internal let serializationDuration: TimeInterval

    /// The time interval in seconds from the time the request started to the time response serialization completed.
    internal let totalDuration: TimeInterval

    /// Creates a new `CLDNTimeline` instance with the specified request times.
    ///
    /// - parameter requestStartTime:           The time the request was initialized. Defaults to `0.0`.
    /// - parameter initialResponseTime:        The time the first bytes were received from or sent to the server.
    ///                                         Defaults to `0.0`.
    /// - parameter requestCompletedTime:       The time when the request was completed. Defaults to `0.0`.
    /// - parameter serializationCompletedTime: The time when the response serialization was completed. Defaults
    ///                                         to `0.0`.
    ///
    /// - returns: The new `CLDNTimeline` instance.
    internal init(
        requestStartTime: CFAbsoluteTime = 0.0,
        initialResponseTime: CFAbsoluteTime = 0.0,
        requestCompletedTime: CFAbsoluteTime = 0.0,
        serializationCompletedTime: CFAbsoluteTime = 0.0)
    {
        self.requestStartTime = requestStartTime
        self.initialResponseTime = initialResponseTime
        self.requestCompletedTime = requestCompletedTime
        self.serializationCompletedTime = serializationCompletedTime

        self.latency = initialResponseTime - requestStartTime
        self.requestDuration = requestCompletedTime - requestStartTime
        self.serializationDuration = serializationCompletedTime - requestCompletedTime
        self.totalDuration = serializationCompletedTime - requestStartTime
    }
}

// MARK: - CustomStringConvertible

extension CLDNTimeline: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes the latency, the request
    /// duration and the total duration.
    internal var description: String {
        let latency = String(format: "%.3f", self.latency)
        let requestDuration = String(format: "%.3f", self.requestDuration)
        let serializationDuration = String(format: "%.3f", self.serializationDuration)
        let totalDuration = String(format: "%.3f", self.totalDuration)

        // NOTE: Had to move to string concatenation due to memory leak filed as rdar://26761490. Once memory leak is
        // fixed, we should move back to string interpolation by reverting commit 7d4a43b1.
        let timings = [
            "\"Latency\": " + latency + " secs",
            "\"Request Duration\": " + requestDuration + " secs",
            "\"Serialization Duration\": " + serializationDuration + " secs",
            "\"Total Duration\": " + totalDuration + " secs"
        ]

        return "Timeline: { " + timings.joined(separator: ", ") + " }"
    }
}

// MARK: - CustomDebugStringConvertible

extension CLDNTimeline: CustomDebugStringConvertible {
    /// The textual representation used when written to an output stream, which includes the request start time, the
    /// initial response time, the request completed time, the serialization completed time, the latency, the request
    /// duration and the total duration.
    internal var debugDescription: String {
        let requestStartTime = String(format: "%.3f", self.requestStartTime)
        let initialResponseTime = String(format: "%.3f", self.initialResponseTime)
        let requestCompletedTime = String(format: "%.3f", self.requestCompletedTime)
        let serializationCompletedTime = String(format: "%.3f", self.serializationCompletedTime)
        let latency = String(format: "%.3f", self.latency)
        let requestDuration = String(format: "%.3f", self.requestDuration)
        let serializationDuration = String(format: "%.3f", self.serializationDuration)
        let totalDuration = String(format: "%.3f", self.totalDuration)

        // NOTE: Had to move to string concatenation due to memory leak filed as rdar://26761490. Once memory leak is
        // fixed, we should move back to string interpolation by reverting commit 7d4a43b1.
        let timings = [
            "\"Request Start Time\": " + requestStartTime,
            "\"Initial Response Time\": " + initialResponseTime,
            "\"Request Completed Time\": " + requestCompletedTime,
            "\"Serialization Completed Time\": " + serializationCompletedTime,
            "\"Latency\": " + latency + " secs",
            "\"Request Duration\": " + requestDuration + " secs",
            "\"Serialization Duration\": " + serializationDuration + " secs",
            "\"Total Duration\": " + totalDuration + " secs"
        ]

        return "Timeline: { " + timings.joined(separator: ", ") + " }"
    }
}
