//
//  ObjcUploaderWidgetTests.m
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
#import "NetworkBaseTestObjc.h"
#import <AVKit/AVKit.h>

@interface ObjcUploaderWidgetTests : NetworkBaseTestObjc <CLDUploaderWidgetDelegate>
@property (nonatomic, strong, nullable) CLDUploaderWidget* sut;
@end

@implementation ObjcUploaderWidgetTests

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}
- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

// MARK: - helper methods
- (NSArray<UIImage*>*)createImagesArray {
   
    NSMutableArray* imagesArray = [NSMutableArray new];
    
    for (int index = 0; index < 10; index++) {
        UIImage* image = [self getImageBy:logo];
        [imagesArray addObject:image];
    }
    
    return [NSArray arrayWithArray:imagesArray];
}
- (NSArray<AVPlayerItem*>*)createVideosArray {
   
    NSMutableArray* videosArray = [NSMutableArray new];
    
    for (int index = 0; index < 10; index++) {
        AVPlayerItem* video = [self getVideoBy:dog];
        [videosArray addObject:video];
    }
    
    return [NSArray arrayWithArray:videosArray];
}

// MARK: - delegate
- (void)uploadWidget:(CLDUploaderWidget * _Nonnull)widget willCall:(NSArray<CLDUploadRequest *> * _Nonnull)uploadRequests {}
- (void)uploadWidgetDidDismiss {}
- (void)widgetDidCancel:(CLDUploaderWidget * _Nonnull)widget {}

// MARK: - test init
- (void)test_init_cloudinary_shouldCreateObject {
      
    // Given
    CLDCloudinary* cloudinaryObject = self.cloudinary;
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:cloudinaryObject configuration:nil images:nil videos:nil delegate:nil];

    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, cloudinaryObject, "objects should be equal");
}
- (void)test_init_cloudinaryConfiguration_shouldCreateObject {
      
    // Given
    CLDCloudinary* cloudinaryObject       = self.cloudinary;
    CLDUploadType* uploadType             = [[CLDUploadType alloc] initWithSigned:true preset:nil];
    CLDWidgetConfiguration* configuration = [[CLDWidgetConfiguration alloc] initWithAllowRotate:true initialAspectLockState:AspectRatioLockStateEnabledAndOff uploadType:uploadType];
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:cloudinaryObject configuration:configuration images:nil videos:nil delegate:nil];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, cloudinaryObject, "objects should be equal");
    XCTAssertEqual (self.sut.configuration, configuration, "objects should be equal");
}
- (void)test_init_cloudinaryConfigurationImages_shouldCreateObject {
      
    // Given
    CLDCloudinary* cloudinaryObject       = self.cloudinary;
    NSArray* images                       = [self createImagesArray];
    CLDUploadType* uploadType             = [[CLDUploadType alloc] initWithSigned:true preset:nil];
    CLDWidgetConfiguration* configuration = [[CLDWidgetConfiguration alloc] initWithAllowRotate:true initialAspectLockState:AspectRatioLockStateEnabledAndOff uploadType:uploadType];
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:cloudinaryObject configuration:configuration images:images videos:nil delegate:nil];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, cloudinaryObject, "objects should be equal");
    XCTAssertEqual (self.sut.configuration, configuration, "objects should be equal");
    XCTAssertEqual (self.sut.images, images, "objects should be equal");
}
- (void)test_convenienceInit_cloudinaryConfigurationImages_shouldCreateObject {
      
    // Given
    CLDCloudinary* cloudinaryObject       = self.cloudinary;
    NSArray* images                       = [self createImagesArray];
    CLDUploadType* uploadType             = [[CLDUploadType alloc] initWithSigned:true preset:nil];
    CLDWidgetConfiguration* configuration = [[CLDWidgetConfiguration alloc] initWithAllowRotate:true initialAspectLockState:AspectRatioLockStateEnabledAndOff uploadType:uploadType];
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:cloudinaryObject configuration:configuration images:images delegate:nil];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, cloudinaryObject, "objects should be equal");
    XCTAssertEqual (self.sut.configuration, configuration, "objects should be equal");
    XCTAssertEqual (self.sut.images, images, "objects should be equal");
}
- (void)test_init_cloudinaryConfigurationImagesVideos_shouldCreateObject {
      
    // Given
    CLDCloudinary* cloudinaryObject       = self.cloudinary;
    NSArray* images                       = [self createImagesArray];
    NSArray* videos                       = [self createVideosArray];
    CLDUploadType* uploadType             = [[CLDUploadType alloc] initWithSigned:true preset:nil];
    CLDWidgetConfiguration* configuration = [[CLDWidgetConfiguration alloc] initWithAllowRotate:true initialAspectLockState:AspectRatioLockStateEnabledAndOff uploadType:uploadType];
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:cloudinaryObject configuration:configuration images:images videos:videos delegate:nil];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, cloudinaryObject, "objects should be equal");
    XCTAssertEqual (self.sut.configuration, configuration, "objects should be equal");
    XCTAssertEqual (self.sut.images, images, "objects should be equal");
    XCTAssertEqual (self.sut.videos, videos, "objects should be equal");
}
- (void)test_init_allProperties_shouldCreateObject {
      
    // Given
    CLDCloudinary* cloudinaryObject       = self.cloudinary;
    NSArray* images                       = [self createImagesArray];
    NSArray* videos                       = [self createVideosArray];
    CLDUploadType* uploadType             = [[CLDUploadType alloc] initWithSigned:true preset:nil];
    CLDWidgetConfiguration* configuration = [[CLDWidgetConfiguration alloc] initWithAllowRotate:true initialAspectLockState:AspectRatioLockStateEnabledAndOff uploadType:uploadType];
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:cloudinaryObject configuration:configuration images:images videos:videos delegate:self];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertNotNil(self.sut.delegate, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, cloudinaryObject, "objects should be equal");
    XCTAssertEqual (self.sut.configuration, configuration, "objects should be equal");
    XCTAssertEqual (self.sut.images, images, "objects should be equal");
    XCTAssertEqual (self.sut.videos, videos, "objects should be equal");
}

// MARK: - test update
- (void)test_update_allProperties_shouldCreateObject {
      
    // Given
    CLDCloudinary* initialCloudinaryObject = self.cloudinary;
    CLDCloudinary* updatedCloudinaryObject = self.cloudinary;
    NSArray* images                        = [self createImagesArray];
    NSArray* videos                        = [self createVideosArray];
    CLDUploadType* uploadType              = [[CLDUploadType alloc] initWithSigned:true preset:nil];
    CLDWidgetConfiguration* configuration  = [[CLDWidgetConfiguration alloc] initWithAllowRotate:true initialAspectLockState:AspectRatioLockStateEnabledAndOff uploadType:uploadType];
    
    // When
    self.sut = [[CLDUploaderWidget alloc] initWithCloudinary:initialCloudinaryObject configuration:nil images:nil videos:nil delegate:nil];
    [[[[[self.sut setCloudinaryFromCloudinary:updatedCloudinaryObject] setConfigurationFromConfiguration:configuration] setImagesFromImages:images] setVideosFromVideoItems:videos] setDelegate:self];
    
    // Then
    XCTAssertNotNil(self.sut, "object should be initialized");
    XCTAssertNotNil(self.sut.delegate, "object should be initialized");
    XCTAssertEqual (self.sut.cloudinaryObject, updatedCloudinaryObject, "objects should be equal");
    XCTAssertEqual (self.sut.configuration, configuration, "objects should be equal");
    XCTAssertEqual (self.sut.videos, videos, "objects should be equal");
}

@end
