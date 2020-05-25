//
//  CLDTransformationConditionsTests.swift
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

// MARK: - ConditionalCLDTransformationTests
class CLDTransformationConditionsTests: BaseTestCase {
    
    var sut : CLDTransformation!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
        sut = CLDTransformation()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - ifCondition with String
    func test_ifCondition_emptyStringProperty_shouldNotStoreNewParam() {
        
        // Given
        let stringInput = String()
        
        // When
        sut.ifCondition(stringInput)
        
        let actualResult = sut.ifParam!
        
        // Then
        XCTAssertTrue(actualResult.isEmpty, "Empty expression should not be stored in params")
    }
    
    func test_ifCondition_spacedStringProperty_shouldStoreValidString() {
        
        // Given
        let stringInput = "w < 200"
        
        let expectedResult = "w_lt_200"
        
        // When
        sut.ifCondition(stringInput)
        
        let actualResult = sut.ifParam!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "valid value should be stored")
        XCTAssertEqual(actualResult, expectedResult, "Calling for valid value should return the expected result")
    }
    
    // MARK: - ifCondition with CLDConditionExpression
    func test_ifCondition_emptyConditionProperty_shouldNotStoreNewParam() {
        
        // Given
        let conditionObject = CLDConditionExpression()
        
        // When
        sut.ifCondition(conditionObject)
        
        let actualResult = sut.ifParam!
        
        // Then
        XCTAssertTrue(actualResult.isEmpty, "Empty expression should not be stored in params")
    }
    
    func test_ifCondition_conditionProperty_shouldStoreValidString() {
        
        // Given
        let initialValue = "width < 200"
        let conditionObject = CLDConditionExpression(value: initialValue)
        
        let expectedResult = "w_lt_200"
        
        // When
        sut.ifCondition(conditionObject)
        
        let actualResult = sut.ifParam!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "valid value should be stored")
        XCTAssertEqual(actualResult, expectedResult, "Calling for valid value should return the expected result")
    }
    
    // MARK: - asString()
    func test_ifConditionAsString_emptyConditionProperty_shouldStoreNil() {
        
        // Given
        let conditionObject = CLDConditionExpression()
        
        // When
        sut.ifCondition(conditionObject)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertNil(actualResult, "Empty expression should not return from asString()")
    }
    
    func test_ifConditionAsString_emptyStringProperty_shouldStoreNil() {
        
        // Given
        let emptyString = String()
        
        // When
        sut.ifCondition(emptyString)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertNil(actualResult, "Empty expression should not return from asString()")
    }
    
    func test_ifConditionAsString_spacedStringProperty_shouldReturnValidString() {
        
        // Given
        let stringInput = "w < 200"
        
        let expectedResult = "if_w_lt_200"
        
        // When
        sut.ifCondition(stringInput)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString should return the expected result")
    }
    
    func test_ifConditionAsString_extraSpacedStringProperty_shouldReturnValidString() {
        
        // Given
        let stringInput = "w <       200"
        
        let expectedResult = "if_w_lt_200"
        
        // When
        sut.ifCondition(stringInput)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString, should remove extra dashes/spaces")
    }
    
    func test_ifConditionAsString_stringProperty_shouldReturnValidString() {
        
        // Given
        let stringInput = "w_lt_200"
        
        let expectedResult = "if_w_lt_200"
        
        // When
        sut.ifCondition(stringInput)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString should return the expected result")
    }
    
    func test_ifCondition_orderedStringConditionAndMultiProperties_shouldReturnValidString() {
        
        // Given
        let conditionStringInput = "w_lt_200"
        
        let expectedResult = "if_w_lt_200,c_fill,h_120,w_80"
        
        // When
        sut.ifCondition(conditionStringInput).setCrop(.fill).setHeight(120).setWidth(80)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasPrefix("if"), "ifCondition should appear at the beginning of the trasformation string")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString should return the expected result")
    }
    
    func test_ifCondition_unorderedStringConditionAndMultiProperties_shouldReturnValidOrderedString() {
        
        // Given
        let conditionStringInput = "w_lt_200"
        
        let expectedResult = "if_w_lt_200,c_fill,h_120,w_80"
        
        // When
        sut.setCrop(.fill).setHeight(120).ifCondition(conditionStringInput).setWidth(80)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasPrefix("if"), "ifCondition should appear at the beginning of the trasformation string")
        XCTAssertEqual(actualResult, expectedResult, "components should be in proper order")
    }
    
    // MARK: - multi transformations condition
    func test_multiTransformationIfCondition_StringConditionAndMultiProperties_shouldReturnValidOrderedString() {
        
        // Given
        let conditionStringInput1 = "w_lt_200"
        let conditionStringInput2 = "w_gt_400"
        
        let expectedResult = "if_w_lt_200,c_fill,h_120,w_80/if_w_gt_400,c_fit,h_150,w_150/e_sepia"
        
        // When
        sut.ifCondition(conditionStringInput1).setCrop(.fill).setHeight(120).setWidth(80)
            .chain().ifCondition(conditionStringInput2).setCrop(.fit).setHeight(150).setWidth(150)
            .chain().setEffect(.sepia)
        
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasPrefix("if"), "ifCondition should appear at the beginning of the trasformation string")
        XCTAssertEqual(actualResult, expectedResult, "should allow multiple conditions when chaining transformations")
    }
    
    func test_multiTransformationUnorderedIfCondition_StringConditionAndMultiProperties_shouldReturnValidOrderedString() {
        
        // Given
        let conditionStringInput1 = "w_lt_200"
        let conditionStringInput2 = "w_gt_400"
        
        let expectedResult = "if_w_lt_200,c_fill,h_120,w_80/if_w_gt_400,c_fit,h_150,w_150/e_sepia"
        
        // When
        sut.setCrop(.fill).ifCondition(conditionStringInput1).setHeight(120).setWidth(80)
            .chain().setCrop(.fit).setHeight(150).ifCondition(conditionStringInput2).setWidth(150)
            .chain().setEffect(.sepia)
        
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasPrefix("if"), "ifCondition should appear at the beginning of the trasformation string")
        XCTAssertEqual(actualResult, expectedResult, "should order multiple conditions when chaining transformations")
    }
    
    // MARK: - operators
    func test_ifCondition_specialOperators_shouldReturnValidString() {
        
        // Given
        let initialValue    = "width > 200"
        let valueHeight     = "height > 200"
        let valueWidth      = "width < 300"
        let expectedResult  = "if_w_gt_200_and_h_gt_200_or_w_lt_300"
        
        let conditionObject = CLDConditionExpression(value: initialValue).and().value(valueHeight).or().value(valueWidth)
        
        // When
        sut.ifCondition(conditionObject)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasPrefix("if"), "ifCondition should appear at the beginning of the trasformation string")
        XCTAssertEqual(actualResult, expectedResult, "Calling asString should return the expected result")
    }
    
    // MARK: - ifElse
    func test_ifElse_shouldStoreNewParam() {
        
        // Given
        let expectedResult  = "else"
        
        // When
        sut.ifElse()
        
        let actualResult = sut.ifParam!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "valid value should be stored")
        XCTAssertEqual(actualResult, expectedResult, "Calling for valid value should return the expected result")
    }
    
    func test_ifElse_shouldReturnValidString() {
        
        // Given
        let expectedResult  = "if_else"
        
        // When
        sut.ifElse()
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "valid value should be stored")
        XCTAssertEqual(actualResult, expectedResult, "Calling for valid value should return the expected result")
    }
    
    func test_ifElse_multiProperties_shouldReturnValidString() {
        
        // Given
        let conditionStringInput = "w_lt_200"
        
        let expectedResult = "if_w_lt_200,c_fill,h_120,w_80/if_else,c_fit,h_150,w_150/e_sepia"
        
        // When
        sut.ifCondition(conditionStringInput).setCrop(.fill).setHeight(120).setWidth(80)
            .ifElse().setCrop(.fit).setHeight(150).setWidth(150)
            .chain().setEffect(.sepia)
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasPrefix("if"), "ifCondition should appear at the beginning of the trasformation string")
        XCTAssertEqual(actualResult, expectedResult, "should order multiple conditions when chaining transformations")
    }
        
    // MARK: - endIf
    func test_endIf_emptyTransformation_shouldReturnNil() {
        
        // When
        sut.endIf()
        
        let actualResult = sut.ifParam
        
        // Then
        XCTAssertNil(actualResult, "endIf should not stand alone")
    }
    
    func test_endIf_multiProperties_shouldReturnValidString() {
        
        // Given
        let conditionStringInput = "w_lt_200"
        
        let expectedResult = "if_w_lt_200/c_fill,h_120,w_80/if_else/c_fit,h_150,w_150/e_sepia/if_end"
        
        // When
        sut.ifCondition(conditionStringInput).setCrop(.fill).setHeight(120).setWidth(80)
            .ifElse().setCrop(.fit).setHeight(150).setWidth(150)
            .chain().setEffect(.sepia).endIf()
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasSuffix("if_end"), "asString() return value should have an 'if_end' suffix")
        XCTAssertEqual(actualResult, expectedResult, "endIf() should separate the first ifCondition to a new transformation")
    }
    
    func test_endIf_callEndIfTwice_shouldReturnValidString() {
        
        // Given
        let conditionStringInput = "w_lt_200"
        
        let expectedResult = "if_w_lt_200/c_fill,h_120,w_80/if_else/c_fit,h_150/if_end/w_150/e_sepia/if_end"
        
        // When
        sut.ifCondition(conditionStringInput).setCrop(.fill).setHeight(120).setWidth(80)
            .ifElse().setCrop(.fit).setHeight(150).endIf().setWidth(150)
            .chain().setEffect(.sepia).endIf()
        
        
        let actualResult = sut.asString()!
        
        // Then
        XCTAssertFalse(actualResult.isEmpty, "asString should stored valid value")
        XCTAssertTrue(actualResult.hasSuffix("if_end"), "asString() return value should have an 'if_end' suffix")
        XCTAssertEqual(actualResult, expectedResult, "calling endIf() twice should return a valid string (although this probebly shouldn't happen)")
    }
}
