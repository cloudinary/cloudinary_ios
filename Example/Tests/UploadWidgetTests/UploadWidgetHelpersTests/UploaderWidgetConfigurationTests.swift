//
//  UploaderWidgetConfigurationTests.swift
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

@testable import Cloudinary
import Foundation
import XCTest

class UploaderWidgetConfigurationTests: XCTestCase {
    
    var sut: CLDWidgetConfiguration!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - test initilization methods
    func test_init_emptyInputParamaters_shouldStoreDefaultValues() {
        
        // When
        sut = CLDWidgetConfiguration()
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertTrue  (sut.allowRotate, "allowRotate default value should be true")
        XCTAssertEqual (sut.initialAspectLockState, CLDWidgetConfiguration.AspectRatioLockState.enabledAndOff, "initialAspectLockState default value should be enabledAndOff")
        XCTAssertTrue  (sut.uploadType.signed, "uploadType.signed default value should be true")
        XCTAssertNil   (sut.uploadType.preset, "uploadType.preset default value should be nil")
    }
    func test_init_falseInputParamaters_shouldStoreInputValues() {
        
        // Given
        let allowRotate = false
        let initialAspectLockState = CLDWidgetConfiguration.AspectRatioLockState.disabled
        let uploadType: CLDUploadType = CLDUploadType(signed: false, preset: "preset")
    
        // When
        sut = CLDWidgetConfiguration.init(allowRotate: allowRotate, initialAspectLockState: initialAspectLockState, uploadType: uploadType)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertFalse (sut.allowRotate, "object's properties should store value from init call")
        XCTAssertEqual (sut.initialAspectLockState, initialAspectLockState, "object's properties should store value from init call")
        XCTAssertEqual (sut.uploadType, uploadType, "object's properties should store value from init call")
    }
    func test_init_mixInputParamaters_shouldStoreInputValues() {
        
        // Given
        let allowRotate            = true
        let initialAspectLockState = CLDWidgetConfiguration.AspectRatioLockState.enabledAndOn
        let uploadType      = CLDUploadType(signed: true, preset: nil)
        
        // When
        sut = CLDWidgetConfiguration(allowRotate: allowRotate, initialAspectLockState: initialAspectLockState, uploadType: uploadType)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertTrue  (sut.allowRotate, "object's properties should store value from init call")
        XCTAssertEqual (sut.initialAspectLockState, initialAspectLockState, "object's properties should store value from init call")
        XCTAssertEqual (sut.uploadType, uploadType, "object's properties should store value from init call")
    }
}
