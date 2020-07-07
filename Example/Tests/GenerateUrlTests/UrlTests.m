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
@property (nonatomic, strong, nullable) CLDCloudinary *sut;
@end

@implementation ObjCUrlTests

NSString* prefix = @"https://res.cloudinary.com/test123";

- (void)setUp {
    [super setUp];
    CLDConfiguration *config = [[CLDConfiguration alloc] initWithCloudinaryUrl:@"cloudinary://a:b@test123"];
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
    NSString *generatedUrl = [url generate:@"test" signUrl:false];
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
-(void)testGravityUrl:(CLDGravity)gravity expectedValue:(NSString*)expectedValue {
   
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

@end
