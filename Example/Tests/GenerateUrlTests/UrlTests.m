//
//  ObjCUrlTests.m
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

@interface ObjCUrlTests : XCTestCase

@end

@implementation ObjCUrlTests

NSString *prefix = @"https://res.cloudinary.com/test123";
CLDCloudinary *cloudinary;

- (void)setUp {
    [super setUp];
    CLDConfiguration *config = [[CLDConfiguration alloc] initWithCloudinaryUrl:@"cloudinary://a:b@test123"];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
}

- (void)tearDown {
    [super tearDown];
    cloudinary = nil;
}

- (void)testCrop {
    CLDTransformation *trans = [[CLDTransformation alloc]init];
    [trans setWidth:@"100"];
    [trans setHeight:@"101"];
    [trans setCrop:@"crop"];

    CLDUrl *url = [cloudinary createUrl];
    [url setTransformation:trans];
    NSString *generatedUrl = [url generate:@"test" signUrl:false];
    XCTAssertEqualObjects(generatedUrl, [prefix stringByAppendingString: @"/image/upload/c_crop,h_101,w_100/test"]);
}

// MARK: - SHA256
- (void)test_longUrlSign_emptyApiSecret_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123" apiKey:@"apiKey" apiSecret:@"" privateCdn:true secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:true secureDistribution:nil cname:nil uploadPrefix:nil];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[cloudinary createUrl] setFormat:@"jpg"] generate:@"test" signUrl:true];
     
    NSString* expectedResult = @"DUB-5kBqEhbyNmZ0oan_cTYdW-9HAh-O";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = true and call generate with signUrl = true, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_normalApiSecret_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123" apiKey:@"apiKey" apiSecret:@"apiSecret" privateCdn:true secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:true secureDistribution:nil cname:nil uploadPrefix:nil];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[cloudinary createUrl] setFormat:@"jpg"] generate:@"test" signUrl:true];
     
    NSString* expectedResult = @"UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = true and call generate with signUrl = true, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_longApiSecret_shouldCreateExpectedSigning {
    
    // Given
    NSString* longString = @"abcdefghijklmnopqrstuvwxyz1abcdefghijklmnopqrstuvwxyz2abcdefghijklmnopqrstuvwxyz3abcdefghijklmnopqrstuvwxyz4abcdefghijklmnopqrstuvwxyz5abcdefghijklmnopqrstuvwxyz6";
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123" apiKey:@"apiKey" apiSecret:longString privateCdn:true secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:true secureDistribution:nil cname:nil uploadPrefix:nil];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[cloudinary createUrl] setFormat:@"jpg"] generate:@"test" signUrl:true];
     
    NSString* expectedResult = @"7k8KYHY20iQ6sNTJIWb05ti7bYo1HG3R";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature and call generate with signUrl = true, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_specialApiSecret_shouldCreateExpectedSigning {
    
    // Given
    NSString* specialString = @"🔭!@#$%^&*()_+±§?><`~";
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123" apiKey:@"apiKey" apiSecret:specialString privateCdn:true secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:true secureDistribution:nil cname:nil uploadPrefix:nil];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[cloudinary createUrl] setFormat:@"jpg"] generate:@"test" signUrl:true];
     
    NSString* expectedResult = @"g12ptQdGPID3Un4aOxZSuiEithIdT2Wm";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature and call generate with signUrl = true, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_unset_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123" apiKey:@"apiKey" apiSecret:@"apiSecret" privateCdn:true secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:false secureDistribution:nil cname:nil uploadPrefix:nil];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[cloudinary createUrl] setFormat:@"jpg"] generate:@"test" signUrl:true];
     
    NSString* expectedResult = @"FhXe8ZZ3";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = false and call generate with signUrl = true, should encrypt the ApiSecret with SHA1_base64");
}
- (void)test_longUrlSign_signUrlFalse_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123" apiKey:@"apiKey" apiSecret:@"apiSecret" privateCdn:true secure:false cdnSubdomain:false secureCdnSubdomain:false longUrlSignature:true secureDistribution:nil cname:nil uploadPrefix:nil];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[cloudinary createUrl] setFormat:@"jpg"] generate:@"test" signUrl:false];
     
    NSString* expectedResult = @"http://test123-res.cloudinary.com/image/upload/test.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = true and call generate with signUrl = false, should not encrypt and add the ApiSecret to the url");
}
- (void)test_longUrlSign_unset_shouldCreateExpectedUrl {
    
    // Given
    NSString* url = [[cloudinary createUrl] generate:@"sample.jpg" signUrl:true];
     
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/s--v2fTPYTu--/sample.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = false and call generate with signUrl = true, should create a url with SHA1 encrypted apiSecret");
}
- (void)test_longUrlSign_true_shouldCreateExpectedUrl {
    
    // Given
    NSString* longUrlSignatureQuery = @"?long_url_signature=true";
    NSString* urlCredentials        = @"cloudinary://a:b@test123";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",urlCredentials,longUrlSignatureQuery];
    
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[cloudinary createUrl] generate:@"sample.jpg" signUrl:true];
     
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/s--2hbrSMPOjj5BJ4xV7SgFbRDevFaQNUFf--/sample.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = true and call generate with signUrl = true, should create a url with SHA256 encrypted apiSecret");
}

@end
