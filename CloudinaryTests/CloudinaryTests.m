//
//  CloudinaryTests.m
//  CloudinaryTests
//
//  Created by Tal Lev-Ami on 24/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "CloudinaryTests.h"

@implementation CloudinaryTests

- (void)setUp
{
    [super setUp];
    cloudinary = [[CLCloudinary alloc] initWithUrl:@"cloudinary://a:b@test123"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testParseCloudinaryUrlNoPrivateCdn
{
    CLCloudinary *cloudinary2 = [[CLCloudinary alloc] initWithUrl:@"cloudinary://abc:def@ghi"];
    NSDictionary *config = [cloudinary2 config];
    STAssertEqualObjects([config valueForKey:@"api_key"], @"abc", nil);
    STAssertEqualObjects([config valueForKey:@"api_secret"], @"def", nil);
    STAssertEqualObjects([config valueForKey:@"cloud_name"], @"ghi", nil);
    STAssertEqualObjects([config valueForKey:@"private_cdn"], [NSNumber numberWithBool:NO], nil);
}

- (void)testParseCloudinaryUrlWithPrivateCdn
{
    CLCloudinary *cloudinary2 = [[CLCloudinary alloc] initWithUrl:@"cloudinary://abc:def@ghi/jkl"];
    NSDictionary *config = [cloudinary2 config];
    STAssertEqualObjects([config valueForKey:@"api_key"], @"abc", nil);
    STAssertEqualObjects([config valueForKey:@"api_secret"], @"def", nil);
    STAssertEqualObjects([config valueForKey:@"cloud_name"], @"ghi", nil);
    STAssertEqualObjects([config valueForKey:@"private_cdn"], [NSNumber numberWithBool:YES], nil);
    STAssertEqualObjects([config valueForKey:@"secure_distribution"], @"jkl", nil);
}

- (void)testCloudName {
    // should use cloud_name from config
    NSString* result = [cloudinary url:@"test"];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/test", result, nil);
}


- (void)testCloudNameOptions {
    // should allow overriding cloud_name in options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"test321" forKey:@"cloud_name"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test321/image/upload/test", result, nil);
}

- (void)testSecureDistribution {
    // should use default secure distribution if secure=TRUE
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"secure"]];
    STAssertEqualObjects(@"https://res.cloudinary.com/test123/image/upload/test", result, nil);
}

- (void)testSecureDistributionOverwrite {
    // should allow overwriting secure distribution if secure=TRUE
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"secure",
                                                         @"something.else.com", @"secure_distribution", nil]];
    STAssertEqualObjects(@"https://something.else.com/test123/image/upload/test", result, nil);
}

- (void)testSecureDistibution {
    // should take secure distribution from config if secure=TRUE
    [cloudinary.config setValue:@"config.secure.distribution.com" forKey:@"secure_distribution"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"secure"]];
    STAssertEqualObjects(@"https://config.secure.distribution.com/test123/image/upload/test", result, nil);
}

- (void)testSecureAkamai {
    // should default to akamai if secure is given with private_cdn and no secure_distribution
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"secure", [NSNumber numberWithBool:YES], @"private_cdn", nil]];
    STAssertEqualObjects(@"https://test123-res.cloudinary.com/image/upload/test", result, nil);
}

- (void)testSecureNonAkamai {
    // should not add cloud_name if private_cdn and secure non akamai secure_distribution
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"secure", [NSNumber numberWithBool:YES], @"private_cdn", @"something.cloudfront.net", @"secure_distribution", nil]];
    STAssertEqualObjects(@"https://something.cloudfront.net/image/upload/test", result, nil);
}

- (void)testHttpPrivateCdn {
    // should not add cloud_name if private_cdn and not secure
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"private_cdn", nil]];
    STAssertEqualObjects(@"http://test123-res.cloudinary.com/image/upload/test", result, nil);
}

- (void)testFormat {
    // should use format from options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"jpg" forKey:@"format"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/test.jpg", result, nil);
}


- (void)testCrop {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setWidthWithInt:100];
    [transformation setHeightWithInt:101];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/h_101,w_100/test", result, nil);
    STAssertEqualObjects(@"101", transformation.htmlHeight, nil);
    STAssertEqualObjects(@"100", transformation.htmlWidth, nil);
    transformation = [CLTransformation transformation];
    [transformation setWidth:[NSNumber numberWithInt:100]];
    [transformation setHeight:[NSNumber numberWithInt:101]];
    [transformation setCrop:@"crop"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_crop,h_101,w_100/test", result, nil);
}


- (void)testVariousOptions {
    // should use x, y, radius, prefix, gravity and quality from options
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setXWithInt:1];
    [transformation setYWithInt:2];
    [transformation setRadiusWithInt:3];
    [transformation setGravity:@"center"];
    [transformation setQualityWithFloat:0.4];
    [transformation setPrefix:@"a"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/g_center,p_a,q_0.4,r_3,x_1,y_2/test", result, nil);
}


- (void)testTransformationSimple {
    // should support named transformation
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setNamed:@"blip"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/t_blip/test", result, nil);
}


- (void)testTransformationArray {
    // should support array of named transformations
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setNamed:[NSArray arrayWithObjects:@"blip", @"blop",nil]];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/t_blip.blop/test", result, nil);
}


- (void)testBaseTransformations {
    // should support base transformation
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setXWithInt:100];
    [transformation setYWithInt:100];
    [transformation setCrop:@"fill"];
    [transformation chain];
    [transformation setCrop:@"crop"];
    [transformation setWidthWithInt:100];

    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"100", transformation.htmlWidth, nil);
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_fill,x_100,y_100/c_crop,w_100/test", result, nil);
}


- (void)testBaseTransformationArray {
    // should support array of base transformations
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setXWithInt:100];
    [transformation setYWithInt:100];
    [transformation setWidthWithInt:200];
    [transformation setCrop:@"fill"];
    [transformation chain];
    [transformation setRadiusWithInt:10];
    [transformation chain];
    [transformation setCrop:@"crop"];
    [transformation setWidthWithInt:100];

    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"100", transformation.htmlWidth, nil);
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_fill,w_200,x_100,y_100/r_10/c_crop,w_100/test", result, nil);
}


- (void)testNoEmptyTransformation {
    // should not include empty transformations
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setXWithInt:100];
    [transformation setYWithInt:100];
    [transformation setCrop:@"fill"];
    [transformation chain];

    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_fill,x_100,y_100/test", result, nil);
}


- (void)testType {
    // should use type from options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"facebook" forKey:@"type"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/facebook/test", result, nil);
}


- (void)testResourceType {
    // should use resource_type from options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"raw" forKey:@"resource_type"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/raw/upload/test", result, nil);
}


- (void)testIgnoreHttp {
    // should ignore http links only if type is not given or is asset
    NSString* result = [cloudinary url:@"http://test"];
    STAssertEqualObjects(@"http://test", result, nil);
    result = [cloudinary url:@"http://test" options:[NSDictionary dictionaryWithObject:@"asset" forKey:@"type"]];
    STAssertEqualObjects(@"http://test", result, nil);
    result = [cloudinary url:@"http://test" options:[NSDictionary dictionaryWithObject:@"fetch" forKey:@"type"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/fetch/http://test", result, nil);
}


- (void)testFetch {
    // should escape fetch urls
    NSString* result = [cloudinary url:@"http://blah.com/hello?a=b" options:[NSDictionary dictionaryWithObject:@"fetch" forKey:@"type"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/fetch/http://blah.com/hello%3Fa%3Db", result, nil);
}


- (void)testCname {
    // should support extenal cname
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"hello.com" forKey:@"cname"]];
    STAssertEqualObjects(@"http://hello.com/test123/image/upload/test", result, nil);
}


- (void)testCnameSubdomain {
    // should support extenal cname with cdn_subdomain on
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:@"hello.com", @"cname", [NSNumber numberWithInt:YES], @"cdn_subdomain", nil]];
    STAssertEqualObjects(@"http://a2.hello.com/test123/image/upload/test", result, nil);
}


- (void)testHttpEscape {
    // should escape http urls
    NSString* result = [cloudinary url:@"http://www.youtube.com/watch?v=d9NF2edxy-M" options:[NSDictionary dictionaryWithObject:@"youtube" forKey:@"type"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/youtube/http://www.youtube.com/watch%3Fv%3Dd9NF2edxy-M", result, nil);
}


- (void)testBackground {
    // should support background
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setBackground:@"red"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/b_red/test", result, nil);
    transformation = [CLTransformation transformation];
    [transformation setBackground:@"#112233"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/b_rgb:112233/test", result, nil);
}


- (void)testDefaultImage {
    // should support default_image
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setDefaultImage:@"default"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/d_default/test", result, nil);
}


- (void)testAngle {
    // should support angle
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAngleWithInt:12]; 
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/a_12/test", result, nil);
    transformation = [CLTransformation transformation];
    [transformation setAngle:[NSArray arrayWithObjects:@"exif", @"12", nil]];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/a_exif.12/test", result, nil);
}


- (void)testOverlay {
    // should support overlay
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setOverlay:@"text:hello"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/l_text:hello/test", result, nil);
    // should not pass width/height to html if overlay
    transformation = [CLTransformation transformation];
    [transformation setOverlay:@"text:hello"];
    [transformation setWidth:@"100"];
    [transformation setHeight:@"100"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertNil(transformation.htmlHeight, nil);
    STAssertNil(transformation.htmlWidth, nil);
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/h_100,l_text:hello,w_100/test", result, nil);
}


- (void)testUnderlay {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setUnderlay:@"text:hello"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/u_text:hello/test", result, nil);
    // should not pass width/height to html if overlay
    transformation = [CLTransformation transformation];
    [transformation setUnderlay:@"text:hello"];
    [transformation setWidth:@"100"];
    [transformation setHeight:@"100"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertNil(transformation.htmlHeight, nil);
    STAssertNil(transformation.htmlWidth, nil);
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/h_100,u_text:hello,w_100/test", result, nil);
}


- (void)testFetchFormat {
    // should support format for fetch urls
    NSString* result = [cloudinary url:@"http://cloudinary.com/images/logo.png" options:[NSDictionary dictionaryWithObjectsAndKeys:@"fetch", @"type", @"jpg", @"format", nil]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/fetch/f_jpg/http://cloudinary.com/images/logo.png", result, nil);
}


- (void)testEffect {
    // should support effect
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setEffect:@"sepia"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/e_sepia/test", result, nil);
}


- (void)testEffectWithParam {
    // should support effect with param
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setEffect:@"sepia" param:[NSNumber numberWithInt:10]];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/e_sepia:10/test", result, nil);
}


- (void)testDensity {
    // should support density
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setDensityWithInt:150];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/dn_150/test", result, nil);
}


- (void)testPage {
    // should support page
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setPageWithInt:5];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/pg_5/test", result, nil);
}


- (void)testBorder {
    // should support border
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setBorder:5 color:@"black"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/bo_5px_solid_black/test", result, nil);
    transformation = [CLTransformation transformation];
    [transformation setBorder:5 color:@"#ffaabbdd"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/bo_5px_solid_rgb:ffaabbdd/test", result, nil);
    transformation = [CLTransformation transformation];
    [transformation setBorder:@"1px_solid_blue"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/bo_1px_solid_blue/test", result, nil);
}


- (void)testFlags {
    // should support flags
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setFlags:@"abc"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/fl_abc/test", result, nil);
    transformation = [CLTransformation transformation];
    [transformation setFlags:[NSArray arrayWithObjects:@"abc", @"def", nil]];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/fl_abc.def/test", result, nil);
}


- (void)testImageTag {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setWidthWithInt:100];
    [transformation setHeightWithInt:101];
    [transformation setCrop:@"crop"];
    
    NSString* result = [cloudinary imageTag:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"] htmlOptions:[NSDictionary dictionaryWithObject:@"my image" forKey:@"alt"]];
    STAssertEqualObjects(@"<img src='http://res.cloudinary.com/test123/image/upload/c_crop,h_101,w_100/test' alt='my image' width='100' height='101'/>", result, nil);
}

- (void)testSignature {
    NSString* sig = [cloudinary apiSignRequest:[NSDictionary dictionaryWithObjectsAndKeys:@"b", @"a", @"d", @"c", @"", @"e", nil] secret:@"abcd"];
    STAssertEqualObjects(sig, @"ef1f04e0c1af08208a3dd28483107bc7f4a61209", nil);
}

- (void)testFolders {
    // should add version if public_id contains /
    NSString* result = [cloudinary url:@"folder/test" options:@{}];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/v1/folder/test", result, nil);
    result = [cloudinary url:@"folder/test" options:@{@"version": @"123"}];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/v123/folder/test", result, nil);
}

- (void)testFoldersWithVersion {
    // should not add version if public_id contains version already
    NSString* result = [cloudinary url:@"v1234/test" options:@{}];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/v1234/test", result, nil);
}

- (void)testShorten {
    // should allow to shorted image/upload urls
    NSString* result = [cloudinary url:@"test" options:@{@"shorten": @YES}];
    STAssertEqualObjects(@"http://res.cloudinary.com/test123/iu/test", result, nil);
}

- (void) testEscapePublicId {
    // should escape public_ids
    NSDictionary* tests = @{
                   @"a b": @"a%20b",
                   @"a+b": @"a%2Bb",
                   @"a%20b": @"a%20b",
                   @"a-b": @"a-b",
                   @"a??b": @"a%3F%3Fb"};
    for(NSString* source in tests) {
        NSString* result = [cloudinary url:source options:@{}];
        NSString* target = [tests valueForKey:source];
        NSString* expected = [NSString stringWithFormat:@"http://res.cloudinary.com/test123/image/upload/%@", target];
        STAssertEqualObjects(expected, result, nil);
    }
}

@end
