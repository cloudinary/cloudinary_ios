//
//  ObjcCLDConfigurationTests.m
//
//  Copyright (c) 2018 Cloudinary (http://cloudinary.com)
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
#import "ObjcBaseTestCase.h"

@interface ObjcCLDConfigurationTests : ObjcBaseTestCase
@property (nonatomic, strong, nullable) CLDConfiguration* sut;
@end

@implementation ObjcCLDConfigurationTests

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

// MARK: - timeout
- (void)test_initTimeout_setNSNumber_shouldStoreValue {
    
    // Given
    NSNumber* input = [[NSNumber alloc] initWithInt:10000];
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                          longUrlSignature:NO
                                        signatureAlgorithm:SignatureAlgorithmSha1
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil
                                                   timeout:input
                                                 analytics:NO];
    
    // Then
    XCTAssertEqualObjects(self.sut.timeout, expectedResult, "Init with timeout = number, should be stored in property");
}

- (void)test_initTimeout_nil_shouldStoreFalseValue {
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                          longUrlSignature:NO
                                        signatureAlgorithm:SignatureAlgorithmSha1
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil
                                                   timeout:nil
                                                 analytics:NO];
    
    // Then
    XCTAssertNil(self.sut.timeout, "Init with timeout = nil, should not be stored in property");
}
- (void)test_initTimeout_optionsString_shouldStoreValue {
    
    // Given
    NSString* keyCloudName   = @"cloud_name";
    NSString* inputCloudName = @"foo";
    NSString* keyTimeout     = @"timeout";
    NSString* inputTimeout   = @"10000";
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyTimeout: inputTimeout}];
    
    // Then
    XCTAssertEqualObjects(self.sut.timeout, expectedResult, "Init with timeout = number, should be stored in property");
}
- (void)test_initTimeout_optionsNSNumber_shouldStoreValue {
    
    // Given
    NSString* keyCloudName   = @"cloud_name";
    NSString* inputCloudName = @"foo";
    NSString* keyTimeout     = @"timeout";
    NSNumber* inputTimeout   = [[NSNumber alloc] initWithInt:10000];
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyTimeout: inputTimeout}];
    
    // Then
    XCTAssertEqualObjects(self.sut.timeout, expectedResult, "Init with timeout = number, should be stored in property");
}
- (void)test_initTimeout_cloudinaryUrl_shouldStoreValue {
    
    // Given
    NSString* longUrlSignatureQuery = @"?timeout=10000";
    NSString* testedUrl             = @"cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",testedUrl,longUrlSignatureQuery];
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    
    // Then
    XCTAssertEqualObjects(self.sut.timeout, expectedResult, "Init with cloudinaryUrl with valid timeout, should be stored in property");
}

// MARK: - long url signature
- (void)test_initLongUrlSignature_true_shouldStoreValue {
        
    // Given
    BOOL input = YES;
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                          longUrlSignature:input
                                        signatureAlgorithm:SignatureAlgorithmSha1
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil
                                                   timeout:nil
                                                 analytics:NO];
    
    // Then
    XCTAssertTrue(self.sut.longUrlSignature, "Init with longUrlSignature = true, should be stored in property");
}
- (void)test_initLongUrlSignature_default_shouldStoreFalseValue {

    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                          longUrlSignature:NO
                                        signatureAlgorithm:SignatureAlgorithmSha1
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil
                                                   timeout:nil
                                                 analytics:NO];
    
    // Then
    XCTAssertFalse(self.sut.longUrlSignature, "Init without longUrlSignature should store the default false value");
}
- (void)test_initLongUrlSignature_optionsString_shouldStoreValue {
        
    // Given
    NSString* keyCloudName          = @"cloud_name";
    NSString* inputCloudName        = @"foo";
    NSString* keyLongUrlSignature   = @"long_url_signature";
    NSString* inputLongUrlSignature = @"true";
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyLongUrlSignature: inputLongUrlSignature}];
    
    // Then
    XCTAssertTrue(self.sut.longUrlSignature, "Init with options with longUrlSignature = true, should be stored in property");
}
- (void)test_initLongUrlSignature_optionsBool_shouldStoreValue {
        
    // Given
    NSString* keyCloudName          = @"cloud_name";
    NSString* inputCloudName        = @"foo";
    NSString* keyLongUrlSignature   = @"long_url_signature";
    NSNumber* inputLongUrlSignature = @YES;
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyLongUrlSignature: inputLongUrlSignature}];
    
    // Then
    XCTAssertTrue(self.sut.longUrlSignature, "Init with options with longUrlSignature = true, should be stored in property");
}
- (void)test_initLongUrlSignature_cloudinaryUrl_shouldStoreValue {
        
    // Given
    NSString* longUrlSignatureQuery = @"?long_url_signature=true";
    NSString* testedUrl             = @"cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",testedUrl,longUrlSignatureQuery];
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    
    // Then
    XCTAssertTrue(self.sut.longUrlSignature, "Init with cloudinaryUrl with valid longUrlSignature = true, should be stored in property");
}

// MARK: - signature algorithm
- (void)test_initSignatureAlgorithm_setSha256_shouldStoreValue {
        
    // Given
    BOOL input = SignatureAlgorithmSha256;
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                          longUrlSignature:NO
                                        signatureAlgorithm:input
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil
                                                   timeout:nil
                                                 analytics:NO];
    
    // Then
    XCTAssertEqual(self.sut.signatureAlgorithm, SignatureAlgorithmSha256, "Init with signatureAlgorithm should store that value in property");
}
- (void)test_initSignatureAlgorithm_default_shouldStoreDefaultValue {

    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                          longUrlSignature:NO
                                        signatureAlgorithm:0
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil
                                                   timeout:nil
                                                 analytics:NO];
    
    // Then
    XCTAssertEqual(self.sut.signatureAlgorithm, SignatureAlgorithmSha1, "Init without signatureAlgorithm should store the default .sha1 value");
}
- (void)test_initSignatureAlgorithm_optionsSha256_shouldStoreValue {
        
    // Given
    NSString* keyCloudName            = @"cloud_name";
    NSString* inputCloudName          = @"foo";
    NSString* keySignatureAlgorithm   = @"signature_algorithm";
    NSString* inputSignatureAlgorithm = @"sha256";
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keySignatureAlgorithm: inputSignatureAlgorithm}];
    
    // Then
    XCTAssertEqual(self.sut.signatureAlgorithm, SignatureAlgorithmSha256, "Init with options with signatureAlgorithm should store that value");
}
- (void)test_initSignatureAlgorithm_optionsSha1_shouldStoreValue {
        
    // Given
    NSString* keyCloudName            = @"cloud_name";
    NSString* inputCloudName          = @"foo";
    NSString* keySignatureAlgorithm   = @"signature_algorithm";
    NSString* inputSignatureAlgorithm = @"sha1";
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keySignatureAlgorithm: inputSignatureAlgorithm}];
    
    // Then
    XCTAssertEqual(self.sut.signatureAlgorithm, SignatureAlgorithmSha1, "Init with options with signatureAlgorithm should store that value");
}
- (void)test_initSignatureAlgorithm_optionsInvalidString_shouldStoreValue {
        
    // Given
    NSString* keyCloudName            = @"cloud_name";
    NSString* inputCloudName          = @"foo";
    NSString* keySignatureAlgorithm   = @"signature_algorithm";
    NSString* inputSignatureAlgorithm = @"notSha";
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keySignatureAlgorithm: inputSignatureAlgorithm}];
    
    // Then
    XCTAssertEqual(self.sut.signatureAlgorithm, SignatureAlgorithmSha1, "Init with options with invalid signatureAlgorithm should store the defualt .sha1 value");
}
- (void)test_initSignatureAlgorithm_cloudinaryUrl_shouldStoreValue {
        
    // Given
    NSString* signatureAlgorithmQuery = @"?signature_algorithm=sha256";
    NSString* testedUrl               = @"cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3@test";
    NSString* fullUrl                 = [NSString stringWithFormat:@"%@%@",testedUrl,signatureAlgorithmQuery];
    
    // When
    self.sut = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    
    // Then
    XCTAssertEqual(self.sut.signatureAlgorithm, SignatureAlgorithmSha256, "Init with cloudinaryUrl with valid signatureAlgorithm should store that value");
}

@end
