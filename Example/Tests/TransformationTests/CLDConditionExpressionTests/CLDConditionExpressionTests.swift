//
//  CLDConditionExpressionTests.swift
//
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

@testable import Cloudinary
import Foundation
import XCTest

class CLDConditionExpressionTests: BaseTestCase {
    
    var sut : CLDConditionExpression!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - test initilization methods - empty
    func test_init_emptyInputParamaters_shouldStoreEmptyProperties() {
        
        // Given
        let name = String()
        
        // When
        sut = CLDConditionExpression()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil currentKey  property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil currentValue property")
        XCTAssertEqual(sut.currentKey, name, "Name property should be equal to name")
        XCTAssertEqual(sut.currentValue, String(), "Initilized object should contain an empty string as currentValue property")
    }
    
    // MARK: - test initilization methods - value
    func test_init_emptyNameParamater_shouldStoreEmptyNameProperty() {
        
        // Given
        let name  = String()
        let value = "alue"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil currentKey  property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil currentValue property")
        XCTAssertEqual(sut.currentValue, value, "Initilized object should contain an empty string as value property")
    }
    
    func test_init_validStringParamatersAndNoNamePrefix_shouldStoreValidProperties() {
        
        // Given
        let name  = "name"
        let value = "alue"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil name  property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, name, "currentKey should be equal to name")
        XCTAssertEqual(sut.currentValue, value, "Initilized object should contain a string as value property")
    }
    
    func test_init_validStringParamaters_shouldStoreValidProperties() {
        
        // Given
        let name  = "w"
        let value = "* 2"
        let valueResult = "*_2"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil name  property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, name, "currentKey should be equal to name")
        XCTAssertEqual(sut.currentValue, valueResult, "Initilized object should contain a string as valueResult property")
    }
    
    
    // MARK: - test class methods
    func test_width_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "w"
        
        // When
        sut = CLDConditionExpression.width()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_height_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "h"
        
        // When
        sut = CLDConditionExpression.height()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_initialWidth_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "iw"
        
        // When
        sut = CLDConditionExpression.initialWidth()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_initialHeight_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "ih"
        
        // When
        sut = CLDConditionExpression.initialHeight()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_aspectRatio_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "ar"
        
        // When
        sut = CLDConditionExpression.aspectRatio()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_initialAspectRatio_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "iar"
        
        // When
        sut = CLDConditionExpression.initialAspectRatio()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_pageCount_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "pc"
        
        // When
        sut = CLDConditionExpression.pageCount()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_faceCount_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "fc"
        
        // When
        sut = CLDConditionExpression.faceCount()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_tags_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "tags"
        
        // When
        sut = CLDConditionExpression.tags()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_pageXOffset_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "px"
        
        // When
        sut = CLDConditionExpression.pageXOffset()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_pageYOffset_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "py"
        
        // When
        sut = CLDConditionExpression.pageYOffset()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_illustrationScore_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "ils"
        
        // When
        sut = CLDConditionExpression.illustrationScore()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    func test_currentPageIndex_shouldStoreValidKey() {
        
        // Given
        let expectedResult = "cp"
        
        // When
        sut = CLDConditionExpression.currentPageIndex()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentKey, expectedResult, "currentKey should be equal to expectedResult")
    }
    
    // MARK: - test instance method
    // MARK: - add
    func test_addInt_shouldStoreValidFirstValue() {
        
        // Given
        let value = 20
        let expectedValueResult = "add_20"
        // When
        
        sut = CLDConditionExpression.width().add(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_addInt_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = 20
        
        let expectedValueResult = "width_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").add(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_addFloat_shouldStoreValidFirstValue() {
        
        // Given
        let value = Float(30.3)
        let expectedValueResult = "add_30.3"
        // When
        
        sut = CLDConditionExpression.width().add(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_addFloat_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expectedValueResult = "width_add_30.3"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").add(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - subtract
    func test_subtractInt_shouldStoreValidFirstValue() {
        
        // Given
        let value = 20
        let expectedValueResult = "sub_20"
        // When
        
        sut = CLDConditionExpression.width().subtract(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_subtractInt_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = 20
        
        let expectedValueResult = "width_sub_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").subtract(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_subtractFloat_shouldStoreValidFirstValue() {
        
        // Given
        let value = Float(30.3)
        let expectedValueResult = "sub_30.3"
        // When
        
        sut = CLDConditionExpression.width().subtract(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_subtractFloat_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expectedValueResult = "width_sub_30.3"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").subtract(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - multiple
    func test_multipleInt_shouldStoreValidFirstValue() {
        
        // Given
        let value = 20
        let expectedValueResult = "mul_20"
        // When
        
        sut = CLDConditionExpression.width().multiple(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_multipleInt_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = 20
        
        let expectedValueResult = "width_mul_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").multiple(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_multipleFloat_shouldStoreValidFirstValue() {
        
        // Given
        let value = Float(30.3)
        let expectedValueResult = "mul_30.3"
        // When
        
        sut = CLDConditionExpression.width().multiple(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_multipleFloat_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expectedValueResult = "width_mul_30.3"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").multiple(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - divide
    func test_divideInt_shouldStoreValidFirstValue() {
        
        // Given
        let value = 20
        let expectedValueResult = "div_20"
        // When
        
        sut = CLDConditionExpression.width().divide(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_divideInt_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = 20
        
        let expectedValueResult = "width_div_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_divideFloat_shouldStoreValidFirstValue() {
        
        // Given
        let value = Float(30.3)
        let expectedValueResult = "div_30.3"
        // When
        
        sut = CLDConditionExpression.width().divide(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_divideFloat_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expectedValueResult = "width_div_30.3"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - power
    func test_powerInt_shouldStoreValidFirstValue() {
        
        // Given
        let value = 20
        let expectedValueResult = "pow_20"
        
        // When
        sut = CLDConditionExpression.width().power(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_powerInt_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = 20
        
        let expectedValueResult = "width_pow_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").power(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_powerFloat_shouldStoreValidFirstValue() {
        
        // Given
        let value = Float(30.3)
        let expectedValueResult = "pow_30.3"
        
        // When
        sut = CLDConditionExpression.width().power(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_powerFloat_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expectedValueResult = "width_pow_30.3"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").power(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_powerFloat_shouldAppendValidValueToVariable() {
        //    $big_$small_pow_1.5/c_fill,w_$big,h_$small_add_20
        // Given
        let initialValue = "$big $small ^  1.5"
        let expectedValueResult = "$big_$small_pow_1.5"
        
        // When
        sut = CLDConditionExpression(value: initialValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_powerString_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = "30.3"
        
        let expectedValueResult = "width_pow_30.3"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").power(by: value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - equal
    func test_equalFloat_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let equalValue = Float(10.1)
        let expectedValueResult = "width_div_30.3_eq_10.1"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).equal(to: equalValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_equalString_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let equalValue = "initialHeight"
        let expectedValueResult = "width_div_30.3_eq_initialHeight"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).equal(to: equalValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_equalBaseExpression_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let equalValue = CLDExpression.initialHeight()
        let expectedValueResult = "width_div_30.3_eq_ih"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).equal(to: equalValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_equalExpression_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "width_div_30.3_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).equal(to: expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - notEqual
    func test_notEqual_floatValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        let unequalValue = Float(10.1)
        
        let expectedValueResult = "width_div_30.3_ne_10.1"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).notEqual(to: unequalValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_notEqual_stringValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let unequalValue = "initialHeight"
        let expectedValueResult = "width_div_30.3_ne_initialHeight"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).notEqual(to: unequalValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_notEqual_baseExpressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let unequalValue = CLDExpression.initialHeight()
        let expectedValueResult = "width_div_30.3_ne_ih"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).notEqual(to: unequalValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_notEqual_expressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "width_div_30.3_ne_ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).notEqual(to: expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }

    // MARK: - less
    func test_less_stringValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessValue = "initialHeight"
        let expectedValueResult = "width_div_30.3_lt_initialHeight"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).less(then: lessValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_less_intValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessValue = 100
        let expectedValueResult = "width_div_30.3_lt_100"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).less(then: lessValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_less_floatValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessValue: Float = 100.1
        let expectedValueResult = "width_div_30.3_lt_100.1"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).less(then: lessValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_less_baseExpressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessValue = CLDExpression.initialHeight()
        let expectedValueResult = "width_div_30.3_lt_ih"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).less(then: lessValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_less_expressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "width_div_30.3_lt_ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).less(then: expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - greater
    func test_greater_stringValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterValue = "initialHeight"
        let expectedValueResult = "width_div_30.3_gt_initialHeight"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greater(then: greaterValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greater_intValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterValue = 100
        let expectedValueResult = "width_div_30.3_gt_100"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greater(then: greaterValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greater_floatValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterValue: Float = 100.1
        let expectedValueResult = "width_div_30.3_gt_100.1"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greater(then: greaterValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greater_baseExpressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterValue = CLDExpression.initialHeight()
        let expectedValueResult = "width_div_30.3_gt_ih"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greater(then: greaterValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greater_expressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "width_div_30.3_gt_ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greater(then: expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - lessOrEqual
    func test_lessOrEqual_stringValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessOrEqualValue = "initialHeight"
        let expectedValueResult = "width_div_30.3_lte_initialHeight"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).lessOrEqual(to: lessOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_lessOrEqual_intValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessOrEqualValue = 100
        let expectedValueResult = "width_div_30.3_lte_100"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).lessOrEqual(to: lessOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_lessOrEqual_floatValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessOrEqualValue: Float = 100.1
        let expectedValueResult = "width_div_30.3_lte_100.1"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).lessOrEqual(to: lessOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_lessOrEqual_baseExpressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let lessOrEqualValue = CLDExpression.initialHeight()
        let expectedValueResult = "width_div_30.3_lte_ih"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).lessOrEqual(to: lessOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_lessOrEqual_expressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "width_div_30.3_lte_ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).lessOrEqual(to: expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - greaterOrEqual
    func test_greaterOrEqual_stringValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterOrEqualValue = "initialHeight"
        let expectedValueResult = "width_div_30.3_gte_initialHeight"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greaterOrEqual(to: greaterOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greaterOrEqual_intValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterOrEqualValue = 100
        let expectedValueResult = "width_div_30.3_gte_100"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greaterOrEqual(to: greaterOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greaterOrEqual_floatValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterOrEqualValue: Float = 100.1
        let expectedValueResult = "width_div_30.3_gte_100.1"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greaterOrEqual(to: greaterOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greaterOrEqual_baseExpressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let greaterOrEqualValue = CLDExpression.initialHeight()
        let expectedValueResult = "width_div_30.3_gte_ih"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greaterOrEqual(to: greaterOrEqualValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_greaterOrEqual_expressionValue_shouldAppendValidValue() {
        
        // Given
        let name = "height"
        let initialValue = "width"
        let value = Float(30.3)
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "width_div_30.3_gte_ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(initialValue)").divide(by: value).greaterOrEqual(to: expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - or
    func test_or_shouldAppendValidValue() {
        
        // Given
        let value = "width > 200"
        let expectedValueResult = ">_200_or"
        
        // When
        sut = CLDConditionExpression(value: value).or()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - and
    func test_and_shouldAppendValidValue() {
        
        // Given
        let value = "width > 200"
        let expectedValueResult = ">_200_and"
        
        // When
        sut = CLDConditionExpression(value: value).and()
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - value
    func test_value_empty_shouldNotAppendValue() {
        
        // Given
        let value = ""
        let expectedValueResult = ""
        
        // When
        sut = CLDConditionExpression().value(value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_valueOnEmptyKey_validStringParamaters_shouldAppendValidValue() {
        
        // Given
        let value = "width > 200"
        let expectedValueResult = ">_200"
        
        // When
        sut = CLDConditionExpression().value(value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_valueValidKey_validStringParamaters_shouldAppendValidValue() {
        
        // Given
        let value = "> 200"
        let initialValue = "width"
        let expectedValueResult = ">_200"
        
        // When
        sut = CLDConditionExpression(value: initialValue).value(value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_value_expressionValue_shouldAppendValidValue() {
        
        // Given
        let initialValue = "width"
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "ih_add_20"
        
        // When
        sut = CLDConditionExpression(value: initialValue).value(expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_valueAfterAnd_shouldAppendValidValue() {
        
        // Given
        let initialValue = "width > 200"
        let value = "height > 200"
        let expectedValueResult = ">_200_and_h_gt_200"
        
        // When
        sut = CLDConditionExpression(value: initialValue).and().value(value)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - inside
    func test_inside_empty_shouldNotAppendValue() {
        
        // Given
        let tag = "!myTag2!"
        let expectedValueResult = ""
        
        // When
        sut = CLDConditionExpression().value(tag).inside("")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_inside_validStringParamaters_shouldAppendValidValue() {
        
        // Given
        let tag = "!myTag2!"
        let expectedValueResult = "in_tags"
        
        // When
        sut = CLDConditionExpression().value(tag).inside("tags")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_inside_expressionValue_shouldAppendValidValue() {
        
        // Given
        let tag = "!myTag2!"
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "in_ih_add_20"
        
        // When
        sut = CLDConditionExpression().value(tag).inside(expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - notInside
    func test_notInside_empty_shouldNotAppendValue() {
        
        // Given
        let tag = "!myTag2!"
        let expectedValueResult = ""
        
        // When
        sut = CLDConditionExpression().value(tag).notInside("")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_notInside_validStringParamaters_shouldAppendValidValue() {
        
        // Given
        let tag = "!myTag2!"
        let expectedValueResult = "nin_tags"
        
        // When
        sut = CLDConditionExpression().value(tag).notInside("tags")
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    func test_notInside_expressionValue_shouldAppendValidValue() {
        
        // Given
        let tag = "!myTag2!"
        
        let expressionValue = CLDExpression.initialHeight().add(by: 20)
        let expectedValueResult = "nin_ih_add_20"
        
        // When
        sut = CLDConditionExpression().value(tag).notInside(expressionValue)
        
        // Then
        XCTAssertNotNil(sut.currentKey, "Initilized object should contain a none nil key property")
        XCTAssertNotNil(sut.currentValue, "Initilized object should contain a none nil value property")
        
        XCTAssertEqual(sut.currentValue, expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - test asString()
    func test_asString_emptyInputParamaters_shouldReturnEmptyString() {
        
        // Given
        let value = String()
        let expectedResult = String()
        
        // When
        sut = CLDConditionExpression(value: value)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString on an empty CLDConditionExpression, should return an empty string")
    }
    
    func test_asString_validParamaters_shouldReturnValidString() {
        
        // Given
        let name            = "initialWidth"
        let value           = "* 200 / faceCount"
        let expectedResult  = "iw_mul_200_div_fc"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString on a CLDConditionExpression, should return a string")
    }
    
    func test_asString_emptyKey_shouldReturnEmptyString() {
        
        // Given
        let name            = "initialWidth"
        let value           = "* 200 / faceCount"
        let expectedValue   = "*_200_/_faceCount"
        let expectedResult  = ""
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        sut.currentKey = ""
        
        let actualResult = sut.asString()
        let actualValue  = sut.currentValue
        
        // Then
        XCTAssertEqual(actualValue,  expectedValue, "Calling asString on a CLDConditionExpression, should return a string")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString on a CLDConditionExpression, should return an empty string")
    }
    
    func test_asString_extraSpacesStringParamaters_shouldReturnValidString() {
        
        // Given
        let name            = "initialWidth"
        let value           = "*      200"
        let expectedResult  = "iw_mul_200"
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString, should remove extra dashes/spaces")
    }
    
    // MARK: - test asParams()
    func test_asParams_emptyInputParamaters_shouldReturnEmptyString() {
        
        // Given
        let value = String()
        let expectedResult = [String:String]()
        
        // When
        sut = CLDConditionExpression(value: value)
        
        let actualResult = sut.asParams()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asParams, should build a paramater representation")
    }
    
    func test_asParams_validParamaters_shouldReturnValidString() {
        
        // Given
        let name            = "initialWidth"
        let value           = "* 200 / faceCount"
        let expectedResult  = ["iw":"mul_200_div_fc"]
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        let actualResult = sut.asParams()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asParams, should build a paramater representation")
    }
    
    func test_asParam_emptyKey_shouldReturnEmptyString() {
        
        // Given
        let name            = "initialWidth"
        let value           = "* 200 / faceCount"
        let expectedValue   = "*_200_/_faceCount"
        let expectedResult  = [String:String]()
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        sut.currentKey = ""
        
        let actualResult = sut.asParams()
        let actualValue  = sut.currentValue
        
        // Then
        XCTAssertEqual(actualValue,  expectedValue, "Calling asString on a CLDConditionExpression, should return a string")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString on a CLDConditionExpression, should return an empty string")
    }
    
    func test_asParams_extraSpacesStringParamaters_shouldReturnValidString() {
        
        // Given
        let name            = "initialWidth"
        let value           = "*      200"
        let expectedResult  = ["iw":"mul_200"]
        
        // When
        sut = CLDConditionExpression(value: "\(name) \(value)")
        
        let actualResult = sut.asParams()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString, should remove extra dashes/spaces")
    }
}
