//
//  QualityAnalysisUploadResultParserTests.swift
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

// QualityAnalysisUploadResultParserTests created to reduce server calls to Cloudinary PAID Quality analysis service
class QualityAnalysisUploadResultParserTests: NetworkBaseTest {

    var sut : CLDUploadResult!
    
    // MARK: - setup and teardown
    override func setUp() {
        super.setUp()
        sut = MockProviderQualityAnalysis.uploadResult
    }
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: - upload result
    func test_uploadResult_qualityAnalysisParsing_ShouldParseAsExpected() {

        // Given
        let expectedBlockiness        = NSNumber(value: 1.0)
        let expectedChromaSubsampling = NSNumber(value: 0.0)
        let expectedResolution        = NSNumber(value: 0.58)
        let expectedNoise             = NSNumber(value: 1.0)
        let expectedColorScore        = NSNumber(value: 1.0)
        let expectedJpegChroma        = NSNumber(value: 0.25)
        let expectedDct               = NSNumber(value: 0.91)
        let expectedJpegQuality       = NSNumber(value: 0.89)
        let expectedFocus             = NSNumber(value: 1.0)
        let expectedSaturation        = NSNumber(value: 1.0)
        let expectedContrast          = NSNumber(value: 0.99)
        let expectedExposure          = NSNumber(value: 1.0)
        let expectedLighting          = NSNumber(value: 1.0)
        let expectedPixelScore        = NSNumber(value: 0.9)
        
        
        // Then
        XCTAssertNotNil(sut,                 "upload sut should not be nil")
        XCTAssertNotNil(sut.qualityAnalysisResult, "value should be equal to expected value")
        
        XCTAssertEqual(sut.qualityAnalysisResult?.blockiness,        expectedBlockiness,        "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.chromaSubsampling, expectedChromaSubsampling, "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.resolution,        expectedResolution,        "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.noise,             expectedNoise,             "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.colorScore,        expectedColorScore,        "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.jpegChroma,        expectedJpegChroma,        "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.dct,               expectedDct,               "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.jpegQuality,       expectedJpegQuality,       "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.focus,             expectedFocus,             "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.saturation,        expectedSaturation,        "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.contrast,          expectedContrast,          "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.exposure,          expectedExposure,          "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.lighting,          expectedLighting,          "value should be equal to expected value")
        XCTAssertEqual(sut.qualityAnalysisResult?.pixelScore,        expectedPixelScore,        "value should be equal to expected value")
    }
}
