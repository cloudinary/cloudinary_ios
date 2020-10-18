//
//  ObjcUploaderQualityAnalysisTests.m
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
#import "NetworkBaseTestObjc.h"

@interface ObjcUploaderQualityAnalysisTests: NetworkBaseTestObjc
@property (nonatomic, strong, nullable) __block CLDUploadResult* sut;
@end

@implementation ObjcUploaderQualityAnalysisTests

// prevents redundant call to Cloudinary PAID Quality analysis service. to allow Quality analysis service testing - set to true.
-(BOOL)allowQualityAnalysisCalls {
    return [[[NSProcessInfo processInfo] arguments] containsObject:@"TEST_QUALITY_ANALYSIS"];
}

// MARK: - upload result
- (void)test_upload_qualityAnalysisFalse_uploadShouldSucceedWithoutReturningQualityAnalysis {

    XCTAssertNotNil(self.cloudinary.config.apiSecret, "Must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    [params setQualityAnalysis:NO];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        self.sut = resultRes;
        error    = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(self.sut, "result should not be nil");
    XCTAssertNil   (self.sut.qualityAnalysis, "quality analysis should be nil");
}
- (void)test_upload_qualityAnalysisUnset_uploadShouldSucceedWithoutReturningQualityAnalysis {

    XCTAssertNotNil(self.cloudinary.config.apiSecret, "Must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        self.sut = resultRes;
        error    = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(self.sut, "result should not be nil");
    XCTAssertNil   (self.sut.qualityAnalysis, "quality analysis should be nil, defualt value should be false");
}
- (void)test_upload_qualityAnalysis_uploadShouldReturnQualityAnalysis {

    XCTSkipUnless([self allowQualityAnalysisCalls], "prevents redundant call to Cloudinary PAID Quality Analysis service. to allow Quality Analysis service testing - set to true");
    
    XCTAssertNotNil(self.cloudinary.config.apiSecret, "must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload with quality should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    [params setQualityAnalysis:YES];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        self.sut = resultRes;
        error    = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(self.sut, "result should not be nil");
    
    XCTAssertNotNil(self.sut.qualityAnalysis, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.blockiness, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.chromaSubsampling, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.resolution, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.noise, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.colorScore, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.jpegChroma, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.dct, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.jpegQuality, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.focus, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.saturation, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.contrast, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.exposure, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.lighting, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(self.sut.qualityAnalysis.pixelScore, "qualityAnalysis param should not be nil");
}

// MARK: - explicit
- (void)test_explicit_qualityAnalysis_callShouldReturnQualityAnalysis {

    XCTSkipUnless([self allowQualityAnalysisCalls], "prevents redundant call to Cloudinary PAID Quality Analysis service. to allow Quality Analysis service testing - set to true");
    
    XCTAssertNotNil(self.cloudinary.config.apiSecret, "must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block CLDUploadResult* uploadResult;
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    [params setQualityAnalysis:YES];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        uploadResult = resultRes;
        error        = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(uploadResult, "result should not be nil");
}
- (void)callForExplicitWithPublicId:(NSString*) publicId {
    
    if(publicId == nil) {
        return;
    }
    
    // Given
    XCTestExpectation *expectation =
           [self expectationWithDescription:@"explicit call with quality should succeed"];
    
    __block CLDExplicitResult* result;
    __block NSError* error;
    
    CLDExplicitRequestParams* params = [[CLDExplicitRequestParams alloc] init];
    [params setQualityAnalysis:YES];
    
    // When
    [[[self.cloudinary createManagementApi] explicitPublicId:publicId stringType:@"upload" params:params completionHandler:nil] response:^(CLDExplicitResult* resultRes, NSError* errorRes) {
        
        result = resultRes;
        error  = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(result, "result should not be nil");
    
    XCTAssertNotNil(result.qualityAnalysis, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.blockiness, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.chromaSubsampling, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.resolution, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.noise, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.colorScore, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.jpegChroma, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.dct, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.jpegQuality, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.focus, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.saturation, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.contrast, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.exposure, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.lighting, "qualityAnalysis param should not be nil");
    XCTAssertNotNil(result.qualityAnalysis.pixelScore, "qualityAnalysis param should not be nil");
}

@end
