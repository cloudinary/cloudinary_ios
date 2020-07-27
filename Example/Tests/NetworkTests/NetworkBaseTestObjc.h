//
//  NetworkBaseTestObjc.h
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

typedef enum TestResourceType: NSUInteger {
    logo,
    borderCollie,
    docx,
    dog,
    pdf,
    textImage
} TestResourceType;

@interface NetworkBaseTestObjc: XCTestCase

@property (nonatomic, strong, nullable) CLDCloudinary* cloudinary;
@property (nonatomic, assign)           NSTimeInterval timeout;

- (NSString* _Nonnull)getResourceNameBy:(TestResourceType)testResourceType;
- (NSURL* _Nonnull)   getUrlBy         :(TestResourceType)testResourceType;
- (NSData* _Nonnull)  getDataBy        :(TestResourceType)testResourceType;

@end
