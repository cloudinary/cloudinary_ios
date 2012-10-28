//
//  UploaderTests.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 27/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "UploaderTests.h"
#import "Uploader.h"
#import "Transformation.h"

@interface UploaderTests () {
    NSString* error;
    NSDictionary* result;
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
    cloudinary = [[Cloudinary alloc] init];
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

- (void)success:(NSDictionary*)res
{
    result = res;
}

- (void)error:(NSString*)err
{
    error = err;
}

- (void)testUpload
{
    VerifyAPISecret();
    Uploader* uploader = [[Uploader alloc] init:cloudinary delegate:self];
    [uploader upload:[self logo] options:[NSDictionary dictionary]];
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

- (void)testExplicit
{
    VerifyAPISecret();
    Uploader* uploader = [[Uploader alloc] init:cloudinary delegate:self];
    Transformation* transformation = [Transformation transformation];
    [transformation crop:@"scale"];
    [transformation fwidth:2.0];
    [uploader explicit:@"cloudinary" options:[NSDictionary dictionaryWithObjectsAndKeys:
                                              [NSArray arrayWithObject:transformation], @"eager",
                                              @"twitter_name", @"type"
                                              , nil]];
    [self waitForCompletion];
    NSString* url = [cloudinary url:@"cloudinary" options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"png", @"format",
                                                           [result valueForKey:@"version"], @"version",
                                                           @"twitter_name", @"type",
                                                           transformation, @"transformation",
                                                           nil]];
    NSArray* derivedList = [result valueForKey:@"eager"];
    NSDictionary* derived = [derivedList objectAtIndex:0];
    
    STAssertEqualObjects([derived valueForKey:@"url"], url, nil);
}

- (void) testEager
{
    VerifyAPISecret();
    Uploader* uploader = [[Uploader alloc] init:cloudinary delegate:self];
    Transformation* transformation = [Transformation transformation];
    [transformation crop:@"scale"];
    [transformation fwidth:2.0];
    [uploader upload:[self logo] options:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSArray arrayWithObject:transformation], @"eager",
                                               nil]];
    [self waitForCompletion];
    
}

- (void) testHeaders
{
    VerifyAPISecret();
    Uploader* uploader = [[Uploader alloc] init:cloudinary delegate:self];
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
    Uploader* uploader = [[Uploader alloc] init:cloudinary delegate:self];
    [uploader text:@"hello world" options:[NSDictionary dictionary]];
    [self waitForCompletion];
    STAssertTrue([(NSNumber*)[result valueForKey:@"width"] integerValue] > 1, nil);
    STAssertTrue([(NSNumber*)[result valueForKey:@"height"] integerValue] > 1, nil);
}

@end
