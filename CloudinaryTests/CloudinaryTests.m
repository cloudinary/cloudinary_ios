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
    XCTAssertEqualObjects([config valueForKey:@"api_key"], @"abc");
    XCTAssertEqualObjects([config valueForKey:@"api_secret"], @"def");
    XCTAssertEqualObjects([config valueForKey:@"cloud_name"], @"ghi");
    XCTAssertEqualObjects([config valueForKey:@"private_cdn"], @NO);
}

- (void)testParseCloudinaryUrlWithPrivateCdn
{
    CLCloudinary *cloudinary2 = [[CLCloudinary alloc] initWithUrl:@"cloudinary://abc:def@ghi/jkl"];
    NSDictionary *config = [cloudinary2 config];
    XCTAssertEqualObjects([config valueForKey:@"api_key"], @"abc");
    XCTAssertEqualObjects([config valueForKey:@"api_secret"], @"def");
    XCTAssertEqualObjects([config valueForKey:@"cloud_name"], @"ghi");
    XCTAssertEqualObjects([config valueForKey:@"private_cdn"], @YES);
    XCTAssertEqualObjects([config valueForKey:@"secure_distribution"], @"jkl");
}

- (void)testCloudName {
    // should use cloud_name from config
    NSString* result = [cloudinary url:@"test"];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/test", result);
}


- (void)testCloudNameOptions {
    // should allow overriding cloud_name in options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"test321" forKey:@"cloud_name"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test321/image/upload/test", result);
}

- (void)testSecureDistribution {
    // should use default secure distribution if secure=TRUE
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@YES forKey:@"secure"]];
    XCTAssertEqualObjects(@"https://res.cloudinary.com/test123/image/upload/test", result);
}

- (void)testSecureDistributionOverwrite {
    // should allow overwriting secure distribution if secure=TRUE
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"secure",
                                                         @"something.else.com", @"secure_distribution", nil]];
    XCTAssertEqualObjects(@"https://something.else.com/test123/image/upload/test", result);
}

- (void)testSecureDistibution {
    // should take secure distribution from config if secure=TRUE
    [cloudinary.config setValue:@"config.secure.distribution.com" forKey:@"secure_distribution"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@YES forKey:@"secure"]];
    XCTAssertEqualObjects(@"https://config.secure.distribution.com/test123/image/upload/test", result);
}

- (void)testSecureAkamai {
    // should default to akamai if secure is given with private_cdn and no secure_distribution
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"secure", @YES, @"private_cdn", nil]];
    XCTAssertEqualObjects(@"https://test123-res.cloudinary.com/image/upload/test", result);
}

- (void)testSecureNonAkamai {
    // should not add cloud_name if private_cdn and secure non akamai secure_distribution
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"secure", @YES, @"private_cdn", @"something.cloudfront.net", @"secure_distribution", nil]];
    XCTAssertEqualObjects(@"https://something.cloudfront.net/image/upload/test", result);
}

- (void)testHttpPrivateCdn {
    // should not add cloud_name if private_cdn and not secure
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:@YES, @"private_cdn", nil]];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/image/upload/test", result);
}

- (void)testCdnSubDomain {
    // should support new cdn_subdomain format
    NSString* result = [cloudinary url:@"test" options:@{@"cdn_subdomain": @YES}];
    XCTAssertEqualObjects(@"http://res-2.cloudinary.com/test123/image/upload/test", result);
}

- (void)testSecureCdnSubDomainFalse {
    // should support secure_cdn_subdomain false override with secure
    NSString* result = [cloudinary url:@"test" options:@{@"cdn_subdomain": @YES, @"secure": @YES, @"secure_cdn_subdomain": @NO}];
    XCTAssertEqualObjects(@"https://res.cloudinary.com/test123/image/upload/test", result);
}

- (void)testSecureCdnSubDomainTrue {
    // should support secure_cdn_subdomain true override with secure
    NSString* result = [cloudinary url:@"test" options:@{@"cdn_subdomain": @YES, @"secure": @YES, @"secure_cdn_subdomain": @YES, @"private_cdn": @YES}];
    XCTAssertEqualObjects(@"https://test123-res-2.cloudinary.com/image/upload/test", result);
}

- (void)testFormat {
    // should use format from options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"jpg" forKey:@"format"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/test.jpg", result);
}


- (void)testCrop {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setWidthWithInt:100];
    [transformation setHeightWithInt:101];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/h_101,w_100/test", result);
    XCTAssertEqualObjects(@"101", transformation.htmlHeight);
    XCTAssertEqualObjects(@"100", transformation.htmlWidth);
    transformation = [CLTransformation transformation];
    [transformation setWidth:[NSNumber numberWithInt:100]];
    [transformation setHeight:[NSNumber numberWithInt:101]];
    [transformation setCrop:@"crop"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_crop,h_101,w_100/test", result);
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
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/g_center,p_a,q_0.4,r_3,x_1,y_2/test", result);
}


- (void)testTransformationSimple {
    // should support named transformation
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setNamed:@"blip"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/t_blip/test", result);
}


- (void)testTransformationArray {
    // should support array of named transformations
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setNamed:[NSArray arrayWithObjects:@"blip", @"blop",nil]];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/t_blip.blop/test", result);
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
    XCTAssertEqualObjects(@"100", transformation.htmlWidth);
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_fill,x_100,y_100/c_crop,w_100/test", result);
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
    XCTAssertEqualObjects(@"100", transformation.htmlWidth);
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_fill,w_200,x_100,y_100/r_10/c_crop,w_100/test", result);
}


- (void)testNoEmptyTransformation {
    // should not include empty transformations
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setXWithInt:100];
    [transformation setYWithInt:100];
    [transformation setCrop:@"fill"];
    [transformation chain];

    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/c_fill,x_100,y_100/test", result);
}


- (void)testType {
    // should use type from options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"facebook" forKey:@"type"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/facebook/test", result);
}


- (void)testResourceType {
    // should use resource_type from options
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"raw" forKey:@"resource_type"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/raw/upload/test", result);
}

- (void)testFetch {
    // should escape fetch urls
    NSString* result = [cloudinary url:@"http://blah.com/hello?a=b" options:[NSDictionary dictionaryWithObject:@"fetch" forKey:@"type"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/fetch/http://blah.com/hello%3Fa%3Db", result);
}


- (void)testCname {
    // should support extenal cname
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:@"hello.com" forKey:@"cname"]];
    XCTAssertEqualObjects(@"http://hello.com/test123/image/upload/test", result);
}


- (void)testCnameSubdomain {
    // should support extenal cname with cdn_subdomain on
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObjectsAndKeys:@"hello.com", @"cname", [NSNumber numberWithInt:YES], @"cdn_subdomain", nil]];
    XCTAssertEqualObjects(@"http://a2.hello.com/test123/image/upload/test", result);
}

- (void)testUrlSuffixShared {
    // should disallow url_suffix in shared distribution
    XCTAssertThrows([cloudinary url:@"test" options:@{@"url_suffix": @"hello"}]);
}

- (void)testUrlSuffixNonUpload {
    // should disallow url_suffix for non upload types
    NSDictionary* options = @{@"url_suffix": @"hello", @"private_cdn": @YES, @"type": @"facebook"};
    XCTAssertThrows([cloudinary url:@"test" options:options]);
}

- (void)testUrlSuffixDisallowedChars {
    // should disallow url_suffix with / or .
    NSDictionary* options = @{@"url_suffix": @"hello/world", @"private_cdn": @YES};
    XCTAssertThrows([cloudinary url:@"test" options:options]);
    options = @{@"url_suffix": @"hello.world", @"private_cdn": @YES};
    XCTAssertThrows([cloudinary url:@"test" options:options]);
}

- (void)testUrlSuffixPrivateCdn {
    // should support url_suffix for private_cdn
    NSString* result = [cloudinary url:@"test" options:@{@"url_suffix": @"hello", @"private_cdn": @YES}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/images/test/hello", result);
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAngleWithInt:0];
    result = [cloudinary url:@"test" options:@{@"url_suffix": @"hello", @"private_cdn": @YES, @"transformation": transformation}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/images/a_0/test/hello", result);
}

- (void)testUrlSuffixFormat {
    // should put format after url_suffix
    NSString* result = [cloudinary url:@"test" options:@{@"url_suffix": @"hello", @"private_cdn": @YES, @"format": @"jpg"}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/images/test/hello.jpg", result);
}

- (void)testUrlSuffixSign {
    // should not sign the url_suffix
    NSString* result = [cloudinary url:@"test" options:@{@"sign_url": @YES, @"format": @"jpg"}];
    NSString* signature1 = [result componentsSeparatedByString:@"--"][1];
    
    result = [cloudinary url:@"test" options:@{@"url_suffix": @"hello", @"private_cdn": @YES, @"format": @"jpg", @"sign_url": @YES}];
    NSString* signature2 = [result componentsSeparatedByString:@"--"][1];
    
    XCTAssertEqualObjects(signature1, signature2);

    result = [cloudinary url:@"test" options:@{@"sign_url": @YES, @"format": @"jpg", @"angle": @0}];
    signature1 = [result componentsSeparatedByString:@"--"][1];
    
    result = [cloudinary url:@"test" options:@{@"url_suffix": @"hello", @"private_cdn": @YES, @"format": @"jpg", @"angle": @0, @"sign_url": @YES}];
    signature2 = [result componentsSeparatedByString:@"--"][1];
    
    XCTAssertEqualObjects(signature1, signature2);
}

- (void)testUrlSuffixRaw {
    // should support url_suffix for raw uploads
    NSString* result = [cloudinary url:@"test" options:@{@"url_suffix": @"hello", @"private_cdn": @YES, @"resource_type": @"raw"}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/files/test/hello", result);
}

- (void)testUseRootPathShared {
    // should support use_root_path in shared distribution
    NSString* result = [cloudinary url:@"test" options:@{@"use_root_path": @YES}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/test", result);
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAngleWithInt:0];
    result = [cloudinary url:@"test" options:@{@"use_root_path": @YES, @"transformation": transformation}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/a_0/test", result);
}

- (void)testUseRootPathNonImageUpload {
    // should disllow use_root_path if not image/upload
    NSDictionary* options = @{@"use_root_path": @YES, @"private_cdn": @YES, @"type": @"facebook"};
    XCTAssertThrows([cloudinary url:@"test" options:options]);
    options = @{@"use_root_path": @YES, @"private_cdn": @YES, @"resource_type": @"raw"};
    XCTAssertThrows([cloudinary url:@"test" options:options]);
}

- (void)testUseRootPathPrivateCdn {
    // should support use_root_path for private_cdn
    NSString* result = [cloudinary url:@"test" options:@{@"use_root_path": @YES, @"private_cdn": @YES}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/test", result);
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAngleWithInt:0];
    result = [cloudinary url:@"test" options:@{@"use_root_path": @YES, @"private_cdn": @YES, @"transformation": transformation}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/a_0/test", result);
}

- (void)testUseRootPathUrlSuffixPrivateCdn {
    // should support use_root_path with url_suffix for private_cdn
    NSString* result = [cloudinary url:@"test" options:@{@"use_root_path": @YES, @"url_suffix": @"hello", @"private_cdn": @YES}];
    XCTAssertEqualObjects(@"http://test123-res.cloudinary.com/test/hello", result);
}

- (void)testHttpEscape {
    // should escape http urls
    NSString* result = [cloudinary url:@"http://www.youtube.com/watch?v=d9NF2edxy-M" options:[NSDictionary dictionaryWithObject:@"youtube" forKey:@"type"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/youtube/http://www.youtube.com/watch%3Fv%3Dd9NF2edxy-M", result);
}

- (void)testDoubleSlash {
    // should convert double stash to single slash
    NSString* result = [cloudinary url:@"http://cloudinary.com//images//logo.png" options:[NSDictionary dictionaryWithObject:@"youtube" forKey:@"type"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/youtube/http://cloudinary.com/images/logo.png", result);
}

- (void)testBackground {
    // should support background
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setBackground:@"red"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/b_red/test", result);
    transformation = [CLTransformation transformation];
    [transformation setBackground:@"#112233"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/b_rgb:112233/test", result);
}


- (void)testDefaultImage {
    // should support default_image
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setDefaultImage:@"default"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/d_default/test", result);
}


- (void)testAngle {
    // should support angle
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAngleWithInt:12]; 
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/a_12/test", result);
    transformation = [CLTransformation transformation];
    [transformation setAngle:[NSArray arrayWithObjects:@"exif", @"12", nil]];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/a_exif.12/test", result);
}


- (void)testOverlay {
    // should support overlay
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setOverlay:@"text:hello"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/l_text:hello/test", result);
    // should not pass width/height to html if overlay
    transformation = [CLTransformation transformation];
    [transformation setOverlay:@"text:hello"];
    [transformation setWidth:@"100"];
    [transformation setHeight:@"100"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertNil(transformation.htmlHeight);
    XCTAssertNil(transformation.htmlWidth);
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/h_100,l_text:hello,w_100/test", result);
}


- (void)testUnderlay {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setUnderlay:@"text:hello"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/u_text:hello/test", result);
    // should not pass width/height to html if overlay
    transformation = [CLTransformation transformation];
    [transformation setUnderlay:@"text:hello"];
    [transformation setWidth:@"100"];
    [transformation setHeight:@"100"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertNil(transformation.htmlHeight);
    XCTAssertNil(transformation.htmlWidth);
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/h_100,u_text:hello,w_100/test", result);
}


- (void)testFetchFormat {
    // should support format for fetch urls
    NSString* result = [cloudinary url:@"http://cloudinary.com/images/logo.png" options:[NSDictionary dictionaryWithObjectsAndKeys:@"fetch", @"type", @"jpg", @"format", nil]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/fetch/f_jpg/http://cloudinary.com/images/logo.png", result);
}


- (void)testEffect {
    // should support effect
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setEffect:@"sepia"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/e_sepia/test", result);
}


- (void)testEffectWithParam {
    // should support effect with param
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setEffect:@"sepia" param:[NSNumber numberWithInt:10]];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/e_sepia:10/test", result);
}


- (void)testDensity {
    // should support density
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setDensityWithInt:150];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/dn_150/test", result);
}


- (void)testPage {
    // should support page
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setPageWithInt:5];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/pg_5/test", result);
}


- (void)testBorder {
    // should support border
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setBorder:5 color:@"black"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/bo_5px_solid_black/test", result);
    transformation = [CLTransformation transformation];
    [transformation setBorder:5 color:@"#ffaabbdd"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/bo_5px_solid_rgb:ffaabbdd/test", result);
    transformation = [CLTransformation transformation];
    [transformation setBorder:@"1px_solid_blue"];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/bo_1px_solid_blue/test", result);
}

- (void)testFlags {
    // should support flags
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setFlags:@"abc"];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/fl_abc/test", result);
    transformation = [CLTransformation transformation];
    [transformation setFlags:[NSArray arrayWithObjects:@"abc", @"def", nil]];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/fl_abc.def/test", result);
}

- (void)testDpr {
    // should support dpr
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setDprWithFloat:2.0];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/dpr_2.0/test", result);
}

- (void)testAspectRatio {
    // should support aspect_ratio
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAspectRatioWithFloat:2.0];
    NSString* result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/ar_2.0/test", result);

    transformation = [CLTransformation transformation];
    [transformation setAspectRatioWithNominator:3 andDemominator:2];
    result = [cloudinary url:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"]];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/ar_3:2/test", result);
}

- (void)testImageTag {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setWidthWithInt:100];
    [transformation setHeightWithInt:101];
    [transformation setCrop:@"crop"];
    
    NSString* result = [cloudinary imageTag:@"test" options:[NSDictionary dictionaryWithObject:transformation forKey:@"transformation"] htmlOptions:[NSDictionary dictionaryWithObject:@"my image" forKey:@"alt"]];
    XCTAssertEqualObjects(@"<img src='http://res.cloudinary.com/test123/image/upload/c_crop,h_101,w_100/test' alt='my image' width='100' height='101'/>", result);
}

- (void)testSignature {
    NSString* sig = [cloudinary apiSignRequest:[NSDictionary dictionaryWithObjectsAndKeys:@"b", @"a", @"d", @"c", @"", @"e", nil] secret:@"abcd"];
    XCTAssertEqualObjects(sig, @"ef1f04e0c1af08208a3dd28483107bc7f4a61209");
}

- (void)testFolders {
    // should add version if public_id contains /
    NSString* result = [cloudinary url:@"folder/test" options:@{}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/v1/folder/test", result);
    result = [cloudinary url:@"folder/test" options:@{@"version": @"123"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/v123/folder/test", result);
}

- (void)testFoldersWithVersion {
    // should not add version if public_id contains version already
    NSString* result = [cloudinary url:@"v1234/test" options:@{}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/v1234/test", result);
}

- (void)testShorten {
    // should allow to shorted image/upload urls
    NSString* result = [cloudinary url:@"test" options:@{@"shorten": @YES}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/iu/test", result);
}

- (void)testSignUrls {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setWidthWithInt:10];
    [transformation setHeightWithInt:20];
    [transformation setCrop: @"crop"];

    NSString* result = [cloudinary url:@"image.jpg" options:@{@"transformation": transformation, @"sign_url": @YES, @"version": @"1234"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/upload/s--Ai4Znfl3--/c_crop,h_20,w_10/v1234/image.jpg", result);
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
        XCTAssertEqualObjects(expected, result);
    }
}

- (void) testPreloadedImage {
    NSString* url = [cloudinary url:@"raw/private/v1234567/document.docx"];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/raw/private/v1234567/document.docx", url);

    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setWidthWithFloat:1.1];
    [transformation setCrop:@"scale"];

    url = [cloudinary url:@"image/private/v1234567/img.jpg" options:@{@"transformation": transformation}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/image/private/c_scale,w_1.1/v1234567/img.jpg", url);
}

- (void)testVideoCodec {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setVideoCodec:@"auto"];
    
    NSString* result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/vc_auto/video_id", result);

    transformation = [CLTransformation transformation];
    [transformation setVideoCodec:@"h264" andVideoProfile:@"basic" andLevel:@"3.1"];
    result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/vc_h264:basic:3.1/video_id", result);
}

- (void)testAudioCodec {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAudioCodec:@"acc"];
    
    NSString* result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/ac_acc/video_id", result);
}

- (void)testBitRate {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setBitRate:@"1m"];
    
    NSString* result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/br_1m/video_id", result);
    
    transformation = [CLTransformation transformation];
    [transformation setBitRateWithInt:2048];
    result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/br_2048/video_id", result);

    transformation = [CLTransformation transformation];
    [transformation setBitRateKilobytesWithInt:44];
    result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/br_44k/video_id", result);
}

- (void)testAudioFrequency {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setAudioFrequency:@"44100"];
    
    NSString* result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/af_44100/video_id", result);

    transformation = [CLTransformation transformation];
    [transformation setAudioFrequencyWithInt:44100];
    result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/af_44100/video_id", result);
}

- (void)testVideoSampling {
    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setVideoSampling:@"20"];
    
    NSString* result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/vs_20/video_id", result);
    
    transformation = [CLTransformation transformation];
    [transformation setVideoSamplingFramesWithInt:20];
    result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/vs_20/video_id", result);

    transformation = [CLTransformation transformation];
    [transformation setVideoSamplingDelayWithFloat:2.3];
    result = [cloudinary url:@"video_id" options:@{@"transformation": transformation, @"resource_type": @"video"}];
    XCTAssertEqualObjects(@"http://res.cloudinary.com/test123/video/upload/vs_2.3s/video_id", result);
}

- (void) testOverlayOptions {
    CLLayer* layer;
    
    layer = [CLLayer layer];
    [layer setPublicId:@"logo"];
    XCTAssertEqualObjects(@"logo", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setPublicId:@"logo"];
    [layer setType:@"private"];
    XCTAssertEqualObjects(@"private:logo", [layer generate:@"overlay"]);
    
    layer = [CLLayer layer];
    [layer setPublicId:@"logo"];
    [layer setFormat:@"png"];
    XCTAssertEqualObjects(@"logo.png", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setPublicId:@"folder/logo"];
    XCTAssertEqualObjects(@"folder:logo", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setPublicId:@"cat"];
    [layer setResourceType:@"video"];
    XCTAssertEqualObjects(@"video:cat", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setText:@"Hello World, Nice to meet you?"];
    [layer setFontFamily:@"Arial"];
    [layer setFontSizeWithInt:18];
    XCTAssertEqualObjects(@"text:Arial_18:Hello%20World%E2%80%9A%20Nice%20to%20meet%20you%3F", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setText:@"Hello World, Nice to meet you?"];
    [layer setFontFamily:@"Arial"];
    [layer setFontSizeWithInt:18];
    [layer setFontStyle:@"italic"];
    [layer setFontWeight:@"bold"];
    [layer setLetterSpacingWithInt:4];
    XCTAssertEqualObjects(@"text:Arial_18_bold_italic_letter_spacing_4:Hello%20World%E2%80%9A%20Nice%20to%20meet%20you%3F", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setPublicId:@"sample_sub_en.srt"];
    [layer setResourceType:@"subtitles"];
    XCTAssertEqualObjects(@"subtitles:sample_sub_en.srt", [layer generate:@"overlay"]);

    layer = [CLLayer layer];
    [layer setPublicId:@"sample_sub_he.srt"];
    [layer setResourceType:@"subtitles"];
    [layer setFontFamily:@"Arial"];
    [layer setFontSizeWithInt:40];
    XCTAssertEqualObjects(@"subtitles:Arial_40:sample_sub_he.srt", [layer generate:@"overlay"]);

    CLTransformation* transformation = [CLTransformation transformation];
    [transformation setOverlayWithLayer:layer];
    XCTAssertEqualObjects(@"l_subtitles:Arial_40:sample_sub_he.srt", [transformation generate]);
}

- (void) testOverlayErrors {
    CLLayer* layer;
    CLTransformation* transformation = [CLTransformation transformation];
    
    layer = [CLLayer layer];
    [layer setText:@"text"];
    [layer setFontStyle:@"italic"];
    XCTAssertThrows([transformation setOverlayWithLayer:layer]);

    layer = [CLLayer layer];
    [layer setResourceType:@"video"];
    XCTAssertThrows([transformation setUnderlayWithLayer:layer]);
}


@end
