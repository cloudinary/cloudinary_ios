// 
//  CLDNDataResponse+CloudinaryTests.swift
//  Cloudinary_Tests
//
//  Created on 30/03/2020.
//  Copyright (c) 2020 Cloudinary. All rights reserved.
//

@testable import Cloudinary
import Foundation

// MARK: - MAP Method

extension CLDNDataResponse {
    /// Evaluates the specified closure when the result of this `CLDNDataResponse` is a success, passing the unwrapped
    /// result value as a parameter.
    ///
    /// Use the `map` method with a closure that does not throw. For example:
    ///
    ///     let possibleData: CLDNDataResponse<Data> = ...
    ///     let possibleInt = possibleData.map { $0.count }
    ///
    /// - parameter transform: A closure that takes the success value of the instance's result.
    ///
    /// - returns: A `CLDNDataResponse` whose result wraps the value returned by the given closure. If this instance's
    ///            result is a failure, returns a response wrapping the same failure.
    internal func map<T>(_ transform: (Value) -> T) -> CLDNDataResponse<T> {
        var response = CLDNDataResponse<T>(
            request: request,
            response: self.response,
            data: data,
            result: result.map(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    /// Evaluates the given closure when the result of this `CLDNDataResponse` is a success, passing the unwrapped result
    /// value as a parameter.
    ///
    /// Use the `flatMap` method with a closure that may throw an error. For example:
    ///
    ///     let possibleData: CLDNDataResponse<Data> = ...
    ///     let possibleObject = possibleData.flatMap {
    ///         try JSONSerialization.jsonObject(with: $0)
    ///     }
    ///
    /// - parameter transform: A closure that takes the success value of the instance's result.
    ///
    /// - returns: A success or failure `CLDNDataResponse` depending on the result of the given closure. If this instance's
    ///            result is a failure, returns the same failure.
    internal func flatMap<T>(_ transform: (Value) throws -> T) -> CLDNDataResponse<T> {
        var response = CLDNDataResponse<T>(
            request: request,
            response: self.response,
            data: data,
            result: result.flatMap(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    /// Evaluates the specified closure when the `CLDNDataResponse` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `mapError` function with a closure that does not throw. For example:
    ///
    ///     let possibleData: CLDNDataResponse<Data> = ...
    ///     let withMyError = possibleData.mapError { MyError.error($0) }
    ///
    /// - Parameter transform: A closure that takes the error of the instance.
    /// - Returns: A `CLDNDataResponse` instance containing the result of the transform.
    internal func mapError<E: Error>(_ transform: (Error) -> E) -> CLDNDataResponse {
        var response = CLDNDataResponse(
            request: request,
            response: self.response,
            data: data,
            result: result.mapError(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }

    /// Evaluates the specified closure when the `CLDNDataResponse` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `flatMapError` function with a closure that may throw an error. For example:
    ///
    ///     let possibleData: CLDNDataResponse<Data> = ...
    ///     let possibleObject = possibleData.flatMapError {
    ///         try someFailableFunction(taking: $0)
    ///     }
    ///
    /// - Parameter transform: A throwing closure that takes the error of the instance.
    ///
    /// - Returns: A `CLDNDataResponse` instance containing the result of the transform.
    internal func flatMapError<E: Error>(_ transform: (Error) throws -> E) -> CLDNDataResponse {
        var response = CLDNDataResponse(
            request: request,
            response: self.response,
            data: data,
            result: result.flatMapError(transform),
            timeline: timeline
        )

        response._metrics = _metrics

        return response
    }
}
