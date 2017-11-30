//
//  EndianRepresentable.swift
//  CryptoKit
//
//  Created by Chris Amanse on 01/09/2016.
//
//

import Foundation

internal protocol EndianRepresentable {
    var littleEndian: Self { get }
    var bigEndian: Self { get }
}

extension UInt8: EndianRepresentable {
    internal var littleEndian: UInt8 { return self }
    internal var bigEndian: UInt8 { return self }
}

extension Int8: EndianRepresentable {
    internal var littleEndian: Int8 { return self }
    internal var bigEndian: Int8 { return self }
}

extension UInt16: EndianRepresentable {}
extension Int16: EndianRepresentable {}
extension UInt32: EndianRepresentable {}
extension Int32: EndianRepresentable {}
extension UInt64: EndianRepresentable {}
extension Int64: EndianRepresentable {}
extension UInt: EndianRepresentable {}
extension Int: EndianRepresentable {}
