//
//  UploaderWidgetCollectionCellTests.swift
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

class UploaderWidgetCollectionCellTests: NetworkBaseTest {
    
    var sut: CLDWidgetPreviewCollectionCell!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - test init
    func test_init_shouldCreateElements() {
        
        // Given
        let frame = CGRect(x: 0, y: 0, width: 400, height: 300)
    
        // When
        sut = CLDWidgetPreviewCollectionCell(frame: frame)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.imageView, "object's elements should be initialized")
        XCTAssertEqual (sut.frame, frame, "object's frame should be set")
    }
    func test_init_imageViewFrame_shouldSetImageViewFrame() {
        
        // Given
        let frame = CGRect(x: 0, y: 0, width: 400, height: 300)

        // When
        sut = CLDWidgetPreviewCollectionCell(frame: frame)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.imageView, "object's elements should be initialized")
        XCTAssertEqual (sut.imageView.frame, frame, "object's imageView frame should be set")
    }
    func test_init_imageViewImage_shouldSetImageViewImage() {
        
        // Given
        let image = UIImage()
        let frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        
        // When
        sut = CLDWidgetPreviewCollectionCell(frame: frame)
        sut.imageView.image = image
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.imageView, "object's elements should be initialized")
        XCTAssertEqual (sut.imageView.image, image, "object's imageView image should be set")
    }
    
    // MARK: - test update
    func test_update_imageViewImage_shouldUpdateImageViewImage() {
        
        // Given
        let initialImage = getImage(.logo)
        let updatedImage = getImage(.borderCollie)
        let frame        = CGRect(x: 0, y: 0, width: 400, height: 300)
        
        // When
        sut = CLDWidgetPreviewCollectionCell(frame: frame)
        sut.imageView.image = initialImage
        sut.imageView.image = updatedImage
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.imageView, "object's elements should be initialized")
        XCTAssertEqual (sut.imageView.image, updatedImage, "object's imageView image should update")
    }
}
