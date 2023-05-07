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
#import "ObjcBaseTestCase.h"

@interface ObjCUrlTests : ObjcBaseTestCase
@property (nonatomic, strong, nullable) CLDCloudinary *sut;
@end

@implementation ObjCUrlTests

NSString* prefix = @"https://res.cloudinary.com/test123";

- (void)setUp {
    [super setUp];
    CLDConfiguration *config = [[CLDConfiguration alloc] initWithCloudinaryUrl:@"cloudinary://a:b@test123?analytics=false"];
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

- (void)testCrop {
    CLDTransformation *trans = [[CLDTransformation alloc]init];
    [trans setWidth:@"100"];
    [trans setHeight:@"101"];
    [trans setCrop:@"crop"];

    CLDUrl *url = [self.sut createUrl];
    [url setTransformation:trans];
    NSString *generatedUrl = [url generate:@"test" signUrl:NO];
    XCTAssertEqualObjects(generatedUrl, [prefix stringByAppendingString: @"/image/upload/c_crop,h_101,w_100/test"]);
}
// MARK: - gravity
- (void)test_gravityEnum_shouldReturnExpectedValues {
    
    [self testGravityUrl:CLDGravityCenter expectedValue:@"g_center,w_100"];
    [self testGravityUrl:CLDGravityAuto expectedValue:@"g_auto,w_100"];
    [self testGravityUrl:CLDGravityFace expectedValue:@"g_face,w_100"];
    [self testGravityUrl:CLDGravityFaceCenter expectedValue:@"g_face:center,w_100"];
    [self testGravityUrl:CLDGravityFaces expectedValue:@"g_faces,w_100"];
    [self testGravityUrl:CLDGravityFacesCenter expectedValue:@"g_faces:center,w_100"];
    [self testGravityUrl:CLDGravityAdvFace expectedValue:@"g_adv_face,w_100"];
    [self testGravityUrl:CLDGravityAdvFaces expectedValue:@"g_adv_faces,w_100"];
    [self testGravityUrl:CLDGravityAdvEyes expectedValue:@"g_adv_eyes,w_100"];
    [self testGravityUrl:CLDGravityNorth expectedValue:@"g_north,w_100"];
    [self testGravityUrl:CLDGravityNorthWest expectedValue:@"g_north_west,w_100"];
    [self testGravityUrl:CLDGravityNorthEast expectedValue:@"g_north_east,w_100"];
    [self testGravityUrl:CLDGravitySouth expectedValue:@"g_south,w_100"];
    [self testGravityUrl:CLDGravitySouthWest expectedValue:@"g_south_west,w_100"];
    [self testGravityUrl:CLDGravitySouthEast expectedValue:@"g_south_east,w_100"];
    [self testGravityUrl:CLDGravityWest expectedValue:@"g_west,w_100"];
    [self testGravityUrl:CLDGravityEast expectedValue:@"g_east,w_100"];
    [self testGravityUrl:CLDGravityXyCenter expectedValue:@"g_xy_center,w_100"];
    [self testGravityUrl:CLDGravityCustom expectedValue:@"g_custom,w_100"];
    [self testGravityUrl:CLDGravityCustomFace expectedValue:@"g_custom:face,w_100"];
    [self testGravityUrl:CLDGravityCustomFaces expectedValue:@"g_custom:faces,w_100"];
    [self testGravityUrl:CLDGravityCustomAdvFace expectedValue:@"g_custom:adv_face,w_100"];
    [self testGravityUrl:CLDGravityCustomAdvFaces expectedValue:@"g_custom:adv_faces,w_100"];
    [self testGravityUrl:CLDGravityAutoOcrText expectedValue:@"g_auto:ocr_text,w_100"];
    [self testGravityUrl:CLDGravityOcrText expectedValue:@"g_ocr_text,w_100"];
    [self testGravityUrl:CLDGravityOcrTextAdvOcr expectedValue:@"g_ocr_text:adv_ocr,w_100"];
}
- (void)testGravityUrl:(CLDGravity)gravity expectedValue:(NSString*)expectedValue {
   
    // Given
    NSString* inputWidth    = @"100";
    NSString* inputPublicId = @"publicId";
    BOOL      inputSignUrl  = false;
    
    NSString* expectedResult = [NSString stringWithFormat:@"%@/image/upload/%@/%@", prefix, expectedValue, inputPublicId];
    
    // When
    CLDTransformation* transformation = [[[[CLDTransformation alloc] init] setWidth:inputWidth] setGravityWithGravity:gravity];
    NSString* actualResult = [[[self.sut createUrl] setTransformation:transformation] generate:inputPublicId signUrl:inputSignUrl];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, @"Creating url with gravity enum should return expected result");
}

// MARK: - long url signing
- (void)test_longUrlSign_emptyApiSecret_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@""
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                   analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"DUB-5kBqEhbyNmZ0oan_cTYdW-9HAh-O";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = YES and call generate with signUrl = YES, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_normalApiSecret_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];

    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = YES and call generate with signUrl = YES, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_longApiSecret_shouldCreateExpectedSigning {
    
    // Given
    NSString* longString = @"abcdefghijklmnopqrstuvwxyz1abcdefghijklmnopqrstuvwxyz2abcdefghijklmnopqrstuvwxyz3abcdefghijklmnopqrstuvwxyz4abcdefghijklmnopqrstuvwxyz5abcdefghijklmnopqrstuvwxyz6";

    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:longString
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];

    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
    
    NSString* expectedResult = @"7k8KYHY20iQ6sNTJIWb05ti7bYo1HG3R";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature and call generate with signUrl = YES, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_specialApiSecret_shouldCreateExpectedSigning {
    
    // Given
    NSString* specialString = @"🔭!@#$%^&*()_+±§?><`~";
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:specialString
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];

    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:true];
     
    NSString* expectedResult = @"g12ptQdGPID3Un4aOxZSuiEithIdT2Wm";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature and call generate with signUrl = YES, should encrypt the ApiSecret with SHA256_base64");
}
- (void)test_longUrlSign_unset_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
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
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"FhXe8ZZ3";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = NO and call generate with signUrl = YES, should encrypt the ApiSecret with SHA1_base64");
}
- (void)test_longUrlSign_signUrlFalse_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:NO];
     
    NSString* expectedResult = @"http://test123-res.cloudinary.com/image/upload/test.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = YES and call generate with signUrl = NO, should not encrypt and add the ApiSecret to the url");
}
- (void)test_longUrlSign_unset_shouldCreateExpectedUrl {
    
    // Given
    NSString* url = [[self.sut createUrl] generate:@"sample.jpg" signUrl:YES];
     
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/s--v2fTPYTu--/sample.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = NO and call generate with signUrl = YES, should create a url with SHA1 encrypted apiSecret");
}
- (void)test_longUrlSign_true_shouldCreateExpectedUrl {
    
    // Given
    NSString* longUrlSignatureQuery = @"?long_url_signature=true&analytics=false";
    NSString* urlCredentials        = @"cloudinary://a:b@test123";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",urlCredentials,longUrlSignatureQuery];
    
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];

    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[self.sut createUrl] generate:@"sample.jpg" signUrl:YES];
     
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/s--2hbrSMPOjj5BJ4xV7SgFbRDevFaQNUFf--/sample.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration with longUrlSignature = YES and call generate with signUrl = YES, should create a url with SHA256 encrypted apiSecret");
}

// MARK: - signature algorithm
-(void)test_signatureAlgorithm_emptyApiSecret_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@""
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:NO
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"DUB-5kBq";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = YES, should ecrypte with SHA256_base64");
}
- (void)test_signatureAlgorithm_normalApiSecret_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:NO
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"UHH8qJ2e";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = YES, should ecrypte with SHA256_base64");
}
- (void)test_signatureAlgorithm_longApiSecret_shouldCreateExpectedSigning {
    
    // Given
    NSString* longString = @"abcdefghijklmnopqrstuvwxyz1abcdefghijklmnopqrstuvwxyz2abcdefghijklmnopqrstuvwxyz3abcdefghijklmnopqrstuvwxyz4abcdefghijklmnopqrstuvwxyz5abcdefghijklmnopqrstuvwxyz6";
    
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:longString
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:NO
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
                                                       
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"7k8KYHY2";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = YES, should ecrypte with SHA256_base64");
}
- (void)test_signatureAlgorithm_specialApiSecret_shouldCreateExpectedSigning {
    
    // Given
    NSString* specialString = @"🔭!@#$%^&*()_+±§?><`~";
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:specialString
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:NO
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"g12ptQdG";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = YES, should ecrypte with SHA256_base64");
}
- (void)test_signatureAlgorithm_unset_shouldCreateExpectedSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
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
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"FhXe8ZZ3";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 8, "encrypted component should not be longer than 8 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration without signatureAlgorithm and call for signUrl = true, should ecrypte with the default SHA1_base64");
}
- (void)test_signatureAlgorithm_signUrlFalse_shouldCreateFullUrlWithoutSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:NO
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:NO];
     
    NSString* expectedResult = @"http://test123-res.cloudinary.com/image/upload/test.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and call for signUrl = false, should not encrypt nor add the ApiSecret to the url");
}
- (void)test_signatureAlgorithm_unset_shouldCreateExpectedFullUrl {
    
    // Given
    NSString* url = [[self.sut createUrl] generate:@"sample.jpg" signUrl:YES];
     
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/s--v2fTPYTu--/sample.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for default signatureAlgorithm and signUrl = true, should create a url with SHA1 encrypted apiSecret");
}
- (void)test_signatureAlgorithm_sha256_shouldCreateExpectedFullUrl {
    
    // Given
    NSString* signatureAlgorithQuery = @"?signature_algorithm=sha256&analytics=false";
    NSString* urlCredentials        = @"cloudinary://a:b@test123";
    NSString* fullUrl               = [NSString stringWithFormat:@"%@%@",urlCredentials,signatureAlgorithQuery];
    
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudinaryUrl:fullUrl];
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[self.sut createUrl] generate:@"sample.jpg" signUrl:YES];
     
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/s--2hbrSMPO--/sample.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and signUrl = true, should create a url with SHA256 encrypted apiSecret");
}

// MARK: - signing combinations
- (void)test_signingCombinations_signTrueLongTrueAlgorithmSha1_shouldUse32CharsEcryptedSha256 {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "longUrlSignature should override signing algorithm and force sha256 with 32 charecters");
}
- (void)test_signingCombinations_signTrueLongTrueAlgorithmSha256_shouldUse32CharsEcryptedSha256 {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:YES];
     
    NSString* expectedResult = @"UHH8qJ2eIEoPHdVQP08BMEN9f4YUDavr";
    
    // When
    NSString* actualResult = [url componentsSeparatedByString:@"--"][1];
    
    // Then
    XCTAssertNotNil(actualResult, "encrypted component should not be nil");
    XCTAssertTrue(actualResult.length <= 32, "encrypted component should not be longer than 32 charecters");
    XCTAssertEqualObjects(actualResult, expectedResult, "longUrlSignature should override signing algorithm and force sha256 with 32 charecters");
}
- (void)test_signingCombinations_signFalseLongTrueAlgorithmSha1_shouldNotUseSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha1
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:NO];
     
    NSString* expectedResult = @"http://test123-res.cloudinary.com/image/upload/test.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and longUrlSignature = true and call for signUrl = false, should not encrypt nor add the ApiSecret to the url");
}
- (void)test_signingCombinations_signFalseLongTrueAlgorithmSha256_shouldUseSigning {
    
    // Given
    CLDConfiguration* config = [[CLDConfiguration alloc] initWithCloudName:@"test123"
                                                                    apiKey:@"apiKey"
                                                                 apiSecret:@"apiSecret"
                                                                privateCdn:YES
                                                                    secure:NO
                                                              cdnSubdomain:NO
                                                        secureCdnSubdomain:NO
                                                          longUrlSignature:YES
                                                        signatureAlgorithm:SignatureAlgorithmSha256
                                                        secureDistribution:nil
                                                                     cname:nil
                                                              uploadPrefix:nil
                                                                   timeout:nil
                                                                 analytics:NO];
    
    self.sut = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:nil];
    NSString* url = [[[self.sut createUrl] setFormat:@"jpg"] generate:@"test" signUrl:NO];
     
    NSString* expectedResult = @"http://test123-res.cloudinary.com/image/upload/test.jpg";
    
    // When
    NSString* actualResult = url;
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Setting the configuration for signatureAlgorithm to sha256 and longUrlSignature = true and call for signUrl = false, should not encrypt nor add the ApiSecret to the url");
}

// MARK: - named spaces removal
- (void)test_replaceSpaces_named_shouldCreateExpectedUrl {
    
    // Given
    NSString* inputWidth    = @"100";
    NSString* inputHeight   = @"200";
    NSString* inputNamed    = @"named";
    NSString* inputPublicId = @"publicId";
    BOOL      inputSignUrl  = false;
    
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/h_200,t_named,w_100/publicId";
    
    // When
    CLDTransformation* transformation = [[[[[CLDTransformation alloc] init] setWidth:inputWidth] setNamed:inputNamed] setHeight:inputHeight];
    NSString* actualResult            = [[[self.sut createUrl] setTransformation:transformation] generate:inputPublicId signUrl:inputSignUrl];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, @"creating url with named in transformation should return the expected result");
}
- (void)test_replaceSpaces_namedWithSpaces_shouldReplaceSpaces {
    
    // Given
    NSString* inputWidth       = @"100";
    NSString* inputHeight      = @"200";
    NSString* inputSpacedNamed = @"named with spaces";
    NSString* inputPublicId    = @"publicId";
    BOOL      inputSignUrl     = false;
    
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/h_200,t_named%20with%20spaces,w_100/publicId";
    
    // When
    CLDTransformation* transformation = [[[[[CLDTransformation alloc] init] setWidth:inputWidth] setNamed:inputSpacedNamed] setHeight:inputHeight];
    NSString* actualResult            = [[[self.sut createUrl] setTransformation:transformation] generate:inputPublicId signUrl:inputSignUrl];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, @"creating url with named in transformation should return the expected result");
    
}
- (void)test_replaceSpaces_namedArray_shouldCreateExpectedUrl {
    
    // Given
    NSString* inputWidth    = @"100";
    NSString* inputHeight   = @"200";
    NSString* inputNamed1   = @"named1";
    NSString* inputNamed2   = @"named2";
    NSString* inputPublicId = @"publicId";
    BOOL      inputSignUrl  = false;
    
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/h_200,t_named1.named2,w_100/publicId";
    
    // When
    CLDTransformation* transformation = [[[[[CLDTransformation alloc] init] setWidth:inputWidth] setNamedWithArray:@[inputNamed1,inputNamed2]] setHeight:inputHeight];
    NSString* actualResult            = [[[self.sut createUrl] setTransformation:transformation] generate:inputPublicId signUrl:inputSignUrl];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, @"creating url with named in transformation should return the expected result");
}
- (void)test_replaceSpaces_namedArrayWithSpaces_shouldReplaceSpaces {
    
    // Given
    NSString* inputWidth        = @"100";
    NSString* inputHeight       = @"200";
    NSString* inputSpacedNamed1 = @"named with spaces 1";
    NSString* inputSpacedNamed2 = @"named with spaces 2";
    NSString* inputPublicId     = @"publicId";
    BOOL      inputSignUrl      = false;
    
    NSString* expectedResult = @"https://res.cloudinary.com/test123/image/upload/h_200,t_named%20with%20spaces%201.named%20with%20spaces%202,w_100/publicId";
    
    // When
    CLDTransformation* transformation = [[[[[CLDTransformation alloc] init] setWidth:inputWidth] setNamedWithArray:@[inputSpacedNamed1,inputSpacedNamed2]] setHeight:inputHeight];
    NSString* actualResult            = [[[self.sut createUrl] setTransformation:transformation] generate:inputPublicId signUrl:inputSignUrl];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, @"creating url with named in transformation should return the expected result");
}

@end
