//
//  CLDConditionExpression.swift
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

@objcMembers open class CLDConditionExpression : CLDExpression {
    
    var relatedTransformation: CLDTransformation
    
    // MARK: - Init
    private init(_ expression: CLDExpression) {
        self.relatedTransformation = CLDTransformation()
        super.init(value: expression.asInternalString())
    }
    
    public override init() {
        self.relatedTransformation = CLDTransformation()
        super.init()
    }
    
    public override init(value: String) {
        self.relatedTransformation = CLDTransformation()
        super.init(value: value)
    }
    
    // MARK: - Public methods
    @discardableResult
    public func and() -> Self {
        appendOperatorToCurrentValue(.and)
        return self
    }
    @objc(andString:)
    @discardableResult
    public func and(_ value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .and, inputValue: value)
        return self
    }
    @objc(andExpression:)
    @discardableResult
    public func and(_ value: CLDExpression) -> Self {
        return and(value.asInternalString())
    }
    
    @discardableResult
    public func or() -> Self {
        appendOperatorToCurrentValue(.or)
        return self
    }
    @objc(orString:)
    @discardableResult
    public func or(_ value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .or, inputValue: value)
        return self
    }
    @objc(orExpression:)
    @discardableResult
    public func or(_ value: CLDExpression) -> Self {
        return or(value.asInternalString())
    }
    
    @objc(equalToInt:)
    @discardableResult
    public func equal(to value: Int) -> Self {
        return equal(to: String(value))
    }
    @objc(equalToFloat:)
    @discardableResult
    public func equal(to value: Float) -> Self {
        return equal(to: value.cldFloatFormat())
    }
    @objc(equalToString:)
    @discardableResult
    public func equal(to value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .equal, inputValue: value)
        return self
    }
    @objc(equalToExpression:)
    @discardableResult
    public func equal(to value: CLDExpression) -> Self {
        return equal(to: value.asInternalString())
    }
    
    @objc(notEqualToInt:)
    @discardableResult
    public func notEqual(to value: Int) -> Self {
        return notEqual(to: String(value))
    }
    @objc(notEqualToFloat:)
    @discardableResult
    public func notEqual(to value: Float) -> Self {
        return notEqual(to: value.cldFloatFormat())
    }
    @objc(notEqualToString:)
    @discardableResult
    public func notEqual(to value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .notEqual, inputValue: value)
        return self
    }
    @objc(notEqualToExpression:)
    @discardableResult
    public func notEqual(to value: CLDExpression) -> Self {
        return notEqual(to: value.asInternalString())
    }
    
    @objc(lessThenInt:)
    @discardableResult
    public func less(then value: Int) -> Self {
        return less(then: String(value))
    }
    @objc(lessThenFloat:)
    @discardableResult
    public func less(then value: Float) -> Self {
        return less(then: value.cldFloatFormat())
    }
    @objc(lessThenString:)
    @discardableResult
    public func less(then value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .lessThen, inputValue: value)
        return self
    }
    @objc(lessThenExpression:)
    @discardableResult
    public func less(then value: CLDExpression) -> Self {
        return less(then: value.asInternalString())
    }
    
    @objc(greaterThenInt:)
    @discardableResult
    public func greater(then value: Int) -> Self {
        return greater(then: String(value))
    }
    @objc(greaterThenFloat:)
    @discardableResult
    public func greater(then value: Float) -> Self {
        return greater(then: value.cldFloatFormat())
    }
    @objc(greaterThenString:)
    @discardableResult
    public func greater(then value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .greaterThen, inputValue: value)
        return self
    }
    @objc(greaterThenExpression:)
    @discardableResult
    public func greater(then value: CLDExpression) -> Self {
        return greater(then: value.asInternalString())
    }
    
    @objc(lessOrEqualToInt:)
    @discardableResult
    public func lessOrEqual(to value: Int) -> Self {
        return lessOrEqual(to: String(value))
    }
    @objc(lessOrEqualToFloat:)
    @discardableResult
    public func lessOrEqual(to value: Float) -> Self {
        return lessOrEqual(to: value.cldFloatFormat())
    }
    @objc(lessOrEqualToString:)
    @discardableResult
    public func lessOrEqual(to value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .lessOrEqual, inputValue: value)
        return self
    }
    @objc(lessOrEqualToExpression:)
    @discardableResult
    public func lessOrEqual(to value: CLDExpression) -> Self {
        return lessOrEqual(to: value.asInternalString())
    }
    
    @objc(greaterOrEqualToInt:)
    @discardableResult
    public func greaterOrEqual(to value: Int) -> Self {
        return greaterOrEqual(to: String(value))
    }
    @objc(greaterOrEqualToFloat:)
    @discardableResult
    public func greaterOrEqual(to value: Float) -> Self {
        return greaterOrEqual(to: value.cldFloatFormat())
    }
    @objc(greaterOrEqualToString:)
    @discardableResult
    public func greaterOrEqual(to value: String) -> Self {
        appendingStringToCurrentValue(cldoperator: .greaterOrEqual, inputValue: value)
        return self
    }
    @objc(greaterOrEqualToExpression:)
    @discardableResult
    public func greaterOrEqual(to value: CLDExpression) -> Self {
        return greaterOrEqual(to: value.asInternalString())
    }
    
    @objc(insideString:)
    @discardableResult
    public func inside(_ expression: String) -> Self {
        
        guard !expression.isEmpty else { return self }
        appendingStringToCurrentValue(cldoperator: .inside, inputValue: expression)
        return self
    }
    @objc(insideExpression:)
    @discardableResult
    public func inside(_ expression: CLDExpression) -> Self {
        return inside(expression.asInternalString())
    }
    
    @objc(notInsideString:)
    @discardableResult
    public func notInside(_ expression: String) -> Self {
        
        guard !expression.isEmpty else { return self }
        appendingStringToCurrentValue(cldoperator: .notInside, inputValue: expression)
        return self
    }
    @objc(notInsideExpression:)
    @discardableResult
    public func notInside(_ expression: CLDExpression) -> Self {
        return notInside(expression.asInternalString())
    }
    
    @objc(valueFromString:)
    @discardableResult
    public func value(_ expression: String) -> Self {
        
        let expressionObject = CLDExpression.init(value: expression)
        
        let value: String
        if  expressionObject.currentValue.isEmpty {
            
            value = expression
        } else {
         
            value = expressionObject.asString()
        }
        
        if !expressionObject.currentValue.isEmpty && currentKey.isEmpty {
            currentKey      = expressionObject.currentKey
            currentValue    = expressionObject.currentValue
        }
        else if expressionObject.currentValue.isEmpty && currentKey.isEmpty {
            currentKey      = value
        }
        else if currentValue.isEmpty {
           
            currentValue.append(value)
        } else {
            
            currentValue.append(CLDVariable.elementsSeparator + value)
        }
        return self
    }
    @objc(valueFromExpression:)
    @discardableResult
    public func value(_  expression: CLDExpression) -> Self {
        return value(expression.asInternalString())
    }
    
    // MARK: - then
    @objc(then)
    public func then() -> CLDTransformation {
        
        return relatedTransformation.ifCondition(self)
    }
    
    // MARK: - Class Func
    public override class func width() -> Self {
        return CLDConditionExpression(super.width()) as! Self
    }
    public override class func height() -> Self {
        return CLDConditionExpression(super.height()) as! Self
    }
    public override class func aspectRatio() -> Self {
        return CLDConditionExpression(super.aspectRatio()) as! Self
    }
    
    public override class func initialWidth() -> Self {
        return CLDConditionExpression(super.initialWidth()) as! Self
    }
    public override class func initialHeight() -> Self {
        return CLDConditionExpression(super.initialHeight()) as! Self
    }
    public override class func initialAspectRatio() -> Self {
        return CLDConditionExpression(super.initialAspectRatio()) as! Self
    }
    
    public override class func pageCount() -> Self {
        return CLDConditionExpression(super.pageCount()) as! Self
    }
    public override class func faceCount() -> Self {
        return CLDConditionExpression(super.faceCount()) as! Self
    }
    
    public override class func tags() -> Self {
        return CLDConditionExpression(super.tags()) as! Self
    }
    
    public override class func pageXOffset() -> Self {
        return CLDConditionExpression(super.pageXOffset()) as! Self
    }
    public override class func pageYOffset() -> Self {
        return CLDConditionExpression(super.pageYOffset()) as! Self
    }
    
    public override class func illustrationScore() -> Self {
        return CLDConditionExpression(super.illustrationScore()) as! Self
    }
    
    public override class func currentPageIndex() -> Self {
        return CLDConditionExpression(super.currentPageIndex()) as! Self
    }
    public override class func duration() -> Self {
        return CLDConditionExpression(super.duration()) as! Self
    }
    public override class func initialDuration() -> Self {
        return CLDConditionExpression(super.initialDuration()) as! Self
    }
    
    
    // MARK: - helper methods
    @objc(width:intValue:)
    @discardableResult
    public func width(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .width, operatorString: operatorString, inputValue: String(object))
    }
    @objc(width:floatValue:)
    @discardableResult
    public func width(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .width, operatorString: operatorString, inputValue: String(object))
    }
    @objc(width:string:)
    @discardableResult
    public func width(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .width, operatorString: operatorString, inputValue: object)
    }
    @objc(width:expression:)
    @discardableResult
    public func width(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .width, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(width:conditionExpression:)
    @discardableResult
    public func width(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .width, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(height:intValue:)
    @discardableResult
    public func height(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .height, operatorString: operatorString, inputValue: String(object))
    }
    @objc(height:floatValue:)
    @discardableResult
    public func height(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .height, operatorString: operatorString, inputValue: String(object))
    }
    @objc(height:string:)
    @discardableResult
    public func height(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .height, operatorString: operatorString, inputValue: object)
    }
    @objc(height:expression:)
    @discardableResult
    public func height(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .height, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(height:conditionExpression:)
    @discardableResult
    public func height(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .height, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(aspectRatio:intValue:)
    @discardableResult
    public func aspectRatio(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .aspectRatio, operatorString: operatorString, inputValue: String(object))
    }
    @objc(aspectRatio:floatValue:)
    @discardableResult
    public func aspectRatio(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .aspectRatio, operatorString: operatorString, inputValue: String(object))
    }
    @objc(aspectRatio:string:)
    @discardableResult
    public func aspectRatio(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .aspectRatio, operatorString: operatorString, inputValue: object)
    }
    @objc(aspectRatio:expression:)
    @discardableResult
    public func aspectRatio(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .aspectRatio, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(aspectRatio:conditionExpression:)
    @discardableResult
    public func aspectRatio(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .aspectRatio, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(initialWidth:intValue:)
    @discardableResult
    public func initialWidth(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .initialWidth, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialWidth:floatValue:)
    @discardableResult
    public func initialWidth(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .initialWidth, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialWidth:string:)
    @discardableResult
    public func initialWidth(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .initialWidth, operatorString: operatorString, inputValue: object)
    }
    @objc(initialWidth:expression:)
    @discardableResult
    public func initialWidth(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .initialWidth, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(initialWidth:conditionExpression:)
    @discardableResult
    public func initialWidth(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .initialWidth, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(initialHeight:intValue:)
    @discardableResult
    public func initialHeight(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .initialHeight, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialHeight:floatValue:)
    @discardableResult
    public func initialHeight(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .initialHeight, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialHeight:string:)
    @discardableResult
    public func initialHeight(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .initialHeight, operatorString: operatorString, inputValue: object)
    }
    @objc(initialHeight:expression:)
    @discardableResult
    public func initialHeight(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .initialHeight, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(initialHeight:conditionExpression:)
    @discardableResult
    public func initialHeight(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .initialHeight, operatorString: operatorString, inputValue: object.asString())
    }

    @objc(initialAspectRatio:intValue:)
    @discardableResult
    public func initialAspectRatio(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .initialAspectRatio, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialAspectRatio:floatValue:)
    @discardableResult
    public func initialAspectRatio(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .initialAspectRatio, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialAspectRatio:string:)
    @discardableResult
    public func initialAspectRatio(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .initialAspectRatio, operatorString: operatorString, inputValue: object)
    }
    @objc(initialAspectRatio:expression:)
    @discardableResult
    public func initialAspectRatio(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .initialAspectRatio, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(initialAspectRatio:conditionExpression:)
    @discardableResult
    public func initialAspectRatio(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .initialAspectRatio, operatorString: operatorString, inputValue: object.asString())
    }

    @objc(pageCount:intValue:)
    @discardableResult
    public func pageCount(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .pageCount, operatorString: operatorString, inputValue: String(object))
    }
    @objc(pageCount:floatValue:)
    @discardableResult
    public func pageCount(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .pageCount, operatorString: operatorString, inputValue: String(object))
    }
    @objc(pageCount:string:)
    @discardableResult
    public func pageCount(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .pageCount, operatorString: operatorString, inputValue: object)
    }
    @objc(pageCount:expression:)
    @discardableResult
    public func pageCount(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .pageCount, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(pageCount:conditionExpression:)
    @discardableResult
    public func pageCount(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .pageCount, operatorString: operatorString, inputValue: object.asString())
    }

    @objc(faceCount:intValue:)
    @discardableResult
    public func faceCount(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .faceCount, operatorString: operatorString, inputValue: String(object))
    }
    @objc(faceCount:floatValue:)
    @discardableResult
    public func faceCount(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .faceCount, operatorString: operatorString, inputValue: String(object))
    }
    @objc(faceCount:string:)
    @discardableResult
    public func faceCount(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .faceCount, operatorString: operatorString, inputValue: object)
    }
    @objc(faceCount:expression:)
    @discardableResult
    public func faceCount(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .faceCount, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(faceCount:conditionExpression:)
    @discardableResult
    public func faceCount(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .faceCount, operatorString: operatorString, inputValue: object.asString())
    }

    @objc(tags:intValue:)
    @discardableResult
    public func tags(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .tags, operatorString: operatorString, inputValue: String(object))
    }
    @objc(tags:floatValue:)
    @discardableResult
    public func tags(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .tags, operatorString: operatorString, inputValue: String(object))
    }
    @objc(tags:string:)
    @discardableResult
    public func tags(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .tags, operatorString: operatorString, inputValue: object)
    }
    @objc(tags:expression:)
    @discardableResult
    public func tags(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .tags, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(tags:conditionExpression:)
    @discardableResult
    public func tags(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .tags, operatorString: operatorString, inputValue: object.asString())
    }

    @objc(pageXOffset:intValue:)
    @discardableResult
    public func pageXOffset(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .pageX, operatorString: operatorString, inputValue: String(object))
    }
    @objc(pageXOffset:floatValue:)
    @discardableResult
    public func pageXOffset(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .pageX, operatorString: operatorString, inputValue: String(object))
    }
    @objc(pageXOffset:string:)
    @discardableResult
    public func pageXOffset(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .pageX, operatorString: operatorString, inputValue: object)
    }
    @objc(pageXOffset:expression:)
    @discardableResult
    public func pageXOffset(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .pageX, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(pageXOffset:conditionExpression:)
    @discardableResult
    public func pageXOffset(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .pageX, operatorString: operatorString, inputValue: object.asString())
    }

    @objc(pageYOffset:intValue:)
    @discardableResult
    public func pageYOffset(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .pageY, operatorString: operatorString, inputValue: String(object))
    }
    @objc(pageYOffset:floatValue:)
    @discardableResult
    public func pageYOffset(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .pageY, operatorString: operatorString, inputValue: String(object))
    }
    @objc(pageYOffset:string:)
    @discardableResult
    public func pageYOffset(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .pageY, operatorString: operatorString, inputValue: object)
    }
    @objc(pageYOffset:expression:)
    @discardableResult
    public func pageYOffset(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .pageY, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(pageYOffset:conditionExpression:)
    @discardableResult
    public func pageYOffset(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .pageY, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(illustrationScore:intValue:)
    @discardableResult
    public func illustrationScore(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .illustrationScore, operatorString: operatorString, inputValue: String(object))
    }
    @objc(illustrationScore:floatValue:)
    @discardableResult
    public func illustrationScore(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .illustrationScore, operatorString: operatorString, inputValue: String(object))
    }
    @objc(illustrationScore:string:)
    @discardableResult
    public func illustrationScore(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .illustrationScore, operatorString: operatorString, inputValue: object)
    }
    @objc(illustrationScore:expression:)
    @discardableResult
    public func illustrationScore(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .illustrationScore, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(illustrationScore:conditionExpression:)
    @discardableResult
    public func illustrationScore(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .illustrationScore, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(currentPageIndex:intValue:)
    @discardableResult
    public func currentPageIndex(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .currentPage, operatorString: operatorString, inputValue: String(object))
    }
    @objc(currentPageIndex:floatValue:)
    @discardableResult
    public func currentPageIndex(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .currentPage, operatorString: operatorString, inputValue: String(object))
    }
    @objc(currentPageIndex:string:)
    @discardableResult
    public func currentPageIndex(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .currentPage, operatorString: operatorString, inputValue: object)
    }
    @objc(currentPageIndex:expression:)
    @discardableResult
    public func currentPageIndex(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .currentPage, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(currentPageIndex:conditionExpression:)
    @discardableResult
    public func currentPageIndex(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .currentPage, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(duration:intValue:)
    @discardableResult
    public func duration(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .duration, operatorString: operatorString, inputValue: String(object))
    }
    @objc(duration:floatValue:)
    @discardableResult
    public func duration(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .duration, operatorString: operatorString, inputValue: String(object))
    }
    @objc(duration:string:)
    @discardableResult
    public func duration(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .duration, operatorString: operatorString, inputValue: object)
    }
    @objc(duration:expression:)
    @discardableResult
    public func duration(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .duration, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(duration:conditionExpression:)
    @discardableResult
    public func duration(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .duration, operatorString: operatorString, inputValue: object.asString())
    }
    
    @objc(initialDuration:intValue:)
    @discardableResult
    public func initialDuration(_ operatorString: String, _ object: Int) -> Self {
        return predicate(expressionKey: .initialDuration, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialDuration:floatValue:)
    @discardableResult
    public func initialDuration(_ operatorString: String, _ object: Float) -> Self {
        return predicate(expressionKey: .initialDuration, operatorString: operatorString, inputValue: String(object))
    }
    @objc(initialDuration:string:)
    @discardableResult
    public func initialDuration(_ operatorString: String, _ object: String) -> Self {
        return predicate(expressionKey: .initialDuration, operatorString: operatorString, inputValue: object)
    }
    @objc(initialDuration:expression:)
    @discardableResult
    public func initialDuration(_ operatorString: String, _ object: CLDExpression) -> Self {
        return predicate(expressionKey: .initialDuration, operatorString: operatorString, inputValue: object.asInternalString())
    }
    @objc(initialDuration:conditionExpression:)
    @discardableResult
    public func initialDuration(_ operatorString: String, _ object: CLDConditionExpression) -> Self {
        return predicate(expressionKey: .initialDuration, operatorString: operatorString, inputValue: object.asString())
    }
    
    // MARK: - Private Methods
    private func appendingStringToCurrentValue(cldoperator: CLDOperators, inputValue: String) {
        
        let expression = CLDExpression.init(value: inputValue)
        
        let value: String
        if  expression.currentValue.isEmpty {

            value = inputValue
        } else {
         
            value = expression.asString()
        }
        
        appendOperatorToCurrentValue(cldoperator, inputValue: value)
    }
    
    fileprivate func predicate(expressionKey: ExpressionKeys, operatorString: String, inputValue: String) -> Self {
        let stringPredicate = "\(expressionKey.asString) \(operatorString) \(inputValue)"
        return value(stringPredicate)
    }
}
