//
//  CLDTransformationVariablesTests.swift
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

class CLDTransformationVariablesTests: BaseTestCase {
     
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
    
    // MARK: - test invalid variable using get param
    func test_setVariable_emptyInputParamaters_shouldNotStoreNewVariable() {
        
        // Given
        let variableName  = String()
        let variableValue = String()
        
        // When
        sut.setVariable(variableName, string: variableValue)
        
        let actualResult = sut.getParam(variableName)
        
        // Then
        XCTAssertNil(actualResult, "Empty CLDVariable should not be stored in params")
    }
    func test_setVariable_emptyValueParamater_shouldNotStoreNewVariable() {
        
        // Given
        let variableName  = "$foo"
        let variableValue = String()
        
        // When
        sut.setVariable(variableName, string: variableValue)
        
        let actualResult = sut.getParam(variableName)
        
        // Then
        XCTAssertNil(actualResult, "Empty CLDVariable should not be stored in params")
    }
    
    // MARK: - test set variable using get param
    func test_setVariable_validParamaters_shouldStoreNewVariable() {
        
        // Given
        let variableName   = "$foo"
        let variableValue  = Float(30.3)
        let expectedResult = "30.3"
        
        // When
        sut.setVariable(variableName, float: variableValue)
        
        let actualResult = sut.getParam(variableName)
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling getParam on an CLDTransformation with a valid CLDVariable name as param, should return its value")
    }
    func test_setVariable_stringParamaters_shouldStoreNewVariable() {
        
        // Given
        let variableName   = "$foo"
        let variableValue  = "bar"
        let expectedResult = "bar"
        
        // When
        sut.setVariable(variableName, string: variableValue)
        
        let actualResult = sut.getParam(variableName)
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling getParam on an CLDTransformation with a valid CLDVariable name as param, should return its value")
    }
    func test_setVariable_validVariableObject_shouldStoreNewVariable() {
        
        // Given
        let variableName   = "$foo"
        let variableValue  = "bar"
        let variable       = CLDVariable(name: variableName, value: variableValue)
        let expectedResult = "bar"
        
        // When
        sut.setVariable(variable)
        
        let actualResult = sut.getParam(variableName)
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling getParam on an CLDTransformation with a valid CLDVariable name as param, should return its value")
    }
    func test_setVariable_twoValidVariableObjectsOneLine_shouldStoreNewVariable() {
        
        // Given
        let variableName1   = "$foo"
        let variableValue1  = "bar"
        let variableName2   = "$nurf"
        let variableValue2  = "baz"
        let variable1       = CLDVariable(name: variableName1, value: variableValue1)
        let variable2       = CLDVariable(name: variableName2, value: variableValue2)
        let expectedResult1 = "bar"
        let expectedResult2 = "baz"
        
        
        // When
        sut.setVariable(variable1).setVariable(variable2)
        
        let actualResult1 = sut.getParam(variableName1)
        let actualResult2 = sut.getParam(variableName2)
        
        // Then
        XCTAssertEqual(actualResult1, expectedResult1, "Calling getParam on an CLDTransformation with a valid CLDVariable name as param, should return its value")
        XCTAssertEqual(actualResult2, expectedResult2, "Calling getParam on an CLDTransformation with a valid CLDVariable name as param, should return its value")
    }
    func test_setVariables_validVariablesArray_shouldStoreNewVariable() {
        
        // Given
        let variableName   = "$foo"
        let variableValue  = "bar"
        let variable       = CLDVariable(name: variableName, value: variableValue)
        let expectedResult = "$foo_bar"
        
        // When
        sut.setVariables([variable])
        
        let actualResult = sut.variables
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling sut.variables should return its value")
    }
    func test_setVariables_twoValidVariablesArray_shouldStoreNewVariable() {
        
        // Given
        let variableName    = "$foo"
        let variableValue   = "bar"
        let variableName2   = "$nurf"
        let variableValue2  = "baz"
        let variable        = CLDVariable(name: variableName , value: variableValue)
        let variable2       = CLDVariable(name: variableName2, value: variableValue2)
        let expectedResult  = "$foo_bar,$nurf_baz"
        
        // When
        sut.setVariables([variable, variable2])
        
        let actualResult  = sut.variables
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling sut.variables should return its value")
    }
    
    // MARK: - test asString() on empty variable
    func test_asString_variableWithEmptyInputParamaters_shouldReturnEmptyString() {
        
        // Given
        let variableName   = String()
        let variableValue  = String()
        let expectedResult = String()
        
        // When
        sut.setVariable(variableName, string: variableValue)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Empty CLDVariable should not be stored in params")
    }
    func test_asString_variablesArrayWithEmptyInputParamaters_shouldReturnEmptyString() {
        
        // Given
        let variable = CLDVariable()
        let expectedResult: String? = nil
        
        // When
        sut.setVariables([variable])
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Empty CLDVariable should not be stored in params")
    }
    
    // MARK: - test asString() on variable
    func test_asString_validVariable_shouldReturnValidString() {
        
        // Given
        let variableName   = "foo"
        let variableValue  = "bar"
        let expectedResult = "$foo_bar"
        
        // When
        sut.setVariable(variableName, string: variableValue)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString() on an CLDTransformation with a valid CLDVariable as param, should return the expected string")
    }
    
    func test_asString_validOneVariableArray_shouldReturnValidString() {
        
        // Given
        let variableName   = "foo"
        let variableValue  = "bar"
        let variable = CLDVariable(name: variableName, value: variableValue)
        let expectedResult = "$foo_bar"
        
        // When
        sut.setVariables([variable])
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString() on an CLDTransformation with a valid CLDVariable as param, should return the expected string")
    }
    
    func test_asString_validTwoVariablesArray_shouldReturnValidString() {
        
        // Given
        let variableName   = "foo"
        let variableValue  = "bar"
        let variableName2  = "foo2"
        let variableValue2 = "bar2"
        let variable       = CLDVariable(name: variableName, value: variableValue)
        let variable2      = CLDVariable(name: variableName2, value: variableValue2)
        let expectedResult = "$foo_bar,$foo2_bar2"
        
        // When
        sut.setVariables([variable, variable2])
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString() on an CLDTransformation with a valid CLDVariable as param, should return the expected string")
    }
    
    func test_asString_validTwoVariablesArray_shouldReturnValidStringOrderedByEntry() {
        
        // Given
        let variableName   = "foo"
        let variableValue  = "bar"
        let variableName2  = "nurf"
        let variableValue2 = "baz"
        let variable       = CLDVariable(name: variableName, value: variableValue)
        let variable2      = CLDVariable(name: variableName2, value: variableValue2)
        let expectedResult = "$nurf_baz,$foo_bar"
        
        // When
        sut.setVariables([variable2, variable])
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString() on an CLDTransformation with a valid CLDVariable as param, should return the expected string")
    }
    
    func test_asString_validTwoVariablesArrayAndParams_shouldReturnValidSortedString() {
        
        // Given
        let variableName   = "foo"
        let variableValue  = "bar"
        let variableName2  = "foo2"
        let variableValue2 = "bar2"
        let variable       = CLDVariable(name: variableName, value: variableValue)
        let variable2      = CLDVariable(name: variableName2, value: variableValue2)
        let expectedResult = "$foo_bar,$foo2_bar2,h_12.0,w_11.0"
        
        // When
        sut.setWidth(11.0)
        sut.setVariables([variable, variable2])
        sut.setHeight(12.0)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString() on an CLDTransformation with a valid CLDVariable as param, should return the expected string - variables first!")
    }
    
    func test_asString_validTwoVariablesArrayAndParams_shouldReturnValidSortedStringVariablesOrderedByEntry() {
        
        // Given
        let variableName1  = "foo1"
        let variableValue1 = "bar1"
        let variableName2  = "foo2"
        let variableValue2 = "bar2"
        let variableName3  = "foo3"
        let variableValue3 = "bar3"
        let variable1      = CLDVariable(name: variableName1, value: variableValue1)
        let variable2      = CLDVariable(name: variableName2, value: variableValue2)
        let variable3      = CLDVariable(name: variableName3, value: variableValue3)
        let expectedResult = "$foo3_bar3,$foo1_bar1,$foo2_bar2,h_12.0,w_11.0"
        
        // When
        sut.setVariable(variable2)
        sut.setWidth(11.0)
        sut.setVariables([variable3, variable1])
        sut.setHeight(12.0)
        
        let actualResult = sut.asString()
        
        // Then
        XCTAssertEqual(actualResult, expectedResult, "Calling asString() on an CLDTransformation with a valid CLDVariable as param, should return the expected string - variables first!")
    }
}
