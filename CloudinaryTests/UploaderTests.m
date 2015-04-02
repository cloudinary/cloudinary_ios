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

- (NSString*) docx
{
    return [[NSBundle bundleWithIdentifier:@"com.cloudinary.CloudinaryTests"] pathForResource:@"docx" ofType:@"docx"];
}


- (void)reset
{
    error = nil;
    result = nil;
}

- (void)waitForCompletionAllowError
{
    
    while (error == nil && result == nil)
    {
        NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:1];
        [[NSRunLoop currentRunLoop] runUntilDate:timeoutDate];
    }
}

- (void)waitForCompletion
{
    [self waitForCompletionAllowError];
    if (error != nil) {
        NSLog(@"%@", error);
        XCTFail();
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
    NSLog(@"%ld/%ld (+%ld)", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, (long)bytesWritten);
}

- (void)testUpload
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"colors": @YES}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
    XCTAssertNotNil([result valueForKey:@"colors"]);
    XCTAssertNotNil([result valueForKey:@"predominant"]);

    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    XCTAssertEqualObjects([result valueForKey:@"signature"], expectedSignature);
}

- (void)testUnsignedUpload
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader unsignedUpload:[self logo] uploadPreset:@"sample_preset_dhfjhriu" options:@{@"api_secret": @"wrong secret just for testing"}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
    
    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    XCTAssertEqualObjects([result valueForKey:@"signature"], expectedSignature);
}

- (void)testUploadUrl
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:@"http://cloudinary.com/images/old_logo.png" options:@{}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
    
    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    XCTAssertEqualObjects([result valueForKey:@"signature"], expectedSignature);
}

- (void)testUploadDataUri
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:@"data:image/png;base64,iVBORw0KGgoAA\nAANSUhEUgAAABAAAAAQAQMAAAAlPW0iAAAABlBMVEUAAAD///+l2Z/dAAAAM0l\nEQVR4nGP4/5/h/1+G/58ZDrAz3D/McH8yw83NDDeNGe4Ug9C9zwz3gVLMDA/A6\nP9/AFGGFyjOXZtQAAAAAElFTkSuQmCC" options:@{}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:16]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:16]);
    
    NSDictionary* toSign = [NSDictionary dictionaryWithObjectsAndKeys:
                            [result valueForKey:@"public_id"], @"public_id",
                            [result valueForKey:@"version"], @"version",
                            nil];
    NSString* expectedSignature = [cloudinary apiSignRequest:toSign secret:[cloudinary.config valueForKey:@"api_secret"]];
    XCTAssertEqualObjects([result valueForKey:@"signature"], expectedSignature);
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
    XCTAssertEqual(matches, expectedMatches);
}

- (void)testUniqueFilename
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"use_filename": @YES, @"unique_filename": @"false"}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"public_id"], @"logo");

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
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
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
        XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
        XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
    } ];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [queue waitUntilAllOperationsAreFinished];
    XCTAssertNotNil(result, @"Result not found");
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
        XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
        XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
    } ];
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    [queue waitUntilAllOperationsAreFinished];
    XCTAssertNotNil(result, @"Result not found");
    XCTAssertTrue(progress, @"Progress not called");
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
    NSString* preloadedImage = [cloudinary signedPreloadedImage:result];
    NSString* url = [cloudinary url:preloadedImage];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSError* nserror = nil;
    NSHTTPURLResponse* nsresponse = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&nsresponse error:&nserror];
    XCTAssertNil(nserror, @"Should not fail");
    XCTAssertEqual([nsresponse statusCode], 200);
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
    
    XCTAssertEqualObjects([derived valueForKey:@"url"], url);
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
    [uploader upload:[self logo] options:@{@"headers": @[@"Link: 1"]}];
    [uploader upload:[self logo] options:@{@"headers": @{@"Link": @"1"}, @"context": @{@"caption": @"My Logo"}}];

    [self waitForCompletion];
}

- (void) testFaceCoordinates
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"face_coordinates": @"10,10,100,100"}];
    [uploader upload:[self logo] options:@{@"face_coordinates": @[@[@"10", @"10",@"100",@"100"]]}];
    [uploader upload:[self logo] options:@{@"custom_coordinates":@[@"10", @"10",@"100",@"100"]}];
    
    [self waitForCompletion];
}

- (void) testText
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader text:@"hello world" options:@{}];
    [self waitForCompletion];
    XCTAssertTrue([(NSNumber*)[result valueForKey:@"width"] integerValue] > 1);
    XCTAssertTrue([(NSNumber*)[result valueForKey:@"height"] integerValue] > 1);
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
    NSArray* publicIds = [[result valueForKey:@"public_ids"] sortedArrayUsingSelector:@selector(compare:)];
    NSArray* expectedPublicIds = [@[publicId, publicId2] sortedArrayUsingSelector:@selector(compare:)];
    XCTAssertEqualObjects(publicIds, expectedPublicIds, @"changed public ids");
    [self reset];
    [uploader addTag:@"tag2" publicIds: @[publicId] options:@{}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"public_ids"], @[publicId], @"changed public ids");
    [self reset];
    [uploader removeTag:@"tag2" publicIds: @[publicId] options:@{}];
    [self waitForCompletion];

    XCTAssertEqualObjects([result valueForKey:@"public_ids"], @[publicId], @"changed public ids");
    [self reset];
    [uploader replaceTag:@"tag3" publicIds: @[publicId] options:@{}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"public_ids"], @[publicId], @"changed public ids");
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
    XCTAssertEqual(infos.allValues.count, (NSUInteger) 2, @"number of image infos");
    [self reset];
    
    [uploader generateSprite:@"sprite_test_tag" options:@{@"transformation": @"w_100"}];
    [self waitForCompletion];
    XCTAssertTrue([[result valueForKey:@"css_url"] rangeOfString:@"w_100"].location != NSNotFound, @"index of transformation string in css_url");
    [self reset];
    
    CLTransformation* transformation = [[CLTransformation alloc] init];
    [transformation setWidthWithInt: 100];
    [uploader generateSprite:@"sprite_test_tag" options:@{@"transformation": transformation, @"format": @"jpg"}];
    [self waitForCompletion];
    XCTAssertTrue([[result valueForKey:@"css_url"] rangeOfString:@"f_jpg,w_100"].location != NSNotFound, @"index of transformation string in css_url");
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
    XCTAssertEqual([url rangeOfString:@".gif"].location, [url length] - 4 , @"index of .gif in url");
    [self reset];
    
    [uploader multi:@"multi_test_tag" options:@{@"transformation": @"w_100"}];
    [self waitForCompletion];
    url = (NSString*) [result valueForKey:@"url"];
    XCTAssertTrue([url rangeOfString:@"w_100"].location != NSNotFound, @"index of transformation string in url");
    [self reset];
    
    CLTransformation* transformation = [[CLTransformation alloc] init];
    [transformation setWidthWithInt: 111];
    [uploader multi:@"multi_test_tag" options:@{@"transformation": transformation, @"format": @"pdf"}];
    [self waitForCompletion];
    url = (NSString*) [result valueForKey:@"url"];
    XCTAssertTrue([url rangeOfString:@"w_111"].location != NSNotFound, @"index of transformation string in url");
    XCTAssertEqual([url rangeOfString:@".pdf"].location, [url length] - 4 , @"index of .pdf in url");
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
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
}

- (void)testManualModeration
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"moderation": @"manual"}];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"width"], [NSNumber numberWithInt:241]);
    XCTAssertEqualObjects([result valueForKey:@"height"], [NSNumber numberWithInt:51]);
    NSDictionary* moderation = [result valueForKey:@"moderation"][0];
    XCTAssertEqualObjects([moderation valueForKey:@"status"], @"pending");
    XCTAssertEqualObjects([moderation valueForKey:@"kind"], @"manual");
}

- (void)testRawConversion
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self docx] options:@{@"raw_convert": @"illegal", @"resource_type": @"raw"}];
    [self waitForCompletionAllowError];
    XCTAssertTrue([error rangeOfString:@"illegal is not a valid" options:NSRegularExpressionSearch].location != NSNotFound);
}

- (void)testCategorization
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"categorization": @"illegal"}];
    [self waitForCompletionAllowError];
    XCTAssertTrue([error rangeOfString:@"illegal is not a valid" options:NSRegularExpressionSearch].location != NSNotFound);
}

- (void)testDetection
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"detection": @"illegal"}];
    [self waitForCompletionAllowError];
    XCTAssertTrue([error rangeOfString:@"illegal is not a valid" options:NSRegularExpressionSearch].location != NSNotFound);
}

- (void)testAutoTagging
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"auto_tagging": @0.5}];
    [self waitForCompletionAllowError];
    XCTAssertTrue([error rangeOfString:@"^Must use.*" options:NSRegularExpressionSearch].location != NSNotFound);
}

- (void)testDeleteByToken
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:nil];
    [uploader upload:[self logo] options:@{@"return_delete_token": @true} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
        result = success;
        error = errorResult;
    } andProgress:nil];
    [self waitForCompletion];
    NSString* delete_token = [result valueForKey:@"delete_token"];
    XCTAssertNotNil(delete_token);
    result = nil;
    [uploader deleteByToken:delete_token options:@{} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
        result = success;
        error = errorResult;
    }];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"result"], @"ok");
}

- (void)testRaw
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:nil];
    [uploader upload:[self logo] options:@{@"resource_type": @"raw"} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
        result = success;
        error = errorResult;
    } andProgress:nil];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"resource_type"], @"raw");
    NSString* publicId = [result valueForKey:@"public_id"];
    result = nil;
    [uploader destroy:publicId options:@{@"resource_type": @"raw"} withCompletion:^(NSDictionary *success, NSString *errorResult, NSInteger code, id context) {
        result = success;
        error = errorResult;
    } andProgress:nil];
    [self waitForCompletion];
    XCTAssertEqualObjects([result valueForKey:@"result"], @"ok");
}

- (void)testTimeout
{
    VerifyAPISecret();
    CLUploader* uploader = [[CLUploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:@{@"timeout": @(0.01)}];
    [self waitForCompletionAllowError];
    XCTAssertTrue([error rangeOfString:@"request timed out" options:NSRegularExpressionSearch].location != NSNotFound);
}

@end
