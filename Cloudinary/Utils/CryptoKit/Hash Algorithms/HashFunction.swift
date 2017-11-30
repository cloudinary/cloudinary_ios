//
//  HashFunction.swift
//  CryptoKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation

/// A `HashFunction` contains a `HashAlgorithm.Type`, which is then used for calculating the hash of a message.
public struct HashFunction {
    /// The type of hash alorithm to use for calculating the hash of a message.
    public var algorithm: HashAlgorithm.Type
    
    /// Calculates the hash/digest of a message.
    /// - parameters:
    ///   - message: The message to be hashed.
    /// - returns: The hash of a message.
    public func digest(_ message: Data) -> Data {
        return algorithm.digest(message)
    }
    
    /// Creates a hash function with an algorithm specified by the `HashAlgorithm.Type`
    /// - parameters:
    ///   - algorithm: The algorithm to be used for calculating the hash of a message.
    public init(_ algorithm: HashAlgorithm.Type) {
        self.algorithm = algorithm
    }
}

extension HashFunction: Equatable {
    public static func ==(lhs: HashFunction, rhs: HashFunction) -> Bool {
        return lhs.algorithm == rhs.algorithm
    }
}

public extension HashAlgorithm {
    /// Creates a hash function instance using `self` as its hash algorithm.
    public static var hashFunction: HashFunction {
        return HashFunction(self)
    }
}
