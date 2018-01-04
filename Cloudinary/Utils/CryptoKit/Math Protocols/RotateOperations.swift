//
//  RotateOperations.swift
//  CryptoKit
//
//  Created by Chris Amanse on 31/08/2016.
//
//  Updated by Nitzan Jaitman on 29/11/2017
//
//

import Foundation

internal protocol RotateOperations {
}

extension UInt8: RotateOperations {}
extension Int8: RotateOperations {}
extension UInt16: RotateOperations {}
extension Int16: RotateOperations {}
extension UInt32: RotateOperations {}
extension Int32: RotateOperations {}
extension UInt64: RotateOperations {}
extension Int64: RotateOperations {}
extension UInt: RotateOperations {}
extension Int: RotateOperations {}

internal extension RotateOperations where Self: FixedWidthInteger & ExpressibleByInt & BinaryInteger {
    internal func cldShiftLeft(by: Self) -> Self {
        guard by != Self(0) else {
            return self
        }
        
        let size = Self(MemoryLayout<Self>.size * 8)
        
        return (self << by) | (self >> (size - by))
    }
    
    internal func cldShiftRight(by: Self) -> Self {
        guard by != Self(0) else {
            return self
        }
        
        let size = Self(MemoryLayout<Self>.size * 8)
        
        return (self >> by) | (self << (size - by))
    }
}
