//
//  Data+HashFunction.swift
//  CryptoKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation

internal extension Data {
    /// Calculate the digest (hash) of `self`.
    /// - parameters:
    ///   - hashFunction: The hash function used for generating the digest.
    /// - returns: The digest of `self`.
    internal func digest(using hashFunction: HashFunction) -> Data {
        return hashFunction.digest(self)
    }
}
