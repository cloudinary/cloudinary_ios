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
@property (nonatomic, strong, nullable) CLDConfiguration *sut;
@end

@implementation ObjcCLDConfigurationTests



// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
    self.sut = [[CLDConfiguration alloc] initWithCloudName:@""
                                                    apiKey:nil
                                                 apiSecret:nil
                                                privateCdn:NO
                                                    secure:NO
                                              cdnSubdomain:NO
                                        secureCdnSubdomain:NO
                                        secureDistribution:nil
                                                     cname:nil
                                              uploadPrefix:nil];
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

@end
