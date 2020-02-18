//
//
//  CLDPreprocessChain.swift
//
//  Copyright (c) 2017 Cloudinary (http://cloudinary.com)
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

public typealias CLDPreprocessStep<T> = (T) throws -> T
public typealias CLDResourceEncoder<T> = (T) throws -> URL?

/**
 The CLDPreprocessChain is a generic base class used to run preprocessing on resources before uploading.
 Supports processing, validations and encoders, all fully customizable. Note: This class should not be used
 directly, use a concrete subclass (e.g. CLDImagePreprocessingChain).
*/
public class CLDPreprocessChain<T> {
    internal var encoder: CLDResourceEncoder<T>?

    var chain = [CLDPreprocessStep<T>]()

    internal init() {
    }

    /**
      Returns true if the chain is empty (= NOP chain).
    */
    public func isEmpty() -> Bool {
        return encoder == nil && chain.isEmpty
    }

    /**
     Add a step to the chain, for preprocess or validation
     
      - parameter preprocess:  A CLDPreprocessStep to be used to encode the resource after the processing
    */
    @discardableResult
    public func addStep(_ preprocess: @escaping CLDPreprocessStep<T>) -> Self {
        chain.append(preprocess)
        return self
    }

    /**
     Set a custom resource encoder to use when saving the resource after executing the chain
     
      - parameter encoder:  A CLDResourceEncoder to be used to encode the resource after the processing
    */
    @discardableResult
    public func setEncoder(_ encoder: @escaping CLDResourceEncoder<T>) -> Self {
        self.encoder = encoder
        return self
    }

    internal func execute(resourceData: Any) throws -> URL {
        try verifyEncoder()
        let resource: T? = try decodeResource(resourceData)
        if var resource = resource {
            for preprocess in chain {
                resource = try preprocess(resource)
            }

            if let url = try encoder!(resource) {
                return url
            } else {
                throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Error encoding resource")
            }
        } else {
            throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "Error decoding resource")
        }
    }

    internal func decodeResource(_ resourceData: Any) throws -> T? {
        throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "No decoder implemented - Did you mean to use ImagePreprocessChain?")
    }

    internal func verifyEncoder() throws {
        if (encoder == nil) {
            throw CLDError.error(code: CLDError.CloudinaryErrorCode.preprocessingError, message: "No encoder set - Did you mean to use ImagePreprocessChain?")
        }
    }
}

