//
//  SHA1.swift
//  CryptoKit
//
//  Created by Chris Amanse on 29/08/2016.
//
//

import Foundation

internal enum SHA1: HashAlgorithm {
    internal static var outputSize: UInt {
        return 16
    }
    internal static var blockSize: UInt {
        return 64
    }
}

extension SHA1: MerkleDamgardConstructor {
    internal static var endianess: Endianess {
        return .bigEndian
    }
    
    internal static var initializationVector: [UInt32] {
        return [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476, 0xc3d2e1f0]
    }
    
    internal static var rounds: UInt {
        return 80
    }
    
    internal static func compress(_ data: Data) -> [UInt32] {
        // Initialize hash value
        var h = self.initializationVector
        
        // Divide into 512-bit (64-byte) chunks
        // Since data length is 0 bytes (mod 64), all chunks are 64 bytes
        let chunkLength = 64
        for index in stride(from: data.startIndex, to: data.endIndex, by: chunkLength) {
            // Get 512-bit chunk
            let chunk = data.subdata(in: index ..< index + chunkLength)
            
            // Divide chunk into 32-bit words (512 is divisible by 32, thus all words are 32 bits)
            // Since 512 is divisible by 32, simply create array by converting the Data pointer to a UInt32 array pointer
            var w = chunk.withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> [UInt32] in
                // 512 / 32 = 16 words
                return Array(UnsafeBufferPointer(start: ptr, count: 16))
                }.map {
                    $0.bigEndian
            }
            
            // Extend 16 words to 80 words
            for i in 16..<80 {
                w.append((w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16]) <<< 1)
            }
            
            // Initialize hash value for this chunk
            var A = h[0]
            var B = h[1]
            var C = h[2]
            var D = h[3]
            var E = h[4]
            
            // Main loop
            for i in 0 ..< Int(self.rounds) {
                let round = i / 20
                
                let F: UInt32
                let k: UInt32
                
                switch round {
                case 0:
                    F = (B & C) | ((~B) & D)
                    k = 0x5a827999
                case 1:
                    F = B ^ C ^ D
                    k = 0x6ed9eba1
                case 2:
                    F = (B & C) | (B & D) | (C & D)
                    k = 0x8f1bbcdc
                case 3:
                    F = B ^ C ^ D
                    k = 0xca62c1d6
                default:
                    F = 0
                    k = 0
                }
                
                let temp = (A <<< 5) &+ F &+ E &+ k &+ w[i]
                E = D
                D = C
                C = (B <<< 30)
                B = A
                A = temp
            }
            
            // Add current chunk's hash to result (allow overflow)
            let currentHash = [A, B, C, D, E]
            
            for i in 0..<h.count {
                h[i] = h[i] &+ currentHash[i]
            }
        }
        
        return h
    }
}
