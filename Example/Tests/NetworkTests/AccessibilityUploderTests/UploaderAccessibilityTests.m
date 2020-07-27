//
//  UploaderAccessibilityTests.m
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

@interface UploaderAccessibilityTests: NetworkBaseTestObjc
@end

@implementation UploaderAccessibilityTests

// MARK: - upload result
- (void)test_uploadResult_accessibiltyAnalysisUnset_shouldNotReturnAccessibilityInfo {

    XCTAssertNotNil(self.cloudinary.config.apiSecret, "Must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block CLDUploadResult* sut;
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        sut   = resultRes;
        error = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(sut, "result should not be nil");
    XCTAssertNil(sut.accessibilityAnalysis, "accessibility analysis field in upload result without setAccessibilityAnalysis(true) should be nil");
}
- (void)test_uploadResult_accessibiltyAnalysisParsing_shouldParseAsExpected {

    XCTAssertNotNil(self.cloudinary.config.apiSecret, "must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload with accessibility should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block CLDUploadResult* sut;
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    [params setAccessibilityAnalysis:YES];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        sut   = resultRes;
        error = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(sut, "result should not be nil");
    XCTAssertNotNil(sut.accessibilityAnalysis, "accessibility analysis field in upload result should not be nil");
    
    // accessability analysis
    XCTAssertNotNil(sut.accessibilityAnalysis.colorblindAccessibilityAnalysis, "accessibility analysis field in upload result should not be nil");
    XCTAssertNotNil(sut.accessibilityAnalysis.colorblindAccessibilityAnalysis.mostIndistinctPair
                    , "accessibility analysis field in upload result should not be nil");
    XCTAssertNotNil(sut.accessibilityAnalysis.colorblindAccessibilityAnalysis.mostIndistinctPair[0]
                    , "accessibility analysis field in upload result should not be nil");
}

// MARK: - explicit
- (void)test_explicitResult_accessibiltyAnalysisParsing_shouldParseAsExpected {

    XCTAssertNotNil(self.cloudinary.config.apiSecret, "must set api secret for this test");
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"upload should succeed"];
    
    TestResourceType resource = borderCollie;
    NSURL* file = [self getUrlBy:resource];
    
    __block CLDUploadResult* uploadResult;
    __block NSError* error;
    
    CLDUploadRequestParams* params = [[CLDUploadRequestParams alloc] init];
    [params setAccessibilityAnalysis:YES];
    
    // When
    [[[self.cloudinary createUploader] signedUploadWithUrl:file params:params progress:nil completionHandler:nil] response:^(CLDUploadResult* resultRes, NSError* errorRes) {

        uploadResult = resultRes;
        error = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(uploadResult, "result should not be nil");
}
- (void) callForExplicitWithAccessibility:(NSString*) publicId {
    
    if(publicId == nil) {
        return;
    }
    
    // Given
    XCTestExpectation *expectation =
           [self expectationWithDescription:@"explicit call with accessibility should succeed"];
    
    __block CLDUploadResult* sut;
    __block NSError* error;
    
    CLDExplicitRequestParams* params = [[CLDExplicitRequestParams alloc] init];
    [params setAccessibilityAnalysis:YES];
    
    // When
    [[[self.cloudinary createManagementApi] explicitPublicId:publicId stringType:@"upload" params:params completionHandler:nil] response:^(CLDExplicitResult* resultRes, NSError* errorRes) {
        
        sut   = resultRes;
        error = errorRes;

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
    
    // Then
    XCTAssertNil(error, "error should be nil");
    XCTAssertNotNil(sut, "result should not be nil");
    XCTAssertNotNil(sut.accessibilityAnalysis, "accessibility analysis field in upload result should not be nil");
    
    // accessability analysis
    XCTAssertNotNil(sut.accessibilityAnalysis.colorblindAccessibilityAnalysis, "accessibility analysis field in upload result should not be nil");
    XCTAssertNotNil(sut.accessibilityAnalysis.colorblindAccessibilityAnalysis.mostIndistinctPair
                    , "accessibility analysis field in upload result should not be nil");
    XCTAssertNotNil(sut.accessibilityAnalysis.colorblindAccessibilityAnalysis.mostIndistinctPair[0]
                    , "accessibility analysis field in upload result should not be nil");
}

@end
