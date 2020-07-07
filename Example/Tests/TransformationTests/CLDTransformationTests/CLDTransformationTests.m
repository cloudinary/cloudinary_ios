//
//  ObjcCLDTransformationTests.m
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

@interface ObjcCLDTransformationTests : XCTestCase
@property (nonatomic, strong, nullable) CLDTransformation *sut;
@end

@implementation ObjcCLDTransformationTests

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
    self.sut = [[CLDTransformation alloc] init];
}

- (void)tearDown {
    [super tearDown];
    self.sut = nil;
}

// MARK: - complexConditionExpression
- (void)test_complexTransformations_shouldCreateValidString {
        
    // Given
    NSString * expectedResult = [self getExpectedResultToComplexConditionTest];
    
    // When
    self.sut = [self.sut setVariable:@"$foo" intValue: 10];
    self.sut = [self.sut setVariable:@"$foostr" valuesArray: @[@"my", @"str", @"ing"]];
    self.sut = [self.sut chain];
    self.sut = [self.sut ifCondition: [self getIfConditionForComplexConditionTest]];
    self.sut = [self.sut setCrop: @"scale"];
    
    CLDConditionExpression *conditionForWidth = [[CLDConditionExpression alloc] initWithValue: @"$foo * 200 / faceCount"];
    self.sut = [self.sut setWidthWithExpression: conditionForWidth];
    self.sut = [self.sut setOverlay: @"$foostr"];
    self.sut = [self.sut endIf];
    
    NSString * actualResult = [self.sut asString];
    
    // Then
    XCTAssertTrue([actualResult isEqualToString: expectedResult], "Calling get asString should return the expect string");
}

-(CLDConditionExpression*)getIfConditionForComplexConditionTest {
    CLDConditionExpression* condition = [[CLDConditionExpression faceCount] greaterThenInt: 2];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression pageCount]] lessThenInt: 300];
    condition = [[condition orString: @"!myTag1!"] insideExpression:[CLDConditionExpression tags]];
    condition = [[condition andString: @"!myTag2!"] notInsideExpression:[CLDConditionExpression tags]];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression width]] greaterOrEqualToInt: 200];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression height]] equalToString: @"$foo"];
    condition = [[[[condition and] valueFromExpression:[CLDConditionExpression width]] notEqualToString: @"$foo"] multipleByInt: 2];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression height]] lessThenString: @"$foo"];
    condition = [[[condition or] valueFromExpression:[CLDConditionExpression width]] lessOrEqualToInt: 500];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression illustrationScore]] lessThenInt: 0];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression currentPageIndex]] equalToInt: 10];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression pageXOffset]] lessThenInt: 300];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression pageYOffset]] lessThenInt: 300];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression pageYOffset]] notEqualToInt: 400];
    
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression aspectRatio]] greaterThenString: @"3:4"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialAspectRatio]] greaterThenString: @"3:4"];
    
    // condition in condition
    CLDConditionExpression* innerConditionInitialWidth = [[[CLDConditionExpression initialWidth] divideByInt: 2] addByInt: 1];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression height]] lessThenExpression:innerConditionInitialWidth];
    
    CLDConditionExpression* innerConditionInitialHeight = [[CLDConditionExpression initialHeight] subtractByString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression width]] lessThenExpression:innerConditionInitialHeight];
    
    // duration
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression duration]] equalToString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression duration]] notEqualToString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression duration]] lessThenInt: 30];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression duration]] lessOrEqualToString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression duration]] greaterThenInt: 30];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression duration]] greaterOrEqualToString: @"$foo"];
    
    // initial duration
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialDuration]] equalToString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialDuration]] notEqualToString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialDuration]] lessThenInt: 30];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialDuration]] lessOrEqualToString: @"$foo"];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialDuration]] greaterThenInt: 30];
    condition = [[[condition and] valueFromExpression:[CLDConditionExpression initialDuration]] greaterOrEqualToString: @"$foo"];

    return condition;
}

-(NSString*)getExpectedResultToComplexConditionTest {
    NSMutableString* expectedResult = [NSMutableString string];
    [expectedResult appendString:@"$foo_10,$foostr_!my:str:ing!/if_fc_gt_2_and"];
    [expectedResult appendString:@"_pc_lt_300_or"];
    [expectedResult appendString:@"_!myTag1!_in_tags_and"];
    [expectedResult appendString:@"_!myTag2!_nin_tags_and"];
    [expectedResult appendString:@"_w_gte_200_and"];
    [expectedResult appendString:@"_h_eq_$foo_and"];
    [expectedResult appendString:@"_w_ne_$foo_mul_2_and"];
    [expectedResult appendString:@"_h_lt_$foo_or"];
    [expectedResult appendString:@"_w_lte_500_and"];
    [expectedResult appendString:@"_ils_lt_0_and"];
    [expectedResult appendString:@"_cp_eq_10_and"];
    [expectedResult appendString:@"_px_lt_300_and"];
    [expectedResult appendString:@"_py_lt_300_and"];
    [expectedResult appendString:@"_py_ne_400_and"];
    [expectedResult appendString:@"_ar_gt_3:4_and"];
    [expectedResult appendString:@"_iar_gt_3:4_and"];
    [expectedResult appendString:@"_h_lt_iw_div_2_add_1_and"];
    [expectedResult appendString:@"_w_lt_ih_sub_$foo_and"];
    [expectedResult appendString:@"_du_eq_$foo_and"];
    [expectedResult appendString:@"_du_ne_$foo_and"];
    [expectedResult appendString:@"_du_lt_30_and"];
    [expectedResult appendString:@"_du_lte_$foo_and"];
    [expectedResult appendString:@"_du_gt_30_and"];
    [expectedResult appendString:@"_du_gte_$foo_and"];
    [expectedResult appendString:@"_idu_eq_$foo_and"];
    [expectedResult appendString:@"_idu_ne_$foo_and"];
    [expectedResult appendString:@"_idu_lt_30_and"];
    [expectedResult appendString:@"_idu_lte_$foo_and"];
    [expectedResult appendString:@"_idu_gt_30_and"];
    [expectedResult appendString:@"_idu_gte_$foo"];
    [expectedResult appendString:@"/c_scale,l_$foostr,w_$foo_mul_200_div_fc/if_end"];
    return [NSString stringWithString: expectedResult];
}

// MARK: - customPreFunction
- (void)test_setCustomPreFunction_emptyWasm_shouldReturnValidString {
    
    // Given
    NSString* input = @"";
    
    NSString* expectedResult = @"wasm:";
    
    // When
    CLDCustomFunction* customFunc = [CLDCustomFunction wasm:input];
    [self.sut setCustomPreFunction:customFunc];
    
    NSString* actualResult = [self.sut customPreFunction];
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Calling for inserted param should return its value");
}
- (void)test_setCustomPreFunction_wasm_shouldReturnValidString {
    
    // Given
    NSString* input = @"func";
    
    NSString* expectedResult = @"wasm:func";
    
    // When
    [self.sut setCustomPreFunction:[CLDCustomFunction wasm:input]];
    
    NSString* actualResult = [self.sut customPreFunction];
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Calling for inserted param should return its value");
}
- (void)test_setCustomPreFunction_emptyRemote_shouldReturnValidString {
    
    // Given
    NSString* input = @"";
    
    NSString* expectedResult = @"remote:";
    
    // When
    [self.sut setCustomPreFunction:[CLDCustomFunction remote:input]];
    
    NSString* actualResult = [self.sut customPreFunction];
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Calling for inserted param should return its value");
}
- (void)test_setCustomPreFunction_remote_shouldReturnValidString {
    
    // Given
    NSString* input = @"func";
    
    NSString* expectedResult = @"remote:ZnVuYw==";
    
    // When
    [self.sut setCustomPreFunction:[CLDCustomFunction remote:input]];
    
    NSString* actualResult = [self.sut customPreFunction];
    
    // Then
    XCTAssertEqualObjects(actualResult, expectedResult, "Calling for inserted param should return its value");
}

// MARK: - custom pre functions
- (void)test_customPreFunction_wasm_shouldReturnExpectedValue {
   
    // Given
    NSString* input = @"blur_wasm";
    
    NSString* expectedResult = @"fn_pre:wasm:blur_wasm";
    
    // When
    self.sut = [[[CLDTransformation alloc] init] setCustomPreFunction:[CLDCustomFunction wasm:input]];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "actualResult should be equal to expectedResult");
}
- (void)test_customPreFunction_remote_shouldReturnExpectedValue {
    
    // Given
    NSString* input = @"https://df34ra4a.execute-api.us-west-2.amazonaws.com/default/cloudinaryFunction";
    
    NSString* expectedResult = @"fn_pre:remote:aHR0cHM6Ly9kZjM0cmE0YS5leGVjdXRlLWFwaS51cy13ZXN0LTIuYW1hem9uYXdzLmNvbS9kZWZhdWx0L2Nsb3VkaW5hcnlGdW5jdGlvbg==";
    
    // When
    self.sut = [[[CLDTransformation alloc] init] setCustomPreFunction:[CLDCustomFunction remote:input]];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "actualResult should be equal to expectedResult");
}

// MARK: - custom functions
- (void)test_customFunction_wasm_shouldReturnExpectedValue {
   
    // Given
    NSString* input = @"blur_wasm";
    
    NSString* expectedResult = @"fn_wasm:blur_wasm";
    
    // When
    self.sut = [[[CLDTransformation alloc] init] setCustomFunction:[CLDCustomFunction wasm:input]];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "actualResult should be equal to expectedResult");
}
- (void)test_customFunction_remote_shouldReturnExpectedValue {
    
    // Given
    NSString* input = @"https://df34ra4a.execute-api.us-west-2.amazonaws.com/default/cloudinaryFunction";
    
    NSString* expectedResult = @"fn_remote:aHR0cHM6Ly9kZjM0cmE0YS5leGVjdXRlLWFwaS51cy13ZXN0LTIuYW1hem9uYXdzLmNvbS9kZWZhdWx0L2Nsb3VkaW5hcnlGdW5jdGlvbg==";
    
    // When
    self.sut = [[[CLDTransformation alloc] init] setCustomFunction:[CLDCustomFunction remote:input]];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "actualResult should be equal to expectedResult");
}

// MARK: - custom functions combinations
- (void)test_customFunctionCombinations_setPreFirstAndWasm_shouldReturnExpectedValue {
   
    // Given
    NSString* inputPre = @"preFunc";
    NSString* input    = @"func";
    
    NSString* expectedResult = @"fn_wasm:func";
    
    // When
    self.sut = [[[[CLDTransformation alloc] init] setCustomPreFunction:[CLDCustomFunction wasm:inputPre]] setCustomFunction:[CLDCustomFunction wasm:input]];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "custom pre function should only be used when custom function is not set");
}
- (void)test_customFunctionCombinations_setPreLastAndRemote_shouldReturnExpectedValue {
   
    // Given
    NSString* inputPre = @"preFunc";
    NSString* input    = @"func";
    
    NSString* expectedResult = @"fn_pre:remote:cHJlRnVuYw==";
    
    // When
    self.sut = [[[[CLDTransformation alloc] init] setCustomFunction:[CLDCustomFunction remote:input]] setCustomPreFunction:[CLDCustomFunction remote:inputPre]];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "custom pre function should only be used when custom function is not set");
}
- (void)test_customFunctionCombinations_setBothWasmAndMultiParams_shouldReturnExpectedValue {
   
    // Given
    NSString* inputPre = @"preFunc";
    NSString* input    = @"func";
    
    NSString* expectedResult = @"fn_pre:wasm:preFunc,r_50,w_20,x_40";
    
    // When
    self.sut = [[[[[[[CLDTransformation alloc] init] setWidthWithInt:20] setCustomFunction:[CLDCustomFunction wasm:input]] setXFromInt:40] setCustomPreFunction:[CLDCustomFunction wasm:inputPre]] setRadiusFromInt:50];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "custom pre function should only be used when custom function is not set");
}
- (void)test_customFunctionCombinations_setBothRemoteAndMultiParams_shouldReturnExpectedValue {
   
    // Given
    NSString* inputPre = @"preFunc";
    NSString* input    = @"func";
    
    NSString* expectedResult = @"fn_pre:remote:cHJlRnVuYw==,r_50,w_20,x_40";
    
    // When
    self.sut = [[[[[[[CLDTransformation alloc] init] setWidthWithInt:20] setCustomFunction:[CLDCustomFunction remote:input]] setXFromInt:40] setCustomPreFunction:[CLDCustomFunction remote:inputPre]] setRadiusFromInt:50];
    NSString* actualResult = [self.sut asString];
    
    // Then
    XCTAssertEqualObjects(actualResult ,expectedResult, "custom pre function should only be used when custom function is not set");
}

@end
