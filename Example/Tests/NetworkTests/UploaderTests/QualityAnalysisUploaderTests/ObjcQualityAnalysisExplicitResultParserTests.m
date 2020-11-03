//
//  QualityAnalysisExplicitResultParserTests.m
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

#import <XCTest/XCTest.h>
#import <Cloudinary/Cloudinary-Swift.h>
#import "Cloudinary_Tests-Swift.h"

@interface ObjcQualityAnalysisExplicitResultParserTests : XCTestCase
@property (nonatomic, strong, nullable) CLDExplicitResult* sut;
@end

@implementation ObjcQualityAnalysisExplicitResultParserTests

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
    self.sut = [MockProviderQualityAnalysis explicitResult];
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

// MARK: - explicit result
- (void)test_explicitResult_qualityAnalysisParsing_ShouldParseAsExpected {

    // Given
    NSNumber* expectedBlockiness        = @1.0;
    NSNumber* expectedChromaSubsampling = @0.0;
    NSNumber* expectedResolution        = @0.58;
    NSNumber* expectedNoise             = @1.0;
    NSNumber* expectedColorScore        = @1.0;
    NSNumber* expectedJpegChroma        = @0.25;
    NSNumber* expectedDct               = @0.91;
    NSNumber* expectedJpegQuality       = @0.89;
    NSNumber* expectedFocus             = @1.0;
    NSNumber* expectedSaturation        = @1.0;
    NSNumber* expectedContrast          = @0.99;
    NSNumber* expectedExposure          = @1.0;
    NSNumber* expectedLighting          = @1.0;
    NSNumber* expectedPixelScore        = @0.9;
    
    // Then
    XCTAssertNotNil(self.sut,                 "explicit self.sut should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysisResult, "value should be equal to expected value");
    
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.blockiness,        expectedBlockiness,        "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.chromaSubsampling, expectedChromaSubsampling, "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.resolution,        expectedResolution,        "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.noise,             expectedNoise,             "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.colorScore,        expectedColorScore,        "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.jpegChroma,        expectedJpegChroma,        "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.dct,               expectedDct,               "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.jpegQuality,       expectedJpegQuality,       "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.focus,             expectedFocus,             "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.saturation,        expectedSaturation,        "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.contrast,          expectedContrast,          "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.exposure,          expectedExposure,          "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.lighting,          expectedLighting,          "value should be equal to expected value");
    XCTAssertEqualObjects(self.sut.qualityAnalysisResult.pixelScore,        expectedPixelScore,        "value should be equal to expected value");
}

@end
