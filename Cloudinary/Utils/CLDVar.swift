//
//  CLDVar.swift
//  Cloudinary
//
//  Created by Sergey Glushchenko on 8/28/17.
//  Copyright © 2017 Cloudinary. All rights reserved.
//

import UIKit

open class CLDVar: NSObject {
    public var variable: String = ""
    public var value: String?
    
    public init(_ variable: String) {
        self.variable = variable
    }
    
    public init(_ variable: String, _ value: String) {
        self.variable = variable
        self.value = value
    }
    
    @objc(initWithVariable:andInteger:)
    public init(_ variable: String, _ integer: Int) {
        self.variable = variable
        self.value = String(integer)
    }
    
    @objc(initWithVariable:andStrings:)
    public init(_ variable: String, _ strings: [String]) {
        self.variable = variable
        self.value = "!\(strings.joined(separator: ":"))!"
    }
    
    open override var description: String {
        if let value = self.value {
            return "$\(self.variable)_\(value)"
        }
        else {
            return "$\(self.variable)"
        }
    }
    
    open func mul(_ integer: Int) -> CLDVar {
        let op: String = CLDArithmetic.multiply.rawValue
        self.value = "\(op)_\(integer)"
        return self
    }
    
    open func mul(value: String) -> CLDVar {
        let op: String = CLDArithmetic.multiply.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func sub(_ integer: Int) -> CLDVar {
        let op: String = CLDArithmetic.subtract.rawValue
        self.value = "\(op)_\(integer)"
        return self
    }
    
    open func sub(value: String) -> CLDVar {
        let op: String = CLDArithmetic.subtract.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func add(_ integer: Int) -> CLDVar {
        let op: String = CLDArithmetic.add.rawValue
        self.value = "\(op)_\(integer)"
        return self
    }
    
    open func add(value: String) -> CLDVar {
        let op: String = CLDArithmetic.add.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func divide(_ integer: Int) -> CLDVar {
        let op: String = CLDArithmetic.divide.rawValue
        self.value = "\(op)_\(integer)"
        return self
    }
    
    open func divide(value: String) -> CLDVar {
        let op: String = CLDArithmetic.divide.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func modulo(integer: Int) -> CLDVar {
        let op: String = CLDArithmetic.modulo.rawValue
        self.value = "\(op)_\(integer)"
        return self
    }
    
    open func modulo(value: String) -> CLDVar {
        let op: String = CLDArithmetic.modulo.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func equal(variable: CLDVar) -> CLDVar {
        return self.equal(value: "\(variable)")
    }
    
    open func equal(value: String) -> CLDVar {
        let op: String = CLDOperators.equal.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func notEqual(variable: CLDVar) -> CLDVar {
        return self.notEqual(value: "\(variable)")
    }
    
    open func notEqual(value: String) -> CLDVar {
        let op: String = CLDOperators.notEqual.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func lessThan(variable: CLDVar) -> CLDVar {
        return self.lessThan(value: "\(variable)")
    }
    
    open func lessThan(value: String) -> CLDVar {
        let op: String = CLDOperators.lessThan.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func greaterThan(variable: CLDVar) -> CLDVar {
        return self.greaterThan(value: "\(variable)")
    }
    
    open func greaterThan(value: String) -> CLDVar {
        let op: String = CLDOperators.greaterThan.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func lessThanOrEqual(variable: CLDVar) -> CLDVar {
        return self.lessThanOrEqual(value: "\(variable)")
    }
    
    open func lessThanOrEqual(value: String) -> CLDVar {
        let op: String = CLDOperators.lessThanOrEqual.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func greaterThanOrEqual(variable: CLDVar) -> CLDVar {
        return self.greaterThanOrEqual(value: "\(variable)")
    }
    
    open func greaterThanOrEqual(value: String) -> CLDVar {
        let op: String = CLDOperators.greaterThanOrEqual.rawValue
        self.value = "\(op)_\(value)"
        return self
    }

    open func included(variable: CLDVar) -> CLDVar {
        return self.included(value: "\(variable)")
    }
    
    open func included(value: String) -> CLDVar {
        let op: String = CLDOperators.included.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    open func notIncluded(variable: CLDVar) -> CLDVar {
        return self.notIncluded(value: "\(variable)")
    }
    
    open func notIncluded(value: String) -> CLDVar {
        let op: String = CLDOperators.notIncluded.rawValue
        self.value = "\(op)_\(value)"
        return self
    }
    
    // MARK: Arithmetic operations
    
    private enum CLDArithmetic: String {
        case add           = "add"
        case subtract      = "sub"
        case multiply      = "mul"
        case divide        = "div"
        case modulo        = "mod"
    }
    
    // MARK: Operations
    
    private enum CLDOperators: String {
        case equal              = "eq"
        case notEqual           = "ne"
        case lessThan           = "lt"
        case greaterThan        = "gt"
        case lessThanOrEqual    = "lte"
        case greaterThanOrEqual = "gte"
        case included           = "in"
        case notIncluded        = "nin"
    }

}
