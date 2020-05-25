//
//  ObjcCLDConditionExpressionTests.m
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

@interface ObjcCLDConditionExpressionTests : XCTestCase

@end

@implementation ObjcCLDConditionExpressionTests

CLDConditionExpression *conSut;

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
    conSut = nil;
}

// MARK: - complexConditionExpression
- (void)test_complexConditionExpression_shouldCreateValidExpression {
        
    // Given
    NSString* expectedResult = @"w_add_30_and_h_gt_30_or_ar_eq_20";
    
    // When
    conSut = [[[[[[CLDConditionExpression width] addByInt:30] and] height:@">" intValue:30] or] aspectRatio:@"eq" string:@"20"];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}

// MARK: - creatingConditionExpression
- (void)test_creatingConditionExpression_widthAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"w_add_30";
    
    // When
    conSut = [CLDConditionExpression width];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_heightSubtract_shouldCreateValidExpression {
        
    // Given
    float input = 30.3;
    
    NSString* expectedResult = @"h_sub_30.3";
    
    // When
    conSut = [CLDConditionExpression height];
    [conSut subtractByFloat: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_initialWidthMultiple_shouldCreateValidExpression {
        
    // Given
    NSString* input = @"30";
    
    NSString* expectedResult = @"iw_mul_30";
    
    // When
    conSut = [CLDConditionExpression initialWidth];
    [conSut multipleByString: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_initialHeightDivide_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"ih_div_30";
    
    // When
    conSut = [CLDConditionExpression initialHeight];
    [conSut divideByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_aspectRatioPower_shouldCreateValidExpression {
        
    // Given
    float input = 30.3;
    
    NSString* expectedResult = @"ar_pow_30.3";
    
    // When
    conSut = [CLDConditionExpression aspectRatio];
    [conSut powerByFloat: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_initialAspectRatioAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"iar_add_30";
    
    // When
    conSut = [CLDConditionExpression initialAspectRatio];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_pageCountAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"pc_add_30";
    
    // When
    conSut = [CLDConditionExpression pageCount];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_faceCountAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"fc_add_30";
    
    // When
    conSut = [CLDConditionExpression faceCount];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_tagsAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"tags_add_30";
    
    // When
    conSut = [CLDConditionExpression tags];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_pageXOffsetAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"px_add_30";
    
    // When
    conSut = [CLDConditionExpression pageXOffset];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_pageYOffsetAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"py_add_30";
    
    // When
    conSut = [CLDConditionExpression pageYOffset];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_illustrationScoreAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"ils_add_30";
    
    // When
    conSut = [CLDConditionExpression illustrationScore];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_currentPageIndexAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"cp_add_30";
    
    // When
    conSut = [CLDConditionExpression currentPageIndex];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_durationAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"du_add_30";
    
    // When
    conSut = [CLDConditionExpression duration];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingConditionExpression_initialDurationAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"idu_add_30";
    
    // When
    conSut = [CLDConditionExpression initialDuration];
    [conSut addByInt: input];
    
    NSString* actualResult = [conSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}

// MARK: - asParams
- (void)test_asParams_initialDurationAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSDictionary* expectedResult = @{@"idu":@"add_30"};
    
    // When
    conSut = [CLDConditionExpression initialDuration];
    [conSut addByInt: input];
    
    NSDictionary* actualResult = [conSut asParams];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue(actualResult.count == 1 && expectedResult.count == 1, "Calling get asString should return the expect string");
    XCTAssertTrue([actualResult.allKeys[0] isEqualToString: expectedResult.allKeys[0]], "Calling get asString should return the expect string");
    XCTAssertTrue([actualResult.allValues[0] isEqualToString: expectedResult.allValues[0]], "Calling get asString should return the expect string");
}

@end
