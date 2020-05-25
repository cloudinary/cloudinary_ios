//
//  ObjcCLDExpressionTests.m
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

@interface ObjcCLDExpressionTests : XCTestCase

@end

@implementation ObjcCLDExpressionTests

CLDExpression *expSut;

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
    expSut = nil;
}

// MARK: - creatingExpression
- (void)test_creatingExpression_widthAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"w_add_30";
    
    // When
    expSut = [CLDExpression width];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_heightSubtract_shouldCreateValidExpression {
        
    // Given
    float input = 30.3;
    
    NSString* expectedResult = @"h_sub_30.3";
    
    // When
    expSut = [CLDExpression height];
    [expSut subtractByFloat: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_initialWidthMultiple_shouldCreateValidExpression {
        
    // Given
    NSString* input = @"30";
    
    NSString* expectedResult = @"iw_mul_30";
    
    // When
    expSut = [CLDExpression initialWidth];
    [expSut multipleByString: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_initialHeightDivide_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"ih_div_30";
    
    // When
    expSut = [CLDExpression initialHeight];
    [expSut divideByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_aspectRatioPower_shouldCreateValidExpression {
        
    // Given
    float input = 30.3;
    
    NSString* expectedResult = @"ar_pow_30.3";
    
    // When
    expSut = [CLDExpression aspectRatio];
    [expSut powerByFloat: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_initialAspectRatioAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"iar_add_30";
    
    // When
    expSut = [CLDExpression initialAspectRatio];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_pageCountAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"pc_add_30";
    
    // When
    expSut = [CLDExpression pageCount];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_faceCountAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"fc_add_30";
    
    // When
    expSut = [CLDExpression faceCount];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_tagsAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"tags_add_30";
    
    // When
    expSut = [CLDExpression tags];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_pageXOffsetAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"px_add_30";
    
    // When
    expSut = [CLDExpression pageXOffset];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_pageYOffsetAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"py_add_30";
    
    // When
    expSut = [CLDExpression pageYOffset];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_illustrationScoreAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"ils_add_30";
    
    // When
    expSut = [CLDExpression illustrationScore];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_currentPageIndexAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"cp_add_30";
    
    // When
    expSut = [CLDExpression currentPageIndex];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_durationAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"du_add_30";
    
    // When
    expSut = [CLDExpression duration];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}
- (void)test_creatingExpression_initialDurationAdd_shouldCreateValidExpression {
        
    // Given
    int input = 30;
    
    NSString* expectedResult = @"idu_add_30";
    
    // When
    expSut = [CLDExpression initialDuration];
    [expSut addByInt: input];
    
    NSString* actualResult = [expSut asString];
    
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
    expSut = [CLDExpression initialDuration];
    [expSut addByInt: input];
    
    NSDictionary* actualResult = [expSut asParams];
    
    // Then
    XCTAssertNotNil(actualResult, "Initilized object should contain a none nil name property");
    XCTAssertTrue(actualResult.count == 1 && expectedResult.count == 1, "Calling get asString should return the expect string");
    XCTAssertTrue([actualResult.allKeys[0] isEqualToString: expectedResult.allKeys[0]], "Calling get asString should return the expect string");
    XCTAssertTrue([actualResult.allValues[0] isEqualToString: expectedResult.allValues[0]], "Calling get asString should return the expect string");
}


@end
