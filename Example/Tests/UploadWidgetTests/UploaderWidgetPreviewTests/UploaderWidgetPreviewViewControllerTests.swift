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
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didFinishEditing assets: [CLDWidgetAssetContainer]) {}
    func widgetPreviewViewController(_ controller: CLDWidgetPreviewViewController, didSelect asset: CLDWidgetAssetContainer) {}
    func widgetPreviewViewControllerDidCancel(_ controller: CLDWidgetPreviewViewController) {}
    
    // MARK: - test init
    func test_init_emptyArray_shouldCreateObject() {
        
        // Given
        let assets: [CLDWidgetAssetContainer] = []
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assets)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_emptyDelegate_shouldCreateObject() {
        
        // Given
        let assets = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assets, delegate: nil)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
    }
    func test_init_mixAssetsAndDelegate_shouldCreateObjectWithProperties() {
        
        // Given
        let assetContainers = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.assets, assetContainers, "objects should be equal")
        XCTAssertEqual (sut.selectedIndex, 0, "selectedIndex should be created with default value of 0")
    }
    func test_init_imageAssetsAndDelegate_shouldCreateObjectWithProperties() {
        
        // Given
        let assetContainers = createImageOnlyAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.assets, assetContainers, "objects should be equal")
        XCTAssertEqual (sut.selectedIndex, 0, "selectedIndex should be created with default value of 0")
    }
    func test_init_videoAssetsAndDelegate_shouldCreateObjectWithProperties() {
        
        // Given
        let assetContainers = createVideoOnlyAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
        XCTAssertEqual (sut.assets, assetContainers, "objects should be equal")
        XCTAssertEqual (sut.selectedIndex, 0, "selectedIndex should be created with default value of 0")
    }
    func test_init_delegateAfterInit_shouldCreateObjectWithDelegate() {
        
        // Given
        let assetContainers = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: nil)
        sut.delegate = self
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "delegate should be initialized")
    }
    func test_createView_shouldCreateObjectWithUIElements() {
        
        // Given
        let assetContainers = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        let _ = sut.view
           
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.collectionView, "object should be initialized")
        XCTAssertNotNil(sut.mainImageView, "object should be initialized")
        XCTAssertNotNil(sut.videoView, "object should be initialized")
        XCTAssertNotNil(sut.uploadButton, "object should be initialized")
    }
    func test_initWithAssetsAndCreateView_shouldCreateCollectionWithSpecificCellCount() {
        
        // Given
        let assetContainers = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.collectionView.numberOfItems(inSection: 0),assetContainers.count, "objects should be equal")
    }
    func test_initWithMixAssetsAndCreateView_shouldCreateImageViewWithSpecificImage() {
        
        // Given
        let assetContainers = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.mainImageView.image, assetContainers[0].presentationImage, "objects should be equal")
    }
    func test_initWithImageAssetsAndCreateView_shouldCreateImageViewWithSpecificImage() {
        
        // Given
        let assetContainers = createImageOnlyAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.mainImageView.image, assetContainers[0].presentationImage, "objects should be equal")
    }
    func test_initWithVideoAssetsAndCreateView_shouldCreateImageViewWithSpecificImage() {
        
        // Given
        let assetContainers = createVideoOnlyAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.videoView.player.currentItem, assetContainers[0].originalVideo, "objects should be equal")
    }
    func test_initWithAssetsAndCreateView_shouldCreateUploadButtonWithSpecificType() {
        
        // Given
        let assetContainers = createMixAssetContainers()
        
        // When
        sut = CLDWidgetPreviewViewController(assets: assetContainers, delegate: self)
        let _ = sut.view
        
        // Then
        XCTAssertNotNil(sut, "object should be initialized")
        XCTAssertNotNil(sut.delegate, "object should be initialized")
        XCTAssertEqual (sut.uploadButton.buttonType, .custom, "objects should be equal")
    }
}
