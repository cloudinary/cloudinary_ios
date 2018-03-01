//
//  UrlTests.m
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

@end
