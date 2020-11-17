//
//  PreprocessTests.swift
//  CloudinaryTests
//
//  Created by Nitzan Jaitman on 04/01/2018.
//  Copyright © 2018 Cloudinary. All rights reserved.
//

import XCTest
import UIKit
@testable import Cloudinary

class PreprocessTests: BaseTestCase {
    
    var sut: UIImage!
    
    // MARK: - setup and tearDown
    override func setUp() {
        super.setUp()
    }
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - get image
    fileprivate func getImage()->UIImage {
        let bundle = Bundle(for: PreprocessTests.self)
        let url = bundle.url(forResource: "borderCollie", withExtension: "jpg")!
        
        return CLDPreprocessHelpers.resizeImage(image: UIImage(contentsOfFile: url.path)!, requiredSize: CGSize(width: 300, height:300))
    }
    
    fileprivate func getFullSizeImage(_ resourceType: NetworkBaseTest.TestResourceType = .borderCollie) -> UIImage {
        let bundle = Bundle(for: PreprocessTests.self)
        let url = bundle.url(forResource: resourceType.fileName, withExtension: resourceType.resourceExtension)!
        
        return UIImage(contentsOfFile: url.path)!
    }
    
    // MARK: - limit
    func testLimit() {
        let image = getImage()
        
        var modified = try! CLDPreprocessHelpers.limit(width: 5000, height: 5000)(image)
        XCTAssertEqual(image.size, modified.size)
        
        modified = try! CLDPreprocessHelpers.limit(width: 5000, height: 10)(image)
        XCTAssertEqual(modified.size, CGSize(width: 10, height:10))
        
        modified = try! CLDPreprocessHelpers.limit(width: 10, height: 5000)(image)
        XCTAssertEqual(modified.size, CGSize(width: 10, height:10))
        
        modified = try! CLDPreprocessHelpers.limit(width: 200, height: 300)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 300, height: 200)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 400, height: 200)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 200, height: 400)(image)
        XCTAssertEqual(modified.size, CGSize(width: 200, height:200))
        
        modified = try! CLDPreprocessHelpers.limit(width: 500, height: 300)(image)
        XCTAssertEqual(modified.size, CGSize(width: 300, height:300))
        
        modified = try! CLDPreprocessHelpers.limit(width: 300, height: 500)(image)
        XCTAssertEqual(modified.size, CGSize(width: 300, height:300))
    }
    
    // MARK: - crop
    func test_crop_small_shouldCropToSize() {
        
        // Given
        let image = getFullSizeImage()
        let imageNewRect = CGRect(x: 0, y: 0, width: 5, height: 5)
        
        // When
        sut = try! CLDPreprocessHelpers.crop(cropRect: imageNewRect)(image)
        
        // Then
        XCTAssertEqual(sut.size ,imageNewRect.size, "image should be cropped to the requested size")
    }
    func test_crop_big_shouldCropToSize()   {
        
        // Given
        let image = getFullSizeImage()
        let imageNewRect = CGRect(x: 0, y: 0, width: 900, height: 900)
        
        // When
        sut = try! CLDPreprocessHelpers.crop(cropRect: imageNewRect)(image)
        
        // Then
        XCTAssertEqual(sut.size, imageNewRect.size, "image should be cropped to the requested size")
    }
    func test_crop_widthOutOfBounds_shouldCropToSize()  {
        
        // Given
        let image = getFullSizeImage()
        let imageNewRect = CGRect(x: 0, y: 0, width: 1900, height: 40) // borderCollie image size 960 * 960
        
        // Then
        XCTAssertThrowsError(try CLDPreprocessHelpers.crop(cropRect: imageNewRect)(image), "trying to crop an image out of bounds should throw an error")
    }
    func test_crop_heightOutOfBounds_shouldCropToSize() {
        
        // Given
        let image = getFullSizeImage()
        let imageNewRect = CGRect(x: 0, y: 0, width: 40, height: 1900) // borderCollie image size 960 * 960
        
        // Then
        XCTAssertThrowsError(try CLDPreprocessHelpers.crop(cropRect: imageNewRect)(image), "trying to crop an image out of bounds should throw an error")
    }
    func test_crop_XOutOfBounds_shouldCropToSize() {
        
        // Given
        let image = getFullSizeImage()
        let imageNewRect = CGRect(x: 950, y: 0, width: 40, height: 40) // borderCollie image size 960 * 960
        
        // Then
        XCTAssertThrowsError(try CLDPreprocessHelpers.crop(cropRect: imageNewRect)(image), "trying to crop an image out of bounds should throw an error")
    }
    func test_crop_YOutOfBounds_shouldCropToSize() {
        
        // Given
        let image = getFullSizeImage()
        let imageNewRect = CGRect(x: 0, y: 950, width: 40, height: 40) // borderCollie image size 960 * 960
        
        // Then
        XCTAssertThrowsError(try CLDPreprocessHelpers.crop(cropRect: imageNewRect)(image), "trying to crop an image out of bounds should throw an error")
    }
    
    // MARK: - rotate
    func test_rotate_45_shouldRotateToAngle() {
        
        // Given
        let image = getFullSizeImage()
        let imageExpectedSize = CGSize(width: 1357, height: 1357)
        
        // When
        sut = try! CLDPreprocessHelpers.rotate(degrees: 45)(image)
        
        // Then
        XCTAssertEqual(sut.size ,imageExpectedSize, "image should be rotated to the requested angle (this should change the image size)")
    }
    func test_rotate_90_shouldRotateToAngle() {
        
        // Given
        let image = getFullSizeImage(.logo)
        let imageExpectedSize = CGSize(width: image.size.height, height: image.size.width)
        
        // When
        sut = try! CLDPreprocessHelpers.rotate(degrees: 90)(image)
        
        // Then
        XCTAssertEqual(sut.size ,imageExpectedSize, "image should be rotated to the requested angle (this should change the image size)")
    }
    func test_rotate_180_shouldRotateToAngle() {
        
        // Given
        let image = getFullSizeImage()
        let imageExpectedSize = image.size
        
        // When
        sut = try! CLDPreprocessHelpers.rotate(degrees: 180)(image)
        
        // Then
        XCTAssertEqual(sut.size ,imageExpectedSize, "image should be rotated to the requested angle (this should change the image size)")
    }
    func test_rotate_810_shouldRotateToAngle() {
        
        // Given
        let image = getFullSizeImage()
        let imageExpectedSize = CGSize(width: image.size.height, height: image.size.width)
        
        // When
        sut = try! CLDPreprocessHelpers.rotate(degrees: 810)(image)
        
        // Then
        XCTAssertEqual(sut.size ,imageExpectedSize, "image should be rotated to the requested angle (this should change the image size)")
    }
    func test_rotate_45png_shouldRotateToAngle()   {
        
        // Given
        let image = getFullSizeImage(.logo)
        let imageExpectedSize = CGSize(width: 206, height: 206)
        
        // When
        sut = try! CLDPreprocessHelpers.rotate(degrees: 45)(image)
        
        // Then
        XCTAssertEqual(sut.size ,imageExpectedSize, "image should be rotated to the requested angle (this should change the image size)")
    }
    func test_rotate_CIImage_shouldRotateToAngle() {
        
        // Given
        let ciimage = CIImage(image: getFullSizeImage(.logo))!
        let uiimageFromCIImage = UIImage(ciImage: ciimage)
        
        let imageExpectedSize = CGSize(width: 206, height: 206)
        
        // When
        sut = try! CLDPreprocessHelpers.rotate(degrees: 45)(uiimageFromCIImage)
        
        // Then
        XCTAssertNil(uiimageFromCIImage.cgImage, "image.cgImage should be nil")
        XCTAssertEqual(sut.size ,imageExpectedSize, "image should be rotated to the requested angle (this should change the image size)")
    }
//    func test_rotate_shouldEqualPrePreparedImage() {
//
//        // Given
//        let image = getFullSizeImage()
//        let prePreparedImage = getFullSizeImage(.borderCollieRotatedPng)
//
//        // When
//        sut = try! CLDPreprocessHelpers.rotate(degrees: 45)(image)
//
//        // Then
//        XCTAssertEqual(sut.pngData(), prePreparedImage.pngData(), "rotated image should be equal to pre prepared image")
//    }
    
    // MARK: - dimension validator
    func testDimensionValidator() {
        let image = getImage()
        
        var modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 300, minHeight: 300, maxHeight: 300)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 3000, minHeight: 300, maxHeight: 3000)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 10, maxWidth: 3000, minHeight: 10, maxHeight: 3000)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 10, maxWidth: 300, minHeight: 10, maxHeight: 300)(image)
        XCTAssertNotNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 400, maxWidth: 3000, minHeight: 30, maxHeight: 3000)(image)
        XCTAssertNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 300, minHeight: 400, maxHeight: 3000)(image)
        XCTAssertNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 300, maxWidth: 300, minHeight: 100, maxHeight: 200)(image)
        XCTAssertNil(modified)
        
        modified = try? CLDPreprocessHelpers.dimensionsValidator(minWidth: 100, maxWidth: 200, minHeight: 300, maxHeight: 300)(image)
        XCTAssertNil(modified)
    }
}
