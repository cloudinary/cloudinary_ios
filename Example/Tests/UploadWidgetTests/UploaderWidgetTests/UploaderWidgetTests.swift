//
//  UploaderWidgetTests.swift
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

class UploaderWidgetTests: WidgetBaseTest, CLDUploaderWidgetDelegate {

    var sut: CLDUploaderWidget!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - delegate
    func uploadWidget(_ widget: CLDUploaderWidget, willCall uploadRequests: [CLDUploadRequest]) {}
    func widgetDidCancel(_ widget: CLDUploaderWidget) {}
    func uploadWidgetDidDismiss() {}
    
    // MARK: - test init
    func test_init_cloudinary_shouldCreateObject() {
        
        // Given
        let cloudinaryObject = cloudinary!
        
        // When
        sut = CLDUploaderWidget(cloudinary: cloudinaryObject, configuration: nil, images: nil, videos: nil, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.cloudinaryObject, cloudinaryObject, "objects should be equal")
        
    }
    func test_init_cloudinaryConfiguration_shouldCreateObject() {
        
        // Given
        let cloudinaryObject = cloudinary!
        let configuration    = CLDWidgetConfiguration()
        
        // When
        sut = CLDUploaderWidget(cloudinary: cloudinaryObject, configuration: configuration, images: nil, videos: nil, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.cloudinaryObject, cloudinaryObject, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
    }
    func test_init_cloudinaryConfigurationImages_shouldCreateObject() {
        
        // Given
        let images           = createImages()
        let cloudinaryObject = cloudinary!
        let configuration    = CLDWidgetConfiguration()
        
        // When
        sut = CLDUploaderWidget(cloudinary: cloudinaryObject, configuration: configuration, images: images, videos: nil, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.cloudinaryObject, cloudinaryObject, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.images, images, "objects should be equal")
    }
    func test_convenienceInit_cloudinaryConfigurationImages_shouldCreateObject() {
        
        // Given
        let images           = createImages()
        let cloudinaryObject = cloudinary!
        let configuration    = CLDWidgetConfiguration()
        
        // When
        sut = CLDUploaderWidget(cloudinary: cloudinaryObject, configuration: configuration, images: images, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.cloudinaryObject, cloudinaryObject, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.images, images, "objects should be equal")
    }
    func test_init_cloudinaryConfigurationImagesVideos_shouldCreateObject() {
        
        // Given
        let images           = createImages()
        let videos           = createVideos()
        let cloudinaryObject = cloudinary!
        let configuration    = CLDWidgetConfiguration()
        
        // When
        sut = CLDUploaderWidget(cloudinary: cloudinaryObject, configuration: configuration, images: images, videos: videos, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.cloudinaryObject, cloudinaryObject, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.images, images, "objects should be equal")
        XCTAssertEqual (sut.videos, videos, "objects should be equal")
    }
    func test_init_allProperties_shouldCreateObject() {
        
        // Given
        let images           = createImages()
        let videos           = createVideos()
        let cloudinaryObject = cloudinary!
        let configuration    = CLDWidgetConfiguration()
        
        // When
        sut = CLDUploaderWidget(cloudinary: cloudinaryObject, configuration: configuration, images: images, videos: videos, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be set")
        XCTAssertEqual (sut.cloudinaryObject, cloudinaryObject, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.images, images, "objects should be equal")
        XCTAssertEqual (sut.videos, videos, "objects should be equal")
    }
    
    // MARK: - update
    func test_update_allProperties_shouldCreateObject() {
        
        // Given
        let images                  = createImages()
        let videos                  = createVideos()
        let initialCloudinaryObject = cloudinary!
        let updatedCloudinaryObject = cloudinarySecured!
        let configuration           = CLDWidgetConfiguration()
        
        // When
        sut = CLDUploaderWidget(cloudinary: initialCloudinaryObject, configuration: nil, images: nil, videos: nil, delegate: nil)
        sut.setCloudinary(updatedCloudinaryObject).setConfiguration(configuration).setImages(images).setVideos(videos).setDelegate(self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be set")
        XCTAssertEqual (sut.cloudinaryObject, updatedCloudinaryObject, "objects should be equal")
        XCTAssertEqual (sut.configuration, configuration, "objects should be equal")
        XCTAssertEqual (sut.images, images, "objects should be equal")
        XCTAssertEqual (sut.videos, videos, "objects should be equal")
    }
}
