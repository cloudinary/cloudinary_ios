//
//  UploaderWidgetViewControllerTests.swift
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

import Foundation
import XCTest
@testable import Cloudinary

class UploaderWidgetViewControllerTests: WidgetBaseTest, CLDWidgetViewControllerDelegate {
    
    var sut: CLDWidgetViewController!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - delegate
    func widgetViewController(_ controller: CLDWidgetViewController, didFinishEditing editedImages: [CLDWidgetImageContainer]) {
        print("didFinishEditing")
    }
    
    func widgetViewControllerDidCancel(_ controller: CLDWidgetViewController) {
        print("did cancel")
    }
    
    // MARK: - test init
    func test_init_emptyArray_shouldCreateObject() {
        
        // Given
        let images: [CLDWidgetImageContainer] = []
        
        // When
        sut = CLDWidgetViewController(images: images)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_emptyDelegate_shouldCreateObject() {
        
        // Given
        let images = createImageContainers()
        
        // When
        sut = CLDWidgetViewController(images: images, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_allProperties_shouldCreateObjectWithProperties() {
        
        // Given
        let imageContainers = createImageContainers()
        let configuration = CLDWidgetConfiguration(allowRotate: true, initialAspectLockState: .enabledAndOn)
        
        // When
        sut = CLDWidgetViewController(images: imageContainers, configuration: configuration, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.images, imageContainers, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
    }
    func test_init_updateAfterInit_shouldCreateObjectWithDelegate() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetViewController(images: imageContainers, delegate: nil)
        sut.delegate = self
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
    }
    func test_createView_shouldCreateObjectWithUIElements() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetViewController(images: imageContainers, delegate: self)
        let _ = sut.view
           
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.topButtonsView, "object should be initialized")
        XCTAssertNotNil(sut.backButton, "object should be initialized")
        XCTAssertNotNil(sut.actionButton, "object should be initialized")
        XCTAssertNotNil(sut.containerView, "object should be initialized")
    }
    func test_initAndCreateView_shouldCreateTopButtonsWithSpecificType() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetViewController(images: imageContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.backButton.buttonType, .custom, "objects should be equal")
        XCTAssertEqual (sut.actionButton.buttonType, .custom, "objects should be equal")
    }
    func test_init_shouldCreatePreviewViewController() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetViewController(images: imageContainers, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.previewViewController, "object should be initialized")
    }
} 
