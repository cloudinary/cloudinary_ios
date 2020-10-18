//
//  UploaderQualityAnalysisTests.swift
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

class UploaderQualityAnalysisTests: NetworkBaseTest {

    var sut: CLDUploadResult?
    
    // prevents redundant call to Cloudinary PAID Quality analysis service. to allow Quality analysis service testing - set to true.
    var allowQualityAnalysisCalls: Bool {
        return ProcessInfo.processInfo.arguments.contains("TEST_QUALITY_ANALYSIS")
    }
    
    // MARK: - upload
    func test_upload_qualityAnalysisFalse_uploadShouldSucceedWithoutReturningQualityAnalysis() {

        // Given
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .textImage
        let file = resource.url
        var error: NSError?

        // When
        let params = CLDUploadRequestParams()
        params.setQualityAnalysis(false)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            
            self.sut = resultRes
            error    = errorRes
            
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(sut, "result should not be nil")
        XCTAssertNil   (sut?.qualityAnalysis, "qualityAnalysis param should be nil")
    }
    func test_upload_qualityAnalysisUnset_uploadShouldSucceedWithoutReturningQualityAnalysis() {

        // Given
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .textImage
        let file = resource.url
        var error: NSError?

        // When
        let params = CLDUploadRequestParams()
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            
            self.sut = resultRes
            error    = errorRes
            
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(sut, "result should not be nil")
        XCTAssertNil   (sut?.qualityAnalysis, "qualityAnalysis param should be nil, defualt value should be false")
    }
    func test_upload_qualityAnalysis_uploadShouldReturnQualityAnalysis() throws {

        try XCTSkipUnless(allowQualityAnalysisCalls, "prevents redundant call to Cloudinary PAID Quality Analysis service. to allow Quality Analysis service testing - set to true")
        
        // Given
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .textImage
        let file = resource.url
        var error: NSError?

        // When
        let params = CLDUploadRequestParams()
        params.setQualityAnalysis(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            
            self.sut = resultRes
            error    = errorRes
            
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(sut, "result should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.blockiness, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.chromaSubsampling, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.resolution, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.noise, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.colorScore, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.jpegChroma, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.dct, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.jpegQuality, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.focus, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.saturation, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.contrast, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.exposure, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.lighting, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(sut?.qualityAnalysis?.pixelScore, "qualityAnalysis param should not be nil")
    }
    
    // MARK: - explicit
    func test_explicit_qualityAnalysis_callShouldReturnQualityAnalysis() throws {

        try XCTSkipUnless(allowQualityAnalysisCalls, "prevents redundant call to Cloudinary PAID Quality Analysis service. to allow Quality Analysis service testing - set to true")
        
        // Given
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")

        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .textImage
        let file = resource.url
        var error: NSError?

        // When
        let params = CLDUploadRequestParams()
        params.setQualityAnalysis(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            
            self.sut = resultRes
            error    = errorRes
            
            expectation.fulfill()
        })

        waitForExpectations(timeout: timeout, handler: nil)

        self.callForExplicit(publicId: sut?.publicId)
        
        // Then
        XCTAssertNil(error, "upload error should be nil")
        XCTAssertNotNil(sut, "upload result should not be nil")
    }
    
    func callForExplicit(publicId: String?) {

        guard let publicId = publicId else { return }
        
        // Given
        let expectation = self.expectation(description: "Explicit call with qualityAnalysis should succeed")
        
        var explicitSut: CLDExplicitResult?
        var error : NSError?
        
        // When
        let params = CLDExplicitRequestParams()
        params.setQualityAnalysis(true)
        cloudinary!.createManagementApi().explicit(publicId, type: "upload", params: params).response({ (resultRes, errorRes) in
            
            explicitSut = resultRes
            error       = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNil(error, "explicit error should be nil")
        XCTAssertNotNil(explicitSut, "explicit result should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.blockiness, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.chromaSubsampling, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.resolution, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.noise, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.colorScore, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.jpegChroma, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.dct, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.jpegQuality, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.focus, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.saturation, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.contrast, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.exposure, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.lighting, "qualityAnalysis param should not be nil")
        XCTAssertNotNil(explicitSut?.qualityAnalysis?.pixelScore, "qualityAnalysis param should not be nil")
    }
}
