//
//  UploaderAccessibilityTests.swift
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

class UploaderAccessibilityTests: NetworkBaseTest {

    // MARK: - upload
    func test_uploadResult_accessibiltyAnalysisUnset_shouldNotReturnAccessibilityInfo() {
       
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "Upload should succeed")
        
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var sut: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            sut   = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(sut, "result should not be nil")
        XCTAssertNil(sut?.accessibilityAnalysis, "accessibility analysis field in upload result without setAccessibilityAnalysis(true) should be nil")
    }
    func test_uploadResult_accessibiltyAnalysisParsing_shouldParseAsExpected() {
       
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        // Given
        let expectation = self.expectation(description: "Upload with accessibility should succeed")
        
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var sut: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        params.setAccessibilityAnalysis(true)
        
        // When
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            sut   = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)

        // Then
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(sut, "result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityScore, "accessibility analysis field in upload result should not be nil")
        
        // accessability analysis
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.distinctColors, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.distinctEdges, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.mostIndistinctPair
            , "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.mostIndistinctPair?[0]
        , "accessibility analysis field in upload result should not be nil")
    }
    
    // MARK: - explicit
    func test_explicitResult_accessibiltyAnalysisParsing_shouldParseAsExpected() {
       
        XCTAssertNotNil(cloudinary!.config.apiSecret, "Must set api secret for this test")
        
        let expectation = self.expectation(description: "Upload should succeed")
        let resource: TestResourceType = .borderCollie
        let file = resource.url
        var result: CLDUploadResult?
        var error: NSError?
        
        let params = CLDUploadRequestParams()
        params.setAccessibilityAnalysis(true)
        cloudinary!.createUploader().signedUpload(url: file, params: params).response({ (resultRes, errorRes) in
            result = resultRes
            error  = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)

        callForExplicitWithAccessibility(publicId: result?.publicId)
        
        XCTAssertNotNil(result, "result should not be nil")
        XCTAssertNil(error, "error should be nil")
    }
    func callForExplicitWithAccessibility(publicId: String?) {

        guard let publicId = publicId else { return }
        
        // Given
        let expectation = self.expectation(description: "Explicit call with accessibility should succeed")
        
        var sut: CLDExplicitResult?
        var error: NSError?
        
        // When
        let params = CLDExplicitRequestParams()
        params.setAccessibilityAnalysis(true)
        cloudinary!.createManagementApi().explicit(publicId, type: "upload", params: params).response({ (resultRes, errorRes) in
            sut   = resultRes
            error = errorRes
            
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: timeout, handler: nil)
        
        // Then
        XCTAssertNil(error, "error should be nil")
        XCTAssertNotNil(sut, "result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityScore, "accessibility analysis field in upload result should not be nil")
        
        // accessability analysis
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.distinctColors, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.distinctEdges, "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.mostIndistinctPair
            , "accessibility analysis field in upload result should not be nil")
        XCTAssertNotNil(sut?.accessibilityAnalysis?.colorblindAccessibilityAnalysis?.mostIndistinctPair?[0]
        , "accessibility analysis field in upload result should not be nil")
    }
}
