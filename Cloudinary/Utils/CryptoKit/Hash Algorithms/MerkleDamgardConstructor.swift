//
//  MerkleDamgardConstructor.swift
//  CryptoKit
//
//  Created by Chris Amanse on 09/15/2016.
//
//  Updated by Nitzan Jaitman on 29/11/2017
//
//

import Foundation

internal enum Endianess {
    case bigEndian
    case littleEndian
}

internal protocol MerkleDamgardConstructor: HashAlgorithm {
    associatedtype BaseUnit: UnsignedInteger, FixedWidthInteger,
        RotateOperations, ExpressibleByInt, EndianRepresentable
    
    static var endianess: Endianess { get }
    
    static var initializationVector: [BaseUnit] { get }
    
    static var rounds: UInt { get }
    
    static var lengthPaddingSize: UInt { get }
    
    static func applyPadding(to message: Data) -> Data
    
    static func compress(_ data: Data) -> [BaseUnit]
    
    static func finalize(vector: [BaseUnit]) -> Data
}

internal extension MerkleDamgardConstructor {
    internal static var endianess: Endianess {
        return .littleEndian
    }

    internal static var lengthPaddingSize: UInt {
        return self.blockSize / 8
    }

    internal static func applyPadding(to message: Data) -> Data {
        let length = Int(self.blockSize)
        
        // Create mutable copy of message
        var messageCopy = message
        
        // Append 1-bit and zeros until length of messageCopy in bits = length - allowance (mod length)
        // Ex: 512 length, 8-byte allowance for 64-bit representation of length
        // 448 bits = 56 bytes, 512 bits = 64 bytes
        messageCopy.append(0x80)
        
        // Compute padded zeros count
        var paddedZerosCount = messageCopy.count % length
        
        // Size of origin length representation for the end of the padding scheme
        let allowance = Int(self.lengthPaddingSize)
        
        let target = length - allowance // Allowance number of bytes for length
        if paddedZerosCount <= target {
            paddedZerosCount = target - paddedZerosCount
        } else {
            paddedZerosCount = length - paddedZerosCount + target
        }
        
        // Append required zeros to get: length - allowance (mod length)
        messageCopy.append(contentsOf: Array(repeating: UInt8(0x00), count: paddedZerosCount))
        
        // If allowance is greater than 8 bytes (UInt64), add zeros first
        let additionalZeros = (allowance - 8)
        
        // If big endian, append zeros now, else, append after appending length
        if endianess == .bigEndian {
            // Append zeros for length representation
            if additionalZeros > 0 {
                messageCopy.append(contentsOf: Array(repeating: UInt8(0x00), count: additionalZeros))
            }
            
            // Append rest of data for length representation
            messageCopy.append(Data(from: (UInt64(message.count) * 8).bigEndian))
        } else {
            // Append data for length representation
            messageCopy.append(Data(from: (UInt64(message.count) * 8)))
            
            // Append zeros for rest of length representation
            if additionalZeros > 0 {
                messageCopy.append(contentsOf: Array(repeating: UInt8(0x00), count: additionalZeros))
            }
        }
        
        return messageCopy
    }

    internal static func finalize(vector: [BaseUnit]) -> Data {
        return vector.reduce(Data()) { (current, value) -> Data in
            current + Data(from: self.endianess == .littleEndian ? value : value.bigEndian)
        }
    }

    internal static func digest(_ message: Data) -> Data {
        let paddedMessage = self.applyPadding(to: message)
        
        return self.finalize(vector: self.compress(paddedMessage))
    }
}
