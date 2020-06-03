//
//  CLDNResult+CloudinaryTests.swift
//  Cloudinary_Tests
//
//  Created on 30/03/2020.
//  Copyright (c) 2020 Cloudinary. All rights reserved.
//

@testable import Cloudinary
import Foundation

// MARK: - MAP Method

extension CLDNResult
{
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
}
