//
//  CLDStringUtils.swift
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


//internal extension Int {
//    func format(f: String) -> String {
//        return String(format: "%\(f)d", self)
//    }
//}

internal extension Double {
    func cldFormat(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

internal extension Float {
    
    func cldFloatFormat() -> String {
        return cldFormat(f: ".1")
    }
    
    func cldFormat(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

internal extension String {
    
    internal func cldSmartEncodeUrl() -> String? {
        let customAllowedSet =  NSCharacterSet(charactersIn:"!*'\"();@&=+$,?%#[] ").inverted
        return addingPercentEncoding(withAllowedCharacters: customAllowedSet)
    }
    
    internal subscript (i: Int) -> Character {
        return self[startIndex.cldAdvance(i, for: self)]
    }

    subscript (r: CountableClosedRange<Int>) -> String {
        get {
            let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
            return String(self[startIndex...endIndex])
        }
    }  
    
    internal func cldStringByAppendingPathComponent(str: String) -> String {
        return self + ("/\(str)")
    }
    
    internal func cldAsBool() -> Bool {
        if self == "true" {
            return true
        }
        if let intValue = Int(self) {
            return NSNumber(value: intValue).boolValue
        }
        return false
    }
}

internal extension String.Index{
//    func successor(in string:String)->String.Index{
//        return string.index(after: self)
//    }
//
//    func predecessor(in string:String)->String.Index{
//        return string.index(before: self)
//    }
    
    func cldAdvance(_ offset:Int, `for` string:String)->String.Index{
        return string.index(self, offsetBy: offset)
    }
}


internal func cldParamValueAsString(value: Any) -> String? {
    if let valueStr = value as? String {
        if valueStr.isEmpty {
            return nil
        }
        return valueStr
    }
    else if let valueNum = value as? NSNumber {
        return String(describing: valueNum)
    }
    else {
        printLog(.error, text: "The parameter value must ba a String or a Number")
        return nil
    }
}







