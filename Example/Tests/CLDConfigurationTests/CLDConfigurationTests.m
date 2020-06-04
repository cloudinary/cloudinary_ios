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

@interface ObjcCLDConfigurationTests : XCTestCase

@end

@implementation ObjcCLDConfigurationTests

CLDConfiguration *configurationSut;

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
    configurationSut = nil;
}

// MARK: - LongUrlSignature
- (void)test_initLongUrlSignature_true_shouldStoreValue {
        
    // Given
    BOOL input = true;
    
    // When
    configurationSut = [[CLDConfiguration alloc] initWithCloudName:@"" apiKey:nil apiSecret:nil privateCdn:false secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:input secureDistribution:nil cname:nil uploadPrefix:nil timeout:nil];
    
    // Then
    XCTAssertTrue(configurationSut.longUrlSignature, "Init with longUrlSignature = true, should be stored in property");
}
- (void)test_initLongUrlSignature_default_shouldStoreFalseValue {

    // When
    configurationSut = [[CLDConfiguration alloc] initWithCloudName:@"" apiKey:nil apiSecret:nil privateCdn:false secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:false secureDistribution:nil cname:nil uploadPrefix:nil timeout:nil];
    
    // Then
    XCTAssertFalse(configurationSut.longUrlSignature, "Init without longUrlSignature should store the default false value");
}
- (void)test_initLongUrlSignature_optionsString_shouldStoreValue {
        
    // Given
    NSString* keyCloudName          = @"cloud_name";
    NSString* inputCloudName        = @"foo";
    NSString* keyLongUrlSignature   = @"long_url_signature";
    NSString* inputLongUrlSignature = @"true";
    
    // When
    configurationSut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyLongUrlSignature: inputLongUrlSignature}];
    
    // Then
    XCTAssertTrue(configurationSut.longUrlSignature, "Init with options with longUrlSignature = true, should be stored in property");
}
- (void)test_initLongUrlSignature_optionsBool_shouldStoreValue {
        
    // Given
    NSString* keyCloudName          = @"cloud_name";
    NSString* inputCloudName        = @"foo";
    NSString* keyLongUrlSignature   = @"long_url_signature";
    NSNumber* inputLongUrlSignature = @YES;
    
    // When
    configurationSut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyLongUrlSignature: inputLongUrlSignature}];
    
    // Then
    XCTAssertTrue(configurationSut.longUrlSignature, "Init with options with longUrlSignature = true, should be stored in property");
}
- (void)test_initLongUrlSignature_cloudinaryUrl_shouldStoreValue {
        
    // Given
    NSString* longUrlSignatureQuery = @"?long_url_signature=true";
    NSString* testedUrl             = @"cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",testedUrl,longUrlSignatureQuery];
    
    // When
    configurationSut = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    
    // Then
    XCTAssertTrue(configurationSut.longUrlSignature, "Init with cloudinaryUrl with valid longUrlSignature = true, should be stored in property");
}

// MARK: - timeout
- (void)test_initTimeout_setNSNumber_shouldStoreValue {
        
    // Given
    NSNumber* input = [[NSNumber alloc] initWithInt:10000];
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];
    
    // When
    configurationSut = [[CLDConfiguration alloc] initWithCloudName:@"" apiKey:nil apiSecret:nil privateCdn:false secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:false secureDistribution:nil cname:nil uploadPrefix:nil timeout:input];
    
    // Then
    XCTAssertEqualObjects(configurationSut.timeout, expectedResult, "Init with timeout = number, should be stored in property");
}
- (void)test_initTimeout_nil_shouldStoreFalseValue {

    // When
    configurationSut = [[CLDConfiguration alloc] initWithCloudName:@"" apiKey:nil apiSecret:nil privateCdn:false secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:false secureDistribution:nil cname:nil uploadPrefix:nil timeout:nil];
    
    // Then
    XCTAssertNil(configurationSut.timeout, "Init with timeout = nil, should not be stored in property");
}
- (void)test_initTimeout_optionsString_shouldStoreValue {
        
    // Given
    NSString* keyCloudName   = @"cloud_name";
    NSString* inputCloudName = @"foo";
    NSString* keyTimeout     = @"timeout";
    NSString* inputTimeout   = @"10000";
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];

    // When
    configurationSut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyTimeout: inputTimeout}];
    
    // Then
    XCTAssertEqualObjects(configurationSut.timeout, expectedResult, "Init with timeout = number, should be stored in property");
}
- (void)test_initTimeout_optionsNSNumber_shouldStoreValue {
        
    // Given
    NSString* keyCloudName   = @"cloud_name";
    NSString* inputCloudName = @"foo";
    NSString* keyTimeout     = @"timeout";
    NSNumber* inputTimeout   = [[NSNumber alloc] initWithInt:10000];
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];
    
    // When
    configurationSut = [[CLDConfiguration alloc] initWithOptions:@{keyCloudName: inputCloudName, keyTimeout: inputTimeout}];
    
    // Then
    XCTAssertEqualObjects(configurationSut.timeout, expectedResult, "Init with timeout = number, should be stored in property");
}
- (void)test_initTimeout_cloudinaryUrl_shouldStoreValue {
        
    // Given
    NSString* longUrlSignatureQuery = @"?timeout=10000";
    NSString* testedUrl             = @"cloudinary://123456789012345:ALKJdjklLJAjhkKJ45hBK92baj3";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",testedUrl,longUrlSignatureQuery];
    
    NSNumber* expectedResult = [[NSNumber alloc] initWithInt:10000];

    // When
    configurationSut = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    
    // Then
    XCTAssertEqualObjects(configurationSut.timeout, expectedResult, "Init with cloudinaryUrl with valid timeout, should be stored in property");
}
@end
