//
//  ObjcUploaderWidgetConfigurationTests.m
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

@interface ObjcUploaderWidgetConfigurationTests : XCTestCase
@property (nonatomic, strong, nullable) CLDWidgetConfiguration* sut;
@end

@implementation ObjcUploaderWidgetConfigurationTests

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}
- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

// MARK: - test initilization methods
- (void)test_init_falseInputParamaters_shouldStoreInputValues {
      
    // Given
    BOOL allowRotate                            = false;
    AspectRatioLockState initialAspectLockState = AspectRatioLockStateDisabled;
    CLDUploadType* uploadType                      = [[CLDUploadType alloc] initWithSigned:false preset:nil];
    
    // When
    self.sut = [[CLDWidgetConfiguration alloc] initWithAllowRotate:allowRotate  initialAspectLockState:initialAspectLockState uploadType:uploadType];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertFalse (self.sut.allowRotate, "object's properties should store value from init call");
    XCTAssertEqual (self.sut.initialAspectLockState, initialAspectLockState, "object's properties should store value from init call");
    XCTAssertEqual (self.sut.uploadType, uploadType, "object's properties should store value from init call");
}
- (void)test_init_mixInputParamaters_shouldStoreInputValues {
      
    // Given
    BOOL allowRotate                            = true;
    AspectRatioLockState initialAspectLockState = AspectRatioLockStateEnabledAndOn;
    CLDUploadType* uploadType                      = [[CLDUploadType alloc] initWithSigned:true preset:@"preset"];
    
    // When
    self.sut = [[CLDWidgetConfiguration alloc] initWithAllowRotate:allowRotate initialAspectLockState:initialAspectLockState uploadType:uploadType];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertTrue (self.sut.allowRotate, "object's properties should store value from init call");
    XCTAssertEqual (self.sut.initialAspectLockState, initialAspectLockState, "object's properties should store value from init call");
    XCTAssertEqual (self.sut.uploadType, uploadType, "object's properties should store value from init call");
}

@end
