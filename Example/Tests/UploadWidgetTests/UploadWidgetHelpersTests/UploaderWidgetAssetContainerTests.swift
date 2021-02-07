//
//  UploaderWidgetAssetContainerTests.swift
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
import AVKit

class UploaderWidgetAssetContainerTests: NetworkBaseTest {
    
    var sut: CLDWidgetAssetContainer!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - test init
    func test_init_image_shouldStoreInputValues() {
        
        // Given
        let image = UIImage()
    
        // When
        sut = CLDWidgetAssetContainer(originalImage: image, editedImage: image)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.originalImage, "object's properties should store value from init call")
        XCTAssertNotNil(sut.editedImage, "object's properties should store value from init call")
        XCTAssertEqual (sut.originalImage, image, "object's properties should store value from init call")
        XCTAssertEqual (sut.editedImage, image, "object's properties should store value from init call")
        XCTAssertNil   (sut.originalVideo, "video should be nil")
        XCTAssertNotNil(sut.presentationImage, "presentationImage should be created in the object's init")
        XCTAssertEqual (sut.assetType, .image ,"assetType should be created in the object's init")
    }
    func test_init_localImages_shouldStoreInputValues() {
        
        // Given
        let originalImage = getImage(.borderCollie)
        let editedImage   = getImage(.logo)
    
        // When
        sut = CLDWidgetAssetContainer(originalImage: originalImage, editedImage: editedImage)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.originalImage, "object's properties should store value from init call")
        XCTAssertNotNil(sut.editedImage, "object's properties should store value from init call")
        XCTAssertEqual (sut.originalImage, originalImage, "object's properties should store value from init call")
        XCTAssertEqual (sut.editedImage, editedImage, "object's properties should store value from init call")
        XCTAssertNil   (sut.originalVideo, "video should be nil")
        XCTAssertNotNil(sut.presentationImage, "presentationImage should be created in the object's init")
        XCTAssertEqual (sut.assetType, .image ,"assetType should be created in the object's init")
    }
    func test_init_localVideoUrl_shouldStoreInputValues() {
        
        // Given
        let videoUrl = TestResourceType.dog.url
        
        // When
        sut = CLDWidgetAssetContainer(videoUrl: videoUrl)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNil   (sut.originalImage, "image should be nil")
        XCTAssertNil   (sut.editedImage, "image should be nil")
        XCTAssertNotNil(sut.originalVideo, "object's properties should store value from init call")
        XCTAssertNotNil(sut.presentationImage, "presentationImage should be created in the object's init")
        XCTAssertEqual (sut.assetType, .video ,"assetType should be created in the object's init")
    }
    func test_init_localVideoItem_shouldStoreInputValues() {
        
        // Given
        let videoItem = getVideo(.dog)
        
        // When
        sut = CLDWidgetAssetContainer(videoItem: videoItem)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNil   (sut.originalImage, "image should be nil")
        XCTAssertNil   (sut.editedImage, "image should be nil")
        XCTAssertNotNil(sut.originalVideo, "object's properties should store value from init call")
        XCTAssertEqual (sut.originalVideo, videoItem, "object's properties should store value from init call")
        XCTAssertNotNil(sut.presentationImage, "presentationImage should be created in the object's init")
        XCTAssertEqual (sut.assetType, .video ,"assetType should be created in the object's init")
    }
    
    // MARK: - test input
    func test_updateValues_localImages_shouldUpdateInputValues() {
        
        // Given
        let initialImage = getImage(.borderCollie)
        let newImage     = getImage(.logo)
    
        // When
        sut             = CLDWidgetAssetContainer(originalImage: initialImage, editedImage: initialImage)
        sut.editedImage = newImage
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.originalImage, initialImage, "object's properties should store value from init call")
        XCTAssertEqual (sut.editedImage, newImage, "object's properties should update its value")
    }
    
    func test_thumbnailCreation_localVideo_shouldCreateExpectedThumbnail() {
        
        // Given
        let videoItem = getVideo(.dog)
        let knownSize = CGSize.init(width: 854, height: 480)
    
        // When
        sut = CLDWidgetAssetContainer(videoItem: videoItem)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertEqual (sut.presentationImage.size, knownSize, "object's properties should store value from init call")
    }
}
