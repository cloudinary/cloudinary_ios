//
//  CryptoUtilsTests.m
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

@interface ObjCCryptoUtilsTests : XCTestCase

@end

@implementation ObjCCryptoUtilsTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

// MARK: - SHA256
- (void)test_SHA256Base64_emptyString_shouldReturnHashedString {
    
    // Given
    NSString* initialString = @"";
    
    NSString* expectedResult = @"47DEQpj8HBSa-_TImW-5JCeuQeRkm5NMpJWZG3hSuFU";
    
    // When
    NSString* actualResult = [CryptoObjcHelper sha256_base64WithString:initialString];
    
    // Then
    XCTAssertNotNil(actualResult, @"Hashed string should not be nil");
    XCTAssertEqualObjects(actualResult, expectedResult, "Hashed string should be equal to expected result");
}
- (void)test_SHA256Base64_specialString_shouldReturnHashedString {
    
    // Given
    NSString* initialString = @"🧼:|}!@#$%^&*()±§`~+_=-";
    
    NSString* expectedResult = @"jXJPEpRxcbKlIzNzH1RzAsaDeDR87Ir0cENeW8b5t-g";
    
    // When
    NSString* actualResult = [CryptoObjcHelper sha256_base64WithString:initialString];
    
    // Then
    XCTAssertNotNil(actualResult, @"Hashed string should not be nil");
    XCTAssertEqualObjects(actualResult, expectedResult, "Hashed string should be equal to expected result");
}
- (void)test_SHA256Base64_string_shouldReturnHashedString {
    
    // Given
    NSString* initialString = @"cryptoString";
    
    NSString* expectedResult = @"Ncsntkv4ywCQbf4Xz3pTYrxglVm02y4_X9nmCR8uNt0";
    
    // When
    NSString* actualResult = [CryptoObjcHelper sha256_base64WithString:initialString];
    
    // Then
    XCTAssertNotNil(actualResult, @"Hashed string should not be nil");
    XCTAssertEqualObjects(actualResult, expectedResult, "Hashed string should be equal to expected result");
}


@end
