//
//  CLDCloudinaryTests.m
//
//  Copyright (c) 2021 Cloudinary (http://cloudinary.com)
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

@interface CLDCustomAdapter: NSObject  <CLDNetworkAdapter>
@end

@implementation CLDCustomAdapter
- (id<CLDNetworkDataRequest> _Nonnull)cloudinaryRequest:(NSString * _Nonnull)url headers:(NSDictionary<NSString *,NSString *> * _Nonnull)headers parameters:(NSDictionary<NSString *,id> * _Nonnull)parameters {return nil;}
- (id<CLDFetchImageRequest> _Nonnull)downloadFromCloudinary:(NSString * _Nonnull)url {return nil;}
- (void (^ _Nullable)(void))getBackgroundCompletionHandler {return nil;}
- (void)setBackgroundCompletionHandler:(void (^ _Nullable)(void))newValue {}
- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {}
- (id<CLDNetworkDataRequest> _Nonnull)uploadToCloudinary:(NSString * _Nonnull)url headers:(NSDictionary<NSString *,NSString *> * _Nonnull)headers parameters:(NSDictionary<NSString *,id> * _Nonnull)parameters data:(id _Nonnull)data {return nil;}
@end

@interface CLDCloudinaryTests: XCTestCase
@property (nonatomic, strong, nullable) CLDCloudinary* sut;
@property (nonatomic, strong, nullable) CLDConfiguration* config;
@end

@implementation CLDCloudinaryTests

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
    
    self.config = [[CLDConfiguration alloc] initWithCloudinaryUrl:@"cloudinary://a:b@test123"];
    self.sut    = [[CLDCloudinary alloc] initWithConfiguration: self.config networkAdapter:nil sessionConfiguration:nil];
}

- (void)tearDown {
    
    self.sut = nil;
    self.config = nil;
    [super tearDown];
}

// MARK: - init
- (void)test_init_config_shouldStoreProperties {

    // Given
    NSString* cloudinaryUrl = @"cloudinary://a:b@test123";
    CLDConfiguration* tempConfiguration = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    
    // When
    CLDCloudinary   * tempSut           = [[CLDCloudinary alloc] initWithConfiguration:tempConfiguration networkAdapter:nil sessionConfiguration:nil];
    
    // Then
    XCTAssertNotNil(tempSut, "initialized object should not be nil");
    XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value");
}
- (void)test_init_configSession_shouldStoreProperties {

    // Given
    NSString                  * cloudinaryUrl     = @"cloudinary://a:b@test123";
    NSURLSessionConfiguration *sessionConfig      = [NSURLSessionConfiguration defaultSessionConfiguration];
    CLDConfiguration          * tempConfiguration = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    
    // When
    CLDCloudinary* tempSut = [[CLDCloudinary alloc] initWithConfiguration:tempConfiguration networkAdapter:nil sessionConfiguration:sessionConfig];
    
    // Then
    XCTAssertNotNil(tempSut, "initialized object should not be nil");
    XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value");
}
- (void)test_init_configDownloadSession_shouldStoreProperties {

    // Given
    NSString                  * cloudinaryUrl = @"cloudinary://a:b@test123";
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    CLDConfiguration          * tempConfiguration = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    
    // When
    CLDCloudinary* tempSut = [[CLDCloudinary alloc] initWithConfiguration:tempConfiguration networkAdapter:nil downloadAdapter:nil sessionConfiguration:sessionConfig downloadSessionConfiguration:sessionConfig];
    
    // Then
    XCTAssertNotNil(tempSut, "initialized object should not be nil");
    XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value");
}
- (void)test_init_configDownloadSessionAdapter_shouldStoreProperties {

    // Given
    NSString                  * cloudinaryUrl = @"cloudinary://a:b@test123";
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    CLDConfiguration          * tempConfiguration = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    CLDCustomAdapter          * adapter           = [[CLDCustomAdapter alloc] init];
    
    // When
    CLDCloudinary* tempSut = [[CLDCloudinary alloc] initWithConfiguration:tempConfiguration networkAdapter:adapter downloadAdapter:nil sessionConfiguration:sessionConfig downloadSessionConfiguration:sessionConfig];
    
    // Then
    XCTAssertNotNil(tempSut, "initialized object should not be nil");
    XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value");
}
- (void)test_init_configDownloadSessionDownloadAdapter_shouldStoreProperties {

    // Given
    NSString                  * cloudinaryUrl = @"cloudinary://a:b@test123";
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    CLDConfiguration          * tempConfiguration = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    CLDCustomAdapter          * adapter           = [[CLDCustomAdapter alloc] init];
    
    // When
    CLDCloudinary* tempSut = [[CLDCloudinary alloc] initWithConfiguration:tempConfiguration networkAdapter:adapter downloadAdapter:adapter sessionConfiguration:sessionConfig downloadSessionConfiguration:sessionConfig];
    
    // Then
    XCTAssertNotNil(tempSut, "initialized object should not be nil");
    XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value");
}
- (void)test_init_configSessionAdapter_shouldStoreProperties {

    // Given
    NSString                  * cloudinaryUrl = @"cloudinary://a:b@test123";
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    CLDConfiguration          * tempConfiguration = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    CLDCustomAdapter          * adapter           = [[CLDCustomAdapter alloc] init];

    // When
    CLDCloudinary* tempSut = [[CLDCloudinary alloc] initWithConfiguration:tempConfiguration networkAdapter:adapter sessionConfiguration:sessionConfig];
    
    // Then
    XCTAssertNotNil(tempSut, "initialized object should not be nil");
    XCTAssertEqual (tempSut.config, tempConfiguration, "Initilized object should contain expected value");
}

@end
