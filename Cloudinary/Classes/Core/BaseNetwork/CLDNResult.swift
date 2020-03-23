//
//  CLDNResult.swift
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

/// Used to represent whether a request was successful or encountered an error.
///
/// - success: The request and all post processing operations were successful resulting in the serialization of the
///            provided associated value.
///
/// - failure: The request encountered an error resulting in a failure. The associated values are the original data
///            provided by the server as well as the error that caused the failure.
internal enum CLDNResult<Value> {
    case success(Value)
    case failure(Error)

    /// Returns `true` if the result is a success, `false` otherwise.
    internal var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    internal var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    internal var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    internal var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}

// MARK: - CustomStringConvertible

extension CLDNResult: CustomStringConvertible {
    /// The textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure.
    internal var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

// MARK: - CustomDebugStringConvertible

extension CLDNResult: CustomDebugStringConvertible {
    /// The debug textual representation used when written to an output stream, which includes whether the result was a
    /// success or failure in addition to the value or error.
    internal var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

// MARK: - Functional APIs

extension CLDNResult {
    /// Creates a `CLDNResult` instance from the result of a closure.
    ///
    /// A failure result is created when the closure throws, and a success result is created when the closure
    /// succeeds without throwing an error.
    ///
    ///     func someString() throws -> String { ... }
    ///
    ///     let result = CLDNResult(value: {
    ///         return try someString()
    ///     })
    ///
    ///     // The type of result is CLDNResult<String>
    ///
    /// The trailing closure syntax is also supported:
    ///
    ///     let result = CLDNResult { try someString() }
    ///
    /// - parameter value: The closure to execute and create the result for.
    internal init(value: () throws -> Value) {
        do {
            self = try .success(value())
        } catch {
            self = .failure(error)
        }
    }

    /// Returns the success value, or throws the failure error.
    ///
    ///     let possibleString: Result<String> = .success("success")
    ///     try print(possibleString.unwrap())
    ///     // Prints "success"
    ///
    ///     let noString: CLDNResult<String> = .failure(error)
    ///     try print(noString.unwrap())
    ///     // Throws error
    internal func unwrap() throws -> Value {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    /// Evaluates the specified closure when the `CLDNResult` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `map` method with a closure that does not throw. For example:
    ///
    ///     let possibleData: CLDNResult<Data> = .success(Data())
    ///     let possibleInt = possibleData.map { $0.count }
    ///     try print(possibleInt.unwrap())
    ///     // Prints "0"
    ///
    ///     let noData: CLDNResult<Data> = .failure(error)
    ///     let noInt = noData.map { $0.count }
    ///     try print(noInt.unwrap())
    ///     // Throws error
    ///
    /// - parameter transform: A closure that takes the success value of the `CLDNResult` instance.
    ///
    /// - returns: A `CLDNResult` containing the result of the given closure. If this instance is a failure, returns the
    ///            same failure.
    internal func map<T>(_ transform: (Value) -> T) -> CLDNResult<T> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Evaluates the specified closure when the `CLDNResult` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `flatMap` method with a closure that may throw an error. For example:
    ///
    ///     let possibleData: CLDNResult<Data> = .success(Data(...))
    ///     let possibleObject = possibleData.flatMap {
    ///         try JSONSerialization.jsonObject(with: $0)
    ///     }
    ///
    /// - parameter transform: A closure that takes the success value of the instance.
    ///
    /// - returns: A `CLDNResult` containing the result of the given closure. If this instance is a failure, returns the
    ///            same failure.
    internal func flatMap<T>(_ transform: (Value) throws -> T) -> CLDNResult<T> {
        switch self {
        case .success(let value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    /// Evaluates the specified closure when the `CLDNResult` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `mapError` function with a closure that does not throw. For example:
    ///
    ///     let possibleData: CLDNResult<Data> = .failure(someError)
    ///     let withMyError: CLDNResult<Data> = possibleData.mapError { MyError.error($0) }
    ///
    /// - Parameter transform: A closure that takes the error of the instance.
    /// - Returns: A `CLDNResult` instance containing the result of the transform. If this instance is a success, returns
    ///            the same instance.
    internal func mapError<T: Error>(_ transform: (Error) -> T) -> CLDNResult {
        switch self {
        case .failure(let error):
            return .failure(transform(error))
        case .success:
            return self
        }
    }

    /// Evaluates the specified closure when the `CLDNResult` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `flatMapError` function with a closure that may throw an error. For example:
    ///
    ///     let possibleData: CLDNResult<Data> = .success(Data(...))
    ///     let possibleObject = possibleData.flatMapError {
    ///         try someFailableFunction(taking: $0)
    ///     }
    ///
    /// - Parameter transform: A throwing closure that takes the error of the instance.
    ///
    /// - Returns: A `CLDNResult` instance containing the result of the transform. If this instance is a success, returns
    ///            the same instance.
    internal func flatMapError<T: Error>(_ transform: (Error) throws -> T) -> CLDNResult {
        switch self {
        case .failure(let error):
            do {
                return try .failure(transform(error))
            } catch {
                return .failure(error)
            }
        case .success:
            return self
        }
    }

    /// Evaluates the specified closure when the `CLDNResult` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `withValue` function to evaluate the passed closure without modifying the `CLDNResult` instance.
    ///
    /// - Parameter closure: A closure that takes the success value of this instance.
    /// - Returns: This `CLDNResult` instance, unmodified.
    @discardableResult
    internal func withValue(_ closure: (Value) throws -> Void) rethrows -> CLDNResult {
        if case let .success(value) = self { try closure(value) }

        return self
    }

    /// Evaluates the specified closure when the `CLDNResult` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `withError` function to evaluate the passed closure without modifying the `CLDNResult` instance.
    ///
    /// - Parameter closure: A closure that takes the success value of this instance.
    /// - Returns: This `CLDNResult` instance, unmodified.
    @discardableResult
    internal func withError(_ closure: (Error) throws -> Void) rethrows -> CLDNResult {
        if case let .failure(error) = self { try closure(error) }

        return self
    }

    /// Evaluates the specified closure when the `CLDNResult` is a success.
    ///
    /// Use the `ifSuccess` function to evaluate the passed closure without modifying the `CLDNResult` instance.
    ///
    /// - Parameter closure: A `Void` closure.
    /// - Returns: This `CLDNResult` instance, unmodified.
    @discardableResult
    internal func ifSuccess(_ closure: () throws -> Void) rethrows -> CLDNResult {
        if isSuccess { try closure() }

        return self
    }

    /// Evaluates the specified closure when the `CLDNResult` is a failure.
    ///
    /// Use the `ifFailure` function to evaluate the passed closure without modifying the `CLDNResult` instance.
    ///
    /// - Parameter closure: A `Void` closure.
    /// - Returns: This `CLDNResult` instance, unmodified.
    @discardableResult
    internal func ifFailure(_ closure: () throws -> Void) rethrows -> CLDNResult {
        if isFailure { try closure() }

        return self
    }
}
