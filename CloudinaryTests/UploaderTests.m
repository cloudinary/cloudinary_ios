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

@end
