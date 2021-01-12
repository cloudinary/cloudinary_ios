//
//  NetworkBaseTestObjc.m
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

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Cloudinary/Cloudinary-Swift.h>
#import "Cloudinary_Tests-Swift.h"
#import "NetworkBaseTestObjc.h"

@implementation NetworkBaseTestObjc

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
    
    self.timeout = 40.0;
    
    CLDConfiguration* config;
    
    NSString *cloudinaryUrl = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"cldCloudinaryUrl"];
    
    if (cloudinaryUrl.length) {
        config = [[CLDConfiguration alloc] initWithCloudinaryUrl:cloudinaryUrl];
    }
    else {
        
        config = [CLDConfiguration initWithEnvParams];
        if (config == nil) {
            config = [[CLDConfiguration alloc] initWithCloudinaryUrl:@"cloudinary://a:b@test123"];
        }
    }

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];

    self.cloudinary = [[CLDCloudinary alloc] initWithConfiguration:config networkAdapter:nil sessionConfiguration:sessionConfig];
}

- (void)tearDown {
    [super tearDown];
    
    self.cloudinary = nil;
}

// MARK: - public methods
- (NSURL* _Nonnull)getUrlBy:(TestResourceType)testResourceType {
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    return [bundle URLForResource:[self getResourceNameBy:testResourceType] withExtension:[self getResourceExtensionBy:testResourceType]];
}

- (NSData* _Nonnull)getDataBy:(TestResourceType)testResourceType {
    
    return [NSData dataWithContentsOfURL:[self getUrlBy:testResourceType] options:NSUncachedRead error:nil];
}

- (CLDUploadRequest*)uploadFileWithResource:(TestResourceType)testResourceType params:(CLDUploadRequestParams*)params {
    
    XCTAssertNotNil(self.cloudinary.config.apiSecret, "Must set api secret for this test");
    return [[self.cloudinary createUploader] signedUploadWithData:[self getDataBy:testResourceType] params:params progress:nil completionHandler:nil];
}

-(UIImage*)getImageBy:(TestResourceType)testResourceType {
    
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSURL*    url    = [bundle URLForResource:[self getResourceNameBy:testResourceType] withExtension:[self getResourceExtensionBy:testResourceType]];
    return [UIImage imageWithContentsOfFile:url.path];
}

-(AVPlayerItem*)getVideoBy:(TestResourceType)testResourceType {
    
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSURL*    url    = [bundle URLForResource:[self getResourceNameBy:testResourceType] withExtension:[self getResourceExtensionBy:testResourceType]];
    return [AVPlayerItem playerItemWithURL:url];
}

// Mark: - private methods
- (NSString*)getResourceExtensionBy:(TestResourceType)testResourceType {
    
    switch (testResourceType) {
        case logo: return @"png";
        break;
        case borderCollie:
        case textImage: return @"jpg";
        break;
        case docx: return @"docx";
        break;
        case dog: return @"mp4";
        break;
        case pdf: return @"pdf";
        break;
    }
}

- (NSString* _Nonnull)getResourceNameBy:(TestResourceType)testResourceType {
    
    switch (testResourceType) {
        case logo: return @"logo";
        break;
        case borderCollie: return @"borderCollie";
        break;
        case textImage: return @"textImage";
        break;
        case docx: return @"docx";
        break;
        case dog: return @"dog";
        break;
        case pdf: return @"pdf";
        break;
    }
}

@end
