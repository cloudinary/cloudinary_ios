//
//  HashAlgorithm.swift
//  CryptoKit
//
//  Created by Chris Amanse on 31/08/2016.
//
//

import Foundation

internal protocol HashAlgorithm {
    static var outputSize: UInt { get }
    static var blockSize: UInt { get }
    
    static func digest(_ message: Data) -> Data
}
