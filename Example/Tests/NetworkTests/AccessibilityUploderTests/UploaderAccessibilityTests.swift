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
        
        XCTAssertEqual(cloudinary!.config.apiKey, "createError", "swift createError apiKey \(String(describing: cloudinary!.config.apiKey))");
        XCTAssertEqual(cloudinary!.config.apiSecret, "createError", "swift createError apiSecret \(String(describing: cloudinary!.config.apiSecret))");
        XCTAssertEqual(cloudinary!.config.cloudName, "createError", "swift createError cloudName \(String(describing: cloudinary!.config.cloudName))");
        
        if let directEnvConfig = CLDConfiguration.initWithEnvParams() {
            
            XCTAssertEqual(directEnvConfig.apiKey, "createError", "swift directEnvConfig createError apiKey \(String(describing: directEnvConfig.apiKey))");
            XCTAssertEqual(directEnvConfig.apiSecret, "createError", "swift directEnvConfig createError apiSecret \(String(describing: directEnvConfig.apiSecret))");
            XCTAssertEqual(directEnvConfig.cloudName, "createError", "swift directEnvConfig createError cloudName \(String(describing: directEnvConfig.cloudName))");
        }
        else {
            
            XCTFail("cant get env params!!")
            
            let dict = ProcessInfo.processInfo.environment
            if let url = dict["CLOUDINARY_URL"],
                let configFromProcessInfo = CLDConfiguration(cloudinaryUrl: url) {
                XCTAssertEqual(configFromProcessInfo.apiKey, "createError", "swift configFromProcessInfo createError apiKey \(String(describing: configFromProcessInfo.apiKey))");
                XCTAssertEqual(configFromProcessInfo.apiSecret, "createError", "swift configFromProcessInfo createError apiSecret \(String(describing: configFromProcessInfo.apiSecret))");
                XCTAssertEqual(configFromProcessInfo.cloudName, "createError", "swift configFromProcessInfo createError cloudName \(String(describing: configFromProcessInfo.cloudName))");
            }
        }
        
        
        if let url = Bundle(for: type(of: self)).infoDictionary?["cldCloudinaryUrl"] as? String, url.count > 0 {
            let directUrlConfig = CLDConfiguration(cloudinaryUrl: url)!
            XCTAssertEqual(directUrlConfig.apiKey, "createError", "swift directUrlConfig createError apiKey \(String(describing: directUrlConfig.apiKey))");
            XCTAssertEqual(directUrlConfig.apiSecret, "createError", "swift directUrlConfig createError apiSecret \(String(describing: directUrlConfig.apiSecret))");
            XCTAssertEqual(directUrlConfig.cloudName, "createError", "swift directUrlConfig createError cloudName \(String(describing: directUrlConfig.cloudName))");
        }
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
