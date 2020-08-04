//
//  UploadRequestParamsTests.swift
//
//  Copyright (c) 2020 Cloudinary (http://cloudinary.com)
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

class UploadRequestParamsTests: BaseTestCase {
    
    var sut : CLDUploadRequestParams!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
        sut = CLDUploadRequestParams()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - accessibility analysis
    func test_getAccessibilityAnalysis_unset_shouldNotStoreValue() {
                
        // Then
        XCTAssertTrue(sut.accessibilityAnalysis == nil, "unset property should not be stored in params")
    }
    func test_setAccessibilityAnalysis_true_shouldStoreTrueValue() {

        // When
        sut.setAccessibilityAnalysis(true)
        
        // Then
        XCTAssertTrue(sut.accessibilityAnalysis == true, "setting property to true should store true in params")
    }
    func test_setAccessibilityAnalysis_trueThenFalse_shouldUpdateValue() {

        // When
        sut.setAccessibilityAnalysis(true)
        sut.setAccessibilityAnalysis(false)

        // Then
        XCTAssertTrue(sut.accessibilityAnalysis == false, "updating property to false value should store false in params")
    }
    
    // MARK: - ocr
    func test_getOcr_unset_shouldStoreValue() {
        
        XCTAssertFalse(sut.ocr, "set proerty should be stored in params")
    }
    func test_setOcr_true_shouldStoreValue() {

        // When
        sut.setOcr(true)
        
        // Then
        XCTAssertTrue(sut.ocr, "set proerty should be stored in params")
    }
    func test_setOcr_trueThenfalse_shouldRemoveValue() {

        // When
        sut.setOcr(true)
        sut.setOcr(false)

        // Then
        XCTAssertFalse(sut.ocr, "Init without longUrlSignature should store the default false value")
    }
}
