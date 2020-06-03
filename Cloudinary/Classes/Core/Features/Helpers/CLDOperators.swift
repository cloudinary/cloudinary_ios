//
//  CLDOperators.swift
//
//  Copyright (c) 2016 Cloudinary (http://cloudinary.com)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public enum CLDOperators: String , CaseIterable {
    
    case and = "&&"
    case or  = "||"
    
    case multiple = "*"
    case divide   = "/"
    case add      = "+"
    case subtract = "-"

    case power    = "^"
    
    case notInside      = "notInside"
    case inside         = "inside"
    
    case lessOrEqual    = "<="
    case greaterOrEqual = ">="
    case lessThen       = "<"
    case greaterThen    = ">"
    case notEqual       = "!="
    case equal          = "="
    
    func asString() -> String {
        
        switch self {
        case .equal         : return "eq"
        case .notEqual      : return "ne"
        case .lessThen      : return "lt"
        case .greaterThen   : return "gt"
        case .lessOrEqual   : return "lte"
        case .greaterOrEqual: return "gte"
        case .inside        : return "in"
        case .notInside     : return "nin"

        case .and: return "and"
        case .or : return "or"

        case .multiple: return "mul"
        case .divide  : return "div"
        case .add     : return "add"
        case .subtract: return "sub"
        case .power   : return "pow"
        }
    }
}

