//
//  CLDConditionExpressionHelpersTests.swift
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

class CLDConditionExpressionHelpersTests: BaseTestCase {
    
    var sut : CLDConditionExpression!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - widthWithOperator
    func test_widthWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "w_lt_100"
        
        // When
        sut = CLDConditionExpression().width(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_widthWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "w_gt_30.3"
        
        // When
        sut = CLDConditionExpression().width(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_widthWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "w_eq_30.3"
        
        // When
        sut = CLDConditionExpression().width(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_widthWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "w_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().width(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_widthWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "w_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().width(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - heightWithOperator
    func test_heightWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "h_lt_100"
        
        // When
        sut = CLDConditionExpression().height(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_heightWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "h_gt_30.3"
        
        // When
        sut = CLDConditionExpression().height(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_heightWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "h_eq_30.3"
        
        // When
        sut = CLDConditionExpression().height(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_heightWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "h_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().height(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_heightWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "h_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().height(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - aspectRatioWithOperator
    func test_aspectRatioWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "ar_lt_100"
        
        // When
        sut = CLDConditionExpression().aspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_aspectRatioWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "ar_gt_30.3"
        
        // When
        sut = CLDConditionExpression().aspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_aspectRatioWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "ar_eq_30.3"
        
        // When
        sut = CLDConditionExpression().aspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_aspectRatioWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "ar_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().aspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_aspectRatioWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "ar_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().aspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - initialWidthWithOperator
    func test_initialWidthWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "iw_lt_100"
        
        // When
        sut = CLDConditionExpression().initialWidth(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialWidthWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "iw_gt_30.3"
        
        // When
        sut = CLDConditionExpression().initialWidth(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialWidthWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "iw_eq_30.3"
        
        // When
        sut = CLDConditionExpression().initialWidth(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialWidthWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "iw_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialWidth(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialWidthWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "iw_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialWidth(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - initialHeightWithOperator
    func test_initialHeightWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "ih_lt_100"
        
        // When
        sut = CLDConditionExpression().initialHeight(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialHeightWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "ih_gt_30.3"
        
        // When
        sut = CLDConditionExpression().initialHeight(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialHeightWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "ih_eq_30.3"
        
        // When
        sut = CLDConditionExpression().initialHeight(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialHeightWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "ih_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialHeight(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialHeightWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "ih_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialHeight(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - initialAspectRatioWithOperator
    func test_initialAspectRatioWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "iar_lt_100"
        
        // When
        sut = CLDConditionExpression().initialAspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialAspectRatioWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "iar_gt_30.3"
        
        // When
        sut = CLDConditionExpression().initialAspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialAspectRatioWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "iar_eq_30.3"
        
        // When
        sut = CLDConditionExpression().initialAspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialAspectRatioWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "iar_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialAspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialAspectRatioWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "iar_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialAspectRatio(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - pageCountWithOperator
    func test_pageCountWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "pc_lt_100"
        
        // When
        sut = CLDConditionExpression().pageCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageCountWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "pc_gt_30.3"
        
        // When
        sut = CLDConditionExpression().pageCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageCountWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "pc_eq_30.3"
        
        // When
        sut = CLDConditionExpression().pageCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageCountWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "pc_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().pageCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageCountWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "pc_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().pageCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - faceCountWithOperator
    func test_faceCountWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "fc_lt_100"
        
        // When
        sut = CLDConditionExpression().faceCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_faceCountWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "fc_gt_30.3"
        
        // When
        sut = CLDConditionExpression().faceCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_faceCountWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "fc_eq_30.3"
        
        // When
        sut = CLDConditionExpression().faceCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_faceCountWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "fc_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().faceCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_faceCountWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "fc_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().faceCount(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - tagsWithOperator
    func test_tagsWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "tags_lt_100"
        
        // When
        sut = CLDConditionExpression().tags(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_tagsWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "tags_gt_30.3"
        
        // When
        sut = CLDConditionExpression().tags(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_tagsWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "tags_eq_30.3"
        
        // When
        sut = CLDConditionExpression().tags(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_tagsWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "tags_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().tags(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_tagsWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "tags_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().tags(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - pageXOffsetWithOperator
    func test_pageXOffsetWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "px_lt_100"
        
        // When
        sut = CLDConditionExpression().pageXOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageXOffsetWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "px_gt_30.3"
        
        // When
        sut = CLDConditionExpression().pageXOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageXOffsetWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "px_eq_30.3"
        
        // When
        sut = CLDConditionExpression().pageXOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageXOffsetWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "px_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().pageXOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageXOffsetWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "px_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().pageXOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - pageYOffsetWithOperator
    func test_pageYOffsetWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "py_lt_100"
        
        // When
        sut = CLDConditionExpression().pageYOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageYOffsetWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "py_gt_30.3"
        
        // When
        sut = CLDConditionExpression().pageYOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageYOffsetWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "py_eq_30.3"
        
        // When
        sut = CLDConditionExpression().pageYOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageYOffsetWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "py_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().pageYOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_pageYOffsetWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "py_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().pageYOffset(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - illustrationScoreWithOperator
    func test_illustrationScoreWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "ils_lt_100"
        
        // When
        sut = CLDConditionExpression().illustrationScore(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_illustrationScoreWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "ils_gt_30.3"
        
        // When
        sut = CLDConditionExpression().illustrationScore(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_illustrationScoreWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "ils_eq_30.3"
        
        // When
        sut = CLDConditionExpression().illustrationScore(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_illustrationScoreWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "ils_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().illustrationScore(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_illustrationScoreWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "ils_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().illustrationScore(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - currentPageIndexWithOperator
    func test_currentPageIndexWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "cp_lt_100"
        
        // When
        sut = CLDConditionExpression().currentPageIndex(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_currentPageIndexWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "cp_gt_30.3"
        
        // When
        sut = CLDConditionExpression().currentPageIndex(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_currentPageIndexWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "cp_eq_30.3"
        
        // When
        sut = CLDConditionExpression().currentPageIndex(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_currentPageIndexWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "cp_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().currentPageIndex(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_currentPageIndexWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "cp_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().currentPageIndex(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - durationWithOperator
    func test_durationWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "du_lt_100"
        
        // When
        sut = CLDConditionExpression().duration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_durationWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "du_gt_30.3"
        
        // When
        sut = CLDConditionExpression().duration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_durationWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "du_eq_30.3"
        
        // When
        sut = CLDConditionExpression().duration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_durationWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "du_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().duration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_durationWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "du_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().duration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    
    // MARK: - initialDurationWithOperator
    func test_initialDurationWithOperator_intValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "<"
        let value: Int = 100
        
        let expectedValueResult = "idu_lt_100"
        
        // When
        sut = CLDConditionExpression().initialDuration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialDurationWithOperator_floatValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = ">"
        let value = Float(30.3)
        
        let expectedValueResult = "idu_gt_30.3"
        
        // When
        sut = CLDConditionExpression().initialDuration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialDurationWithOperator_stringValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = "30.3"
        
        let expectedValueResult = "idu_eq_30.3"
        
        // When
        sut = CLDConditionExpression().initialDuration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialDurationWithOperator_expressionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDExpression.initialHeight().add(by: 20)
        
        let expectedValueResult = "idu_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialDuration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
    func test_initialDurationWithOperator_conditionValue_shouldAppendValidValue() {
        
        // Given
        let stringOperator = "="
        let value = CLDConditionExpression.initialHeight().add(by: 20)
        let expectedValueResult = "idu_eq_ih_add_20"
        
        // When
        sut = CLDConditionExpression().initialDuration(stringOperator, value)
        
        // Then
        XCTAssertEqual(sut.asString(), expectedValueResult, "currentValue should be equal to expectedValueResult")
    }
}
