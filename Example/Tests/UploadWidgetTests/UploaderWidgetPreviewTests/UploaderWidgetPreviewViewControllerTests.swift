//
//  UploaderWidgetPreviewViewControllerTests.swift
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

class UploaderWidgetPreviewViewControllerTests: WidgetBaseTest, CLDWidgetPreviewDelegate {
    
    var sut: CLDWidgetPreviewViewController!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - delegate
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didFinishEditing images: [CLDWidgetImageContainer]) {
        print("delegate didFinishEditing")
    }
    func widgetPreviewViewControllerDidCancel(_ controller: CLDWidgetPreviewViewController) {
        print("delegate didCancel")
    }
    
    // MARK: - test init
    func test_init_emptyArray_shouldCreateObject() {
        
        // Given
        let images: [CLDWidgetImageContainer] = []
        
        // When
        sut = CLDWidgetPreviewViewController(images: images)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_emptyDelegate_shouldCreateObject() {
        
        // Given
        let images = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: images, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_imagesAndDelegate_shouldCreateObjectWithProperties() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: imageContainers, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.images, imageContainers, "objects should be equal")
        XCTAssertEqual (sut.selectedIndex, 0, "selectedIndex should be created with default value of 0")
    }
    func test_init_delegateAfterInit_shouldCreateObjectWithDelegate() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: imageContainers, delegate: nil)
        sut.delegate = self
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
    }
    func test_createView_shouldCreateObjectWithUIElements() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: imageContainers, delegate: self)
        let _ = sut.view
           
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.collectionView, "object should be initialized")
        XCTAssertNotNil(sut.mainImageView, "object should be initialized")
        XCTAssertNotNil(sut.uploadButton, "object should be initialized")
    }
    func test_initWithImagesAndCreateView_shouldCreateCollectionWithSpecificCellCount() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: imageContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.collectionView.numberOfItems(inSection: 0),imageContainers.count, "objects should be equal")
    }
    func test_initWithImagesAndCreateView_shouldCreateImageViewWithSpecificImage() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: imageContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.mainImageView.image, imageContainers[0].editedImage, "objects should be equal")
    }
    func test_initWithImagesAndCreateView_shouldCreateUploadButtonWithSpecificType() {
        
        // Given
        let imageContainers = createImageContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(images: imageContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.uploadButton.buttonType, .custom, "objects should be equal")
    }
}
