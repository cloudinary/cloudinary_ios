//
//  UploaderTests.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 27/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "UploaderTests.h"

@interface UploaderTests () <CLUploaderDelegate> {
    NSString* error;
    NSDictionary* result;
    BOOL progress;
}
@end

@implementation UploaderTests

#define VerifyAPISecret() { \
  if ([[[cloudinary config] valueForKey:@"api_secret"] length] == 0) {\
    NSLog(@"Must setup api_secret to run this test."); \
    return; \
  }}

- (void)setUp
{
    [super setUp];
    cloudinary = [[CLCloudinary alloc] init];
    error = nil;
    result = nil;
}

- (void)tearDown
{
    [super tearDown];
}

- (NSString*) logo
{
    return [[NSBundle bundleWithIdentifier:@"com.cloudinary.CloudinaryTests"] pathForResource:@"logo" ofType:@"png"];
}

- (void)reset
{
    error = nil;
    result = nil;
}

- (void)waitForCompletion
{
    
    while (error == nil && result == nil)
    {
        NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runUntilDate:timeoutDate];
    }
    if (error != nil) {
        STFail(error);
    }
}

- (void)uploaderSuccess:(NSDictionary*)res context:(id)context
{
    result = res;
}

- (void)uploaderError:(NSString*)err code:(NSInteger) code context:(id)context
{
    error = err;
}

- (void) uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context
{
    NSLog(@"%d/%d (+%d)", totalBytesWritten, totalBytesExpectedToWrite, bytesWritten);
}

- (void)testUpload
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"colors": @YES}];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241], nil);
    STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51], nil);
    STAssertNotNil([result valueForKey:@"colors"], nil);
    STAssertNotNil([result valueForKey:@"predominant"], nil);

    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    STAssertEqualObjects([result valueForKey:@"signature"], expectedSignature, nil);
}

- (void)testUploadUrl
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:@"http://cloudinary.com/images/logo.png" options:@{}];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241], nil);
    STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51], nil);
    
    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    STAssertEqualObjects([result valueForKey:@"signature"], expectedSignature, nil);
}

- (void)testUploadDataUri
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:@"data:image/png;base64,iVBORw0KGgoAA\nAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAABlBMVEUAAAD///+l2Z/dAAAAM0l\nEQVR4nGP4/5/h/1+G/58ZDrAz3D/McH8yw83NDDeNGe4Ug9C9zwz3gVLMDA/A6\nP9/AFGGFyjOXZtQAAAAAElFTkSuQmCC" options:@{}];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:16], nil);
    STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:16], nil);
    
    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    STAssertEqualObjects([result valueForKey:@"signature"], expectedSignature, nil);
}

- (void)testRename
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{}];
    [self waitForCompletion];
    NSString* publicId = [result valueForKey:@"public_id"];
    [uploader rename:publicId toPublicId:[publicId stringByAppendingString:@"2"] options:@{}];

    [uploader upload:[self logo] options:@{}];
    [self waitForCompletion];
    NSString* publicId2 = [result valueForKey:@"public_id"];
    [uploader rename:[publicId stringByAppendingString:@"2"] toPublicId:publicId2 options:@{@"overwrite": @YES}];
}

- (void)testUseFilename
{
    VerifyAPISecret();
    NSError *reerror = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"logo_[a-z0-9]{6}" options:0 error:&reerror];
    
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"use_filename": @YES}];
    [self waitForCompletion];
    NSString *resultPublicId = [result valueForKey:@"public_id"];
    NSUInteger matches = [regex numberOfMatchesInString:resultPublicId options:0 range:NSMakeRange(0, resultPublicId.length)];
    NSUInteger expectedMatches = 1;
    STAssertEquals(matches, expectedMatches, Nil);
}

- (void)testUniqueFilename
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"use_filename": @YES, @"unique_filename": @"false"}];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"public_id"], @"logo", Nil);

}


- (void)testUploadWithBlock
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:nil];
    [uploader upload:[self logo] options:@{} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
        result = success;
        error = errorResult;
    } andProgress:nil];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241], nil);
    STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51], nil);
}

- (void)testUploadSync
{
    VerifyAPISecret();
    result = nil;
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:nil];
    NSOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
        [uploader upload:[self logo] options:@{@"sync": @YES} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
            result = success;
            error = errorResult;
        } andProgress:nil];
        STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241], nil);
        STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51], nil);
    } ];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [queue waitUntilAllOperationsAreFinished];
    STAssertNotNil(result, @"Result not found");
}

- (void)testUploadRunLoop
{
    VerifyAPISecret();
    result = nil;
    progress = false;
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:nil];
    NSOperation* operation = [NSBlockOperation blockOperationWithBlock:^{
        [uploader upload:[self logo] options:@{@"runLoop": @YES} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
            result = success;
            error = errorResult;
        } andProgress:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context) {
            progress = TRUE;
        }];
        [[NSRunLoop currentRunLoop] run];
        STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241], nil);
        STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51], nil);
    } ];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [queue waitUntilAllOperationsAreFinished];
    STAssertNotNil(result, @"Result not found");
    STAssertTrue(progress, @"Progress not called");
}

- (void)testUploadExternalSignature
{
    VerifyAPISecret();
    CLCloudinary* emptyCloudinary = [[CLCloudinary alloc] initWithUrl:@"cloudinary://a"];
    CLUploader* uploader = [[CLUploader alloc] init:emptyCloudinary delegate:self];
    NSDate *today = [NSDate date];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:(int) [today timeIntervalSince1970]] forKey:@"timestamp"];
    NSString* signature = [cloudinary apiSignRequest:params secret:[cloudinary.config valueForKey:@"api_secret"]];
    [params setValue:signature forKey:@"signature"];
    [params setValue:[cloudinary.config valueForKey:@"api_key"] forKey:@"api_key"];
    [params setValue:[cloudinary.config valueForKey:@"cloud_name"] forKey:@"cloud_name"];
    [uploader upload:[self logo] options:params];
    [self waitForCompletion];
}

- (void)testExplicit
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setCrop:@"scale"];
    [transformation setWidthWithFloat:2.0];
    [uploader explicit:@"cloudinary" options:@{@"eager": @[transformation], @"type": @"twitter_name"}];
    [self waitForCompletion];
    NSString* url = [cloudinary url:@"cloudinary" options:@{@"format": @"png", @"version":[result valueForKey:@"version"], @"type": @"twitter_name", @"transformation": transformation}];
    NSArray* derivedList = [result valueForKey:@"eager"];
    NSDictionary* derived = [derivedList objectAtIndex:0];
    
    STAssertEqualObjects([derived valueForKey:@"url"], url, nil);
}

- (void) testEager
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setCrop:@"scale"];
    [transformation setWidthWithFloat:2.0];
    [uploader upload:[self logo] options:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSArray arrayWithObject:transformation], @"eager",
                                               nil]];
    [self waitForCompletion];
    
}

- (void) testHeaders
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:[NSDictionary dictionaryWithObject:[NSArray arrayWithObject:@"Link: 1"]
                                                                           forKey:@"headers"]];
    [uploader upload:[self logo] options:[NSDictionary dictionaryWithObject:
                                                [NSDictionary dictionaryWithObject:@"1" forKey:@"Link"]
                                                                           forKey:@"headers"]];
    [self waitForCompletion];
}

- (void) testText
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader text:@"hello world" options:@{}];
    [self waitForCompletion];
    STAssertTrue([(NSNumber*)[result valueForKey:@"width"] integerValue] > 1, nil);
    STAssertTrue([(NSNumber*)[result valueForKey:@"height"] integerValue] > 1, nil);
}

- (void)testTags
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{}];
    [self waitForCompletion];
    NSString* publicId = [result valueForKey:@"public_id"];

    [self reset];
    [uploader upload:[self logo] options:@{}];
    [self waitForCompletion];
    NSString* publicId2 = [result valueForKey:@"public_id"];

    [self reset];
    [uploader addTag:@"tag1" publicIds: @[publicId, publicId2] options:@{}];
    [self waitForCompletion];
    NSArray* publicIds = [result valueForKey:@"public_ids"];
    NSArray* expectedPublicIds = @[publicId, publicId2];
    STAssertEqualObjects(publicIds, expectedPublicIds, @"changed public ids");
    [self reset];
    [uploader addTag:@"tag2" publicIds: @[publicId] options:@{}];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"public_ids"], @[publicId], @"changed public ids");
    [self reset];
    [uploader removeTag:@"tag2" publicIds: @[publicId] options:@{}];
    [self waitForCompletion];

    STAssertEqualObjects([result valueForKey:@"public_ids"], @[publicId], @"changed public ids");
    [self reset];
    [uploader replaceTag:@"tag3" publicIds: @[publicId] options:@{}];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"public_ids"], @[publicId], @"changed public ids");
}

- (void) testSprite
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"tags": @"sprite_test_tag", @"public_id" : @"sprite_test_tag_1"}];
    [self waitForCompletion];
    [self reset];
    
    [uploader upload:[self logo] options:@{@"tags": @"sprite_test_tag", @"public_id" : @"sprite_test_tag_2"}];
    [self waitForCompletion];
    [self reset];
    
    [uploader generateSprite:@"sprite_test_tag" options:@{}];
    [self waitForCompletion];
    
    NSDictionary* infos = (NSDictionary*) [result valueForKey:@"image_infos"];
    STAssertEquals(infos.allValues.count, (NSUInteger) 2, @"number of image infos");
    [self reset];
    
    [uploader generateSprite:@"sprite_test_tag" options:@{@"transformation": @"w_100"}];
    [self waitForCompletion];
    STAssertTrue([[result valueForKey:@"css_url"] rangeOfString:@"w_100"].location != NSNotFound, @"index of transformation string in css_url");
    [self reset];
    
    CLTransformation* transformation = [[CLTransformation alloc] init];
    [transformation setWidthWithInt: 100];
    [uploader generateSprite:@"sprite_test_tag" options:@{@"transformation": transformation, @"format": @"jpg"}];
    [self waitForCompletion];
    STAssertTrue([[result valueForKey:@"css_url"] rangeOfString:@"f_jpg,w_100"].location != NSNotFound, @"index of transformation string in css_url");
    [self reset];
}

- (void) testMulti
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"tags": @"multi_test_tag", @"public_id" : @"multi_test_tag_1"}];
    [self waitForCompletion];
    [self reset];
    
    [uploader upload:[self logo] options:@{@"tags": @"multi_test_tag", @"public_id" : @"multi_test_tag_2"}];
    [self waitForCompletion];
    [self reset];
    
    [uploader multi:@"multi_test_tag" options:@{}];
    [self waitForCompletion];
    NSString* url = (NSString*) [result valueForKey:@"url"];
    STAssertEquals([url rangeOfString:@".gif"].location, [url length] - 4 , @"index of .gif in url");
    [self reset];
    
    [uploader multi:@"multi_test_tag" options:@{@"transformation": @"w_100"}];
    [self waitForCompletion];
    url = (NSString*) [result valueForKey:@"url"];
    STAssertTrue([url rangeOfString:@"w_100"].location != NSNotFound, @"index of transformation string in url");
    [self reset];
    
    CLTransformation* transformation = [[CLTransformation alloc] init];
    [transformation setWidthWithInt: 111];
    [uploader multi:@"multi_test_tag" options:@{@"transformation": transformation, @"format": @"pdf"}];
    [self waitForCompletion];
    url = (NSString*) [result valueForKey:@"url"];
    STAssertTrue([url rangeOfString:@"w_111"].location != NSNotFound, @"index of transformation string in url");
    STAssertEquals([url rangeOfString:@".pdf"].location, [url length] - 4 , @"index of .pdf in url");
    [self reset];
}

- (void)testUploadSafeWithCallback
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            @"dummy callback", @"callback",
                            nil];
    NSDate *today = [NSDate date];
    [params setValue:@((int)[today timeIntervalSince1970])forKey:@"timestamp"];

    NSString* expectedSignature = [cloudinary apiSignRequest:params secret:[cloudinary.config valueForKey:@"api_secret"]];
    [params setValue:expectedSignature forKey:@"signature"];
    [params setValue:[cloudinary.config valueForKey:@"api_key"] forKey:@"api_key"];
    
    [uploader upload:[self logo] options:params];
    [self waitForCompletion];
    STAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241], nil);
    STAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51], nil);
}


@end
