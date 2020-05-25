//
//  ObjcCLDVariableTests.m
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

@interface ObjcCLDVariableTests : XCTestCase

@end

@implementation ObjcCLDVariableTests

CLDVariable *sut;

// MARK: - setup and teardown
- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
    sut = nil;
}

// MARK: - test initilization methods - empty
- (void)test_init_emptyInputParamaters_shouldStoreEmptyProperties {
        
    // Given
    NSString *name = [NSString string];
    
    // When
    sut = [[CLDVariable alloc] init];
    
    // Then
    XCTAssertNotNil(sut.name, "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should contain a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: [NSString string]], "Initilized object should contain an empty string as value property");
    XCTAssertFalse([sut.name isEqualToString: name], "Name property should contain \"\(CLDVariable.variableNamePrefix)\" prefix");
}

// MARK: - test initilization methods - value
-(void)test_init_emptyNameParamater_shouldStoreEmptyNameProperty {
    
    // Given
    NSString *name  = [NSString string];
    NSString *value = @"alue";
    
    // When
    sut = [[CLDVariable alloc] initWithName:name stringValue:value];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should contain a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: value], "Initilized object should contain an empty string as value property");
}
-(void)test_init_validStringParamatersAndNoNamePrefix_shouldStoreValidProperties {
    
    // Given
    NSString *name  = @"name";
    NSString *value = @"alue";
    
    // When
    sut = [[CLDVariable alloc] initWithName:name stringValue:value];

    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: value], "Initilized object should contain a string as value property");
}
-(void)test_init_validStringParamaters_shouldStoreValidProperties {
    
    // Given
    NSString *name  = @"$foo";
    NSString *value = @"alue";
   
    // When
    sut = [[CLDVariable alloc] initWithName:name stringValue:value];

    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: name], "Initilized object should contain a string as name property");
    XCTAssertTrue([sut.value isEqualToString: value], "Initilized object should contain a string as value property");
}
-(void)test_init_emptyNameParamaterIntValue_shouldStoreEmptyNameProperty {
    
    // Given
    NSString *name  = [NSString string];
    int value = 4;
    NSString* valueAsString = [@(value) stringValue];
    
    // When
    sut = [[CLDVariable alloc] initWithName:name intValue:value];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: valueAsString], "Initilized object should contain a string as value property");
}
-(void)test_init_validIntValue_shouldStoreValidProperties {
    
    // Given
    NSString *name  = @"name";
    int value = 4;
    NSString* valueAsString = [@(value) stringValue];
    
    // When
    sut = [[CLDVariable alloc] initWithName:name intValue:value];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: valueAsString], "Initilized object should contain a string as value property");
}
-(void)test_init_emptyNameParamaterDoubleValue_shouldStoreEmptyNameProperty {
    
    // Given
    NSString *name  = [NSString string];
    double value = 3.14;
    NSString* valueAsString = [@(value) stringValue];
    
    // When
    sut = [[CLDVariable alloc] initWithName:name doubleValue:value];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: valueAsString], "Initilized object should contain a string as value property");
}
-(void)test_init_validDoubleValue_shouldStoreValidProperties {
    
    // Given
    NSString *name = @"name";
    double value = 3.14;
    NSString* valueAsString = [@(value) stringValue];
    
    // When
    sut = [[CLDVariable alloc] initWithName:name doubleValue:value];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: valueAsString], "Initilized object should contain a string as value property");
}

// MARK: - test initilization methods - values
-(void)test_initWithValuesArray_emptyInputParamaters_shouldStoreEmptyProperties {
    
    // Given
    NSString *name = [NSString string];
    NSArray *values = @[];
    
    // When
    sut = [[CLDVariable alloc] initWithName:name values:values];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: [NSString string]], "Initilized object should contain a string as value property");
}
-(void)test_initWithValuesArray_emptyValueParamater_shouldStoreEmptyValueProperty {
    
    // Given
    NSString *name = @"name";
    NSArray *values = @[];
    
    // When
    sut = [[CLDVariable alloc] initWithName:name values:values];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: [NSString string]], "Initilized object should contain a string as value property");
}
-(void)test_initWithValuesArray_validOneValueArray_shouldStoreValidProperties {
    
    // Given
    NSString *name = @"name";
    NSArray *values = @[@"my"];
    NSString *expectedResult = @"!my!";
    
    // When
    sut = [[CLDVariable alloc] initWithName:name values:values];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: expectedResult], "Initilized object should contain a string as value property");
}
-(void)test_initWithValuesArray_validTwoValueArray_shouldStoreValidProperties {
    
    // Given
    NSString *name = @"name";
    NSArray *values = @[@"my",@"str"];
    NSString *expectedResult = @"!my:str!";
    
    // When
    sut = [[CLDVariable alloc] initWithName:name values:values];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: expectedResult], "Initilized object should contain a string as value property");
}
-(void)test_initWithValuesArray_validThreeValuesArray_shouldStoreValidProperties {
    
    // Given
    NSString *name = @"name";
    NSArray *values = @[@"my",@"str",@"ing"];
    NSString *expectedResult = @"!my:str:ing!";
    
    // When
    sut = [[CLDVariable alloc] initWithName:name values:values];
    
    // Then
    XCTAssertNotNil(sut.name , "Initilized object should contain a none nil name  property");
    XCTAssertNotNil(sut.value, "Initilized object should contain a none nil value property");
    
    XCTAssertTrue([sut.name isEqualToString: [CLDVariable.variableNamePrefix stringByAppendingString:name]], "Name property should have a valid prefix");
    XCTAssertTrue([sut.value isEqualToString: expectedResult], "Initilized object should contain a string as value property");
}

@end
