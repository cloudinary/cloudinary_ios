//
//  PreprocessUploaderTests.swift
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

import XCTest
@testable import Cloudinary

class PreprocessUploaderTests: NetworkBaseTest {

    // MARK: - crop upload
    func test_cropPreprocess_upload_croppedImageShouldBeUploaded() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "upload should succeed")
        
        let file       = TestResourceType.borderCollie.url
        
        let cropWidth  = 47
        let cropHeight = 43
        let xPoint     = 200
        let yPoint     = 100
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.crop(cropRect: CGRect(x: xPoint, y: yPoint, width: cropWidth, height: cropHeight)))
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertEqual(result?.width , cropWidth, "returned image_width should be cropped")
        XCTAssertEqual(result?.height, cropHeight, "returned image_height should be cropped")
    }
    func test_cropPreprocess_uploadWidthOutOfBounds_croppedImageUploadShouldFail() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "upload should succeed")
        
        let file       = TestResourceType.borderCollie.url
        
        let cropWidth  = 1147 // borderCollie image size 960 * 960
        let cropHeight = 43
        let xPoint     = 200
        let yPoint     = 100
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.crop(cropRect: CGRect(x: xPoint, y: yPoint, width: cropWidth, height: cropHeight)))
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(error, "error should not be nil")
        XCTAssertNil(result, "result should be nil")
    }
    func test_cropPreprocess_uploadHeightOutOfBounds_croppedImageUploadShouldFail() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "upload should succeed")
        
        let file       = TestResourceType.borderCollie.url
        
        let cropWidth  = 47
        let cropHeight = 1143 // borderCollie image size 960 * 960
        let xPoint     = 200
        let yPoint     = 100
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.crop(cropRect: CGRect(x: xPoint, y: yPoint, width: cropWidth, height: cropHeight)))
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(error, "error should not be nil")
        XCTAssertNil(result, "result should be nil")
    }
    func test_cropPreprocess_uploadXOutOfBounds_croppedImageUploadShouldFail() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "upload should succeed")
        
        let file       = TestResourceType.borderCollie.url
        
        let cropWidth  = 47
        let cropHeight = 43
        let xPoint     = -1
        let yPoint     = 100
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.crop(cropRect: CGRect(x: xPoint, y: yPoint, width: cropWidth, height: cropHeight)))
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(error, "error should not be nil")
        XCTAssertNil(result, "result should be nil")
    }
    func test_cropPreprocess_uploadYOutOfBounds_croppedImageUploadShouldFail() {
        
        XCTAssertNotNil(cloudinary!.config.apiSecret, "must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "upload should succeed")
        
        let file       = TestResourceType.borderCollie.url
        
        let cropWidth  = 47
        let cropHeight = 43
        let xPoint     = 200
        let yPoint     = -1
        
        var result: CLDUploadResult?
        var error: NSError?
        
        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.crop(cropRect: CGRect(x: xPoint, y: yPoint, width: cropWidth, height: cropHeight)))
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNotNil(error, "error should not be nil")
        XCTAssertNil(result, "result should be nil")
    }
    
    // MARK: - crop download
    func test_uploadPreprocess_cropDownloading_UploadedImageDataShouldBeEqualToCroppedImage() {

        XCTAssertNotNil(cloudinary!.config.apiSecret, "must set api secret for this test")

        // Given
        let expectation = self.expectation(description: "upload should succeed")

        let file       = TestResourceType.borderCollie.url
        
        let cropWidth  = 252
        let cropHeight = 252
        let xPoint     = 280
        let yPoint     = 180
        
        var result  : CLDUploadResult?
        var error   : NSError?
        var publicId: String?
        
        let preprocessChain = CLDImagePreprocessChain().addStep(CLDPreprocessHelpers.crop(cropRect: CGRect(x: xPoint, y: yPoint, width: cropWidth, height: cropHeight))).setEncoder(CLDPreprocessHelpers.customImageEncoder(format: .JPEG, quality: 90))
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, preprocessChain: preprocessChain).response({ (resultRes, errorRes) in
            result = resultRes
            error = errorRes
            publicId = result?.publicId

            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
        
        guard let pubId = publicId else {
            XCTFail("publicId should not be nil at this point")
            return
        }
        
        cropDownloading_uploadedImageDataShouldBeEqualToCroppedImage(publicId: pubId, testResourceType: .borderCollieCropped)
    }
    func cropDownloading_uploadedImageDataShouldBeEqualToCroppedImage(publicId: String, testResourceType: TestResourceType) {
        
        let expectation = self.expectation(description: "download should succeed")
        
        // Given
        let localCroppedImageData = UIImage(data: testResourceType.data)?.pngData()
        
        var response: UIImage?
        var error   : NSError?
        
        // When
        let url = cloudinarySecured!.createUrl().generate(publicId)
        cloudinarySecured.createDownloader().fetchImage(url!).responseImage({ (responseImage, errorRes) in
            response = responseImage
            error    = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        let downloadedImageData = response?.pngData()

        // Then
        XCTAssertNotNil(response, "response should not be nil")
        XCTAssertNil(error, "error should be nil")
        XCTAssertEqual(downloadedImageData, localCroppedImageData, "image downloaded after uploaded with crop preprocess, should be equal to expected cropped image")
    }
}
