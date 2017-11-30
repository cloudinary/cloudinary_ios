//
//  ExpressibleByInt.swift
//  CryptoKit
//
//  Created by Chris Amanse on 31/08/2016.
//
//

import Foundation

internal protocol ExpressibleByInt {
    init(_ value: Int)
}

extension UInt8: ExpressibleByInt {}
extension Int8: ExpressibleByInt {}
extension UInt16: ExpressibleByInt {}
extension Int16: ExpressibleByInt {}
extension UInt32: ExpressibleByInt {}
extension Int32: ExpressibleByInt {}
extension UInt64: ExpressibleByInt {}
extension Int64: ExpressibleByInt {}
extension UInt: ExpressibleByInt {}
extension Int: ExpressibleByInt {}
