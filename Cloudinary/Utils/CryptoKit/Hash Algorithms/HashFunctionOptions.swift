//
//  HashFunctionOptions.swift
//  CryptoKit
//
//  Created by Chris Amanse on 06/09/2016.
//
//

import Foundation

internal extension HashFunction {
    /// MD5 hash function.
    internal static var md5: HashFunction { return MD5.hashFunction }
    
    /// SHA-1 hash function.
    internal static var sha1: HashFunction { return SHA1.hashFunction }
}
