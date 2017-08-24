//
//  CLDTransformation.swift
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

@objc open class CLDCondition: NSObject {

    fileprivate var condition: String = ""
    
    override public init() {
        super.init()
    }
    
    public init(condition: String) {
        self.condition = condition
    }
    
    @discardableResult
    open func setCondition(_ condition: String) -> CLDCondition {
        self.condition = condition
        return self
    }
    
    @discardableResult
    open func setCondition(_ imageCharacteristic: CLDImageCharacteristics, _ operators: CLDOperators, value: String) -> CLDCondition {
        let condition = String(format: "%@_%@_%@", String(describing: imageCharacteristic), String(describing: operators), value)
        self.condition = condition
        return self
    }
    
    //Supported .include or .notInclude
    @discardableResult
    open func setTags(_ tags: [String], _ operators: CLDOperators) -> CLDCondition {
        let tagsString = tags.joined(separator: ":")
        let condition = String(format: "if_!%@!_%@_tags", tagsString, String(describing: operators))
        self.condition = condition
        return self
    }
    
    @discardableResult
    open func and(_ condition: String) -> CLDCondition {
        self.condition += "_and_" + condition
        return self
    }
    
    @discardableResult
    open func and(condition: CLDCondition) -> CLDCondition {
        return self.and(condition.asString())
    }
    
    @discardableResult
    open func or(_ condition: String) -> CLDCondition {
        self.condition += "_or_" + condition
        return self
    }
    
    @discardableResult
    open func or(condition: CLDCondition) -> CLDCondition {
        return self.or(condition.asString())
    }
    
    @discardableResult
    open func asString() -> String {
        return self.condition
    }
    
    // MARK: Operators
    
    @objc public enum CLDOperators: Int, CustomStringConvertible {
        case equal, notEqual, lessThan, greaterThan, lessOrEqual, greaterThanOrEqual, include, notInclude
        
        public var description: String {
            get {
                switch self {
                case .equal:                       return "eq"
                case .notEqual:                    return "ne"
                case .lessThan:                    return "lt"
                case .greaterThan:                 return "gt"
                case .lessOrEqual:                 return "lte"
                case .greaterThanOrEqual:          return "gte"
                case .include:                     return "in"
                case .notInclude:                  return "nin"
                }
            }
        }
    }
    
    // MARK: Supported image characteristics
    
    @objc public enum CLDImageCharacteristics: Int, CustomStringConvertible {
        case width, initialWidth, height, initialHeight, aspectRatio, trimmedAspectRatio, currentPage, pageCount, faceCount, isIllustration, tags
        
        public var description: String {
            get {
                switch self {
                case .width:                       return "w"
                case .initialWidth:                    return "iw"
                case .height:                    return "h"
                case .initialHeight:                 return "ih"
                case .aspectRatio:                 return "ar"
                case .trimmedAspectRatio:          return "tar"
                case .currentPage:                     return "cp"
                case .pageCount:                  return "pc"
                case .faceCount:                  return "fc"
                case .isIllustration:                  return "ils"
                case .tags:                  return "tags"
                }
            }
        }
    }
}
