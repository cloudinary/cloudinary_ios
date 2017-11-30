//
//  MD5.swift
//  CryptoKit
//
//  Created by Chris Amanse on 28/08/2016.
//
//

import Foundation

internal enum MD5: HashAlgorithm {
    internal static var outputSize: UInt {
        return 16
    }
    internal static var blockSize: UInt {
        return 64
    }
}

extension MD5: MerkleDamgardConstructor {
    internal static var initializationVector: [UInt32] {
        return [0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476]
    }
    
    internal static var rounds: UInt {
        return 64
    }
    
    internal static func compress(_ data: Data) -> [UInt32] {
        // Initialize hash value
        var h = self.initializationVector
        
        // Divide into 512-bit (64-byte) chunks
        // Since data length is 0 bytes (mod 64), all chunks are 64 bytes
        let chunkLength = Int(self.blockSize)
        for index in stride(from: data.startIndex, to: data.endIndex, by: chunkLength) {
            // Get 512-bit chunk
            let chunk = data.subdata(in: index ..< index + chunkLength)
            
            // Divide chunk into 32-bit words (512 is divisible by 32, thus all words are 32 bits)
            // Since 512 is divisible by 32, simply create array by converting the Data pointer to a UInt32 array pointer
            let M = chunk.withUnsafeBytes { (ptr: UnsafePointer<UInt32>) -> [UInt32] in
                // 512 / 32 = 16 words
                return Array(UnsafeBufferPointer(start: ptr, count: 16))
            }
            
            // Initiaize hash value for this chunk
            var A = h[0]
            var B = h[1]
            var C = h[2]
            var D = h[3]
            
            // Main loop
            for i in 0 ..< Int(self.rounds) {
                // Divide 0..<64 into four rounds, i.e. 0..<16 = round 1, 16..<32 = round2, etc.
                let round = i / 16
                
                // Calculate F and g depending on round
                let F: UInt32
                let g: Int
                
                switch round {
                case 0:
                    F = (B & C) | ((~B) & D)
                    g = i
                case 1:
                    F = (D & B) | ((~D) & C)
                    g = ((5 &* i) &+ 1) % 16
                case 2:
                    F = B ^ C ^ D
                    g = ((3 &* i) &+ 5) % 16
                case 3:
                    F = C ^ (B | (~D))
                    g = (7 &* i) % 16
                default:
                    F = 0
                    g = 0
                }
                
                // Swap values
                let newB = B &+ ((A &+ F &+ K(i) &+ M[g])) <<< s(i)
                let oldD = D
                
                D = C
                C = B
                B = newB
                A = oldD
            }
            
            // Add current chunk's hash to result (allow overflow)
            let currentHash = [A, B, C, D]
            
            for i in 0..<h.count {
                h[i] = h[i] &+ currentHash[i]
            }
        }
        
        return h
    }
}

extension MD5 {
    /// Get binary integer part of the sines of integers (Radians)
    static func K(_ i: Int) -> UInt32 {
        return UInt32(floor(4294967296 * abs(sin(Double(i) + 1))))
    }
    
    /// Get per-round shift amounts
    static func s(_ i: Int) -> UInt32 {
        let row = i / 16
        let column = i % 4
        
        switch row {
        case 0:
            switch column {
            case 0: return 7
            case 1: return 12
            case 2: return 17
            case 3: return 22
            default: return 0
            }
        case 1:
            switch column {
            case 0: return 5
            case 1: return 9
            case 2: return 14
            case 3: return 20
            default: return 0
            }
        case 2:
            switch column {
            case 0: return 4
            case 1: return 11
            case 2: return 16
            case 3: return 23
            default: return 0
            }
        case 3:
            switch column {
            case 0: return 6
            case 1: return 10
            case 2: return 15
            case 3: return 21
            default: return 0
            }
        default:
            return 0
        }
    }
}
