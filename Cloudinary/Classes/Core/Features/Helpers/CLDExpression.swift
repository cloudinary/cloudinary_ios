//
//  CLDExpression.swift
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

@objcMembers open class CLDExpression: NSObject {

    internal enum ExpressionKeys : String, CaseIterable {
        
        case width
        case height
        
        case initial_width
        case initialWidth
        case initial_height
        case initialHeight
        
        case initial_aspect_ratio
        case aspect_ratio
        case aspectRatio
        case initialAspectRatio
        
        case page_count
        case pageCount
        
        case face_count
        case faceCount
        
        case illustration_score
        case illustrationScore
        
        case current_page
        case currentPage
        
        case tags
        
        case pageX
        case pageY
        case duration
        
        case initial_duration
        case initialDuration
        
        var asString: String {
            
            switch self {
            case .width : return "w"
            case .height: return "h"
                
            case .initial_width : return "iw"
            case .initialWidth  : return "iw"
            case .initial_height: return "ih"
            case .initialHeight : return "ih"
                
            case .initial_aspect_ratio: return "iar"
            case .aspect_ratio        : return "ar"
            case .aspectRatio         : return "ar"
            case .initialAspectRatio  : return "iar"
                
            case .page_count: return "pc"
            case .pageCount : return "pc"
                
            case .face_count: return "fc"
            case .faceCount : return "fc"
                
            case .illustration_score: return "ils"
            case .illustrationScore : return "ils"
                
            case .current_page: return "cp"
            case .currentPage : return "cp"
                
            case .tags: return "tags"
            
            case .pageX: return "px"
            case .pageY: return "py"
                
            case .duration: return "du"
            case .initial_duration: return "idu"
            case .initialDuration : return "idu"
            }
        }
    }
    
    internal var currentValue      : String
    internal var currentKey        : String
    
    private var allSpaceAndOrDash       : Bool = false
    private let consecutiveDashesRegex  : String = "[ _]+"
    private let userVariableRegex       : String = "\\$_*[^_]+"
    
    // MARK: - Init
    public override init() {
        self.currentKey   = String()
        self.currentValue = String()
        super.init()
    }
    
    public init(value: String) {
        var components = value.components(separatedBy: .whitespacesAndNewlines)
        self.currentKey   = components.removeFirst()
        self.currentValue = components.joined(separator: CLDVariable.elementsSeparator)
        let range = NSRange(location: 0, length: value.utf16.count)
        let regex = try? NSRegularExpression(pattern: "^" + consecutiveDashesRegex)
        self.allSpaceAndOrDash = !(regex?.firstMatch(in: value, options: [], range: range) == nil)
        super.init()
    }
    
    fileprivate init(expressionKey: ExpressionKeys) {
        self.currentKey   = expressionKey.asString
        self.currentValue = String()
        super.init()
    }
    
    // MARK: - class func
    public class func width() -> CLDExpression {
        return CLDExpression(expressionKey: .width)
    }
    
    public class func height() -> CLDExpression {
        return CLDExpression(expressionKey: .height)
    }
    
    public class func initialWidth() -> CLDExpression {
        return CLDExpression(expressionKey: .initialWidth)
    }
    
    public class func initialHeight() -> CLDExpression {
        return CLDExpression(expressionKey: .initialHeight)
    }
    
    public class func aspectRatio() -> CLDExpression {
        return CLDExpression(expressionKey: .aspectRatio)
    }
    
    public class func initialAspectRatio() -> CLDExpression {
        return CLDExpression(expressionKey: .initialAspectRatio)
    }
    
    public class func pageCount() -> CLDExpression {
        return CLDExpression(expressionKey: .pageCount)
    }
    
    public class func faceCount() -> CLDExpression {
        return CLDExpression(expressionKey: .faceCount)
    }
    
    public class func tags() -> CLDExpression {
        return CLDExpression(expressionKey: .tags)
    }
    
    public class func pageXOffset() -> CLDExpression {
        return CLDExpression(expressionKey: .pageX)
    }
    
    public class func pageYOffset() -> CLDExpression {
        return CLDExpression(expressionKey: .pageY)
    }
    
    public class func illustrationScore() -> CLDExpression {
        return CLDExpression(expressionKey: .illustrationScore)
    }
    
    public class func currentPageIndex() -> CLDExpression {
        return CLDExpression(expressionKey: .currentPage)
    }
    
    public class func duration() -> CLDExpression {
        return CLDExpression(expressionKey: .duration)
    }
    public class func initialDuration() -> CLDExpression {
        return CLDExpression(expressionKey: .initialDuration)
    }
    
    // MARK: - Public methods
    @objc(addByInt:)
    @discardableResult
    public func add(by number: Int) -> Self {
        appendOperatorToCurrentValue(.add, inputValue: "\(number)")
        return self
    }
    @objc(addByFloat:)
    @discardableResult
    public func add(by number: Float) -> Self {
        appendOperatorToCurrentValue(.add, inputValue: number.cldFloatFormat())
        return self
    }
    @objc(addByString:)
    @discardableResult
    public func add(by number: String) -> Self {
        appendOperatorToCurrentValue(.add, inputValue: number)
        return self
    }
    
    @objc(subtractByInt:)
    @discardableResult
    public func subtract(by number: Int) -> Self {
        appendOperatorToCurrentValue(.subtract, inputValue: "\(number)")
        return self
    }
    @objc(subtractByFloat:)
    @discardableResult
    public func subtract(by number: Float) -> Self {
        appendOperatorToCurrentValue(.subtract, inputValue: number.cldFloatFormat())
        return self
    }
    @objc(subtractByString:)
    @discardableResult
    public func subtract(by number: String) -> Self {
        appendOperatorToCurrentValue(.subtract, inputValue: number)
        return self
    }
    
    @objc(multipleByInt:)
    @discardableResult
    public func multiple(by number: Int) -> Self {
        appendOperatorToCurrentValue(.multiple, inputValue: "\(number)")
        return self
    }
    @objc(multipleByFloat:)
    @discardableResult
    public func multiple(by number: Float) -> Self {
        appendOperatorToCurrentValue(.multiple, inputValue: number.cldFloatFormat())
        return self
    }
    @objc(multipleByString:)
    @discardableResult
    public func multiple(by number: String) -> Self {
        appendOperatorToCurrentValue(.multiple, inputValue: number)
        return self
    }
    
    @objc(divideByInt:)
    @discardableResult
    public func divide(by number: Int) -> Self {
        appendOperatorToCurrentValue(.divide, inputValue: "\(number)")
        return self
    }
    @objc(divideByFloat:)
    @discardableResult
    public func divide(by number: Float) -> Self {
        appendOperatorToCurrentValue(.divide, inputValue: number.cldFloatFormat())
        return self
    }
    @objc(divideByString:)
    @discardableResult
    public func divide(by number: String) -> Self {
        appendOperatorToCurrentValue(.divide, inputValue: number)
        return self
    }
    
    @objc(powerByInt:)
    @discardableResult
    public func power(by number: Int) -> Self {
        appendOperatorToCurrentValue(.power, inputValue: "\(number)")
        return self
    }
    @objc(powerByFloat:)
    @discardableResult
    public func power(by number: Float) -> Self {
        appendOperatorToCurrentValue(.power, inputValue: number.cldFloatFormat())
        return self
    }
    @objc(powerByString:)
    @discardableResult
    public func power(by number: String) -> Self {
        appendOperatorToCurrentValue(.power, inputValue: number)
        return self
    }
    
    // MARK: - provide content
    public func asString() -> String {
        
        guard !currentKey.isEmpty else {
            if allSpaceAndOrDash {
                return "_"
            }
            return String()
        }
        
        let key = removeExtraDashes(from: replaceAllExpressionKeys(in: currentKey))

        if currentValue.isEmpty {
            return "\(key)"
        }
        
        let value = removeExtraDashes(from: replaceAllUnencodeChars(in: currentValue))
        return "\(key)_\(value)"
    }
    
    public func asParams() -> [String : String] {
        
        guard !currentKey.isEmpty && !currentValue.isEmpty else {
            
            return [String : String]()
        }
        
        let key   = replaceAllExpressionKeys(in: currentKey)
        let value = removeExtraDashes(from: replaceAllUnencodeChars(in: currentValue))
        
        return [key:value]
    }
    
    internal func asInternalString() -> String {

        guard !currentValue.isEmpty else {
        
            return "\(currentKey)"
        }
        return "\(currentKey) \(currentValue)"
    }
    
    // MARK: - Private methods
    private func replaceAllUnencodeChars(in string: String) -> String {
        
        var wipString   = string
        wipString       = replaceAllOperators(in: string)
        wipString       = replaceAllExpressionKeys(in: wipString)
        return wipString
    }
    
    private func replaceAllOperators(in string: String) -> String {
        
        var wipString = string
        CLDOperators.allCases.forEach {
                wipString = replace(cldOperator: $0, in: wipString)
        }
        
        return wipString
    }
    
    private func replace(cldOperator: CLDOperators, in string: String) -> String {
        
        return string.replacingOccurrences(of: cldOperator.rawValue, with: cldOperator.asString())
    }
    
    private func replaceAllExpressionKeys(in string: String) -> String {
        
        var wipString = string
        ExpressionKeys.allCases.forEach {
                
            wipString = replace(expressionKey: $0, in: wipString)
        }
        
        return wipString
    }
    
    private func replace(expressionKey: ExpressionKeys, in string: String) -> String {

        var result : String!
        let string = removeExtraDashes(from: string)

        if string.contains(CLDVariable.variableNamePrefix) {
            let range = NSRange(location: 0, length: string.utf16.count)
            let regex = try? NSRegularExpression(pattern: userVariableRegex)
            let allRanges = regex?.matches(in: string, options: [], range: range).map({ $0.range }) ?? []

            // Replace substring in between user variables. e.x $initial_aspect_ratio_$width, only '_aspect_ratio_' will be addressed.
            for (index, range) in allRanges.enumerated() {
                let location = range.length + range.location
                var length = range.length

                if index + 1 == allRanges.count {
                    length = string.count
                } else {
                    let nextRange = allRanges[index + 1]
                    length = nextRange.location
                }

                if let stringRange = Range(NSRange(location: location, length: length - location), in: string) {
                    result = string.replacingOccurrences(of: expressionKey.rawValue, with: expressionKey.asString, options: .regularExpression, range: stringRange)
                }
            }
        } else {
            result = string.replacingOccurrences(of: expressionKey.rawValue, with: expressionKey.asString)
        }
        return result
    }
    
    internal func appendOperatorToCurrentValue(_ cldoperator: CLDOperators, inputValue: String = String()) {
        appendOperatorToCurrentValue(cldoperator.asString(), inputValue: inputValue)
    }
    
    internal func appendOperatorToCurrentValue(_ cldoperator: String, inputValue: String = String()) {
        
        var stringValue = String()
        if !currentValue.isEmpty {
           
            stringValue.append(CLDVariable.elementsSeparator)
        }
        
        stringValue.append(cldoperator)
        
        if !inputValue.isEmpty {
         
            stringValue.append(CLDVariable.elementsSeparator + inputValue)
        }
        
        currentValue.append(stringValue)
    }
    
    private func removeExtraDashes(from string: String) -> String {
        return string.replacingOccurrences(of: consecutiveDashesRegex, with: CLDVariable.elementsSeparator, options: .regularExpression, range: nil)
    }
}
