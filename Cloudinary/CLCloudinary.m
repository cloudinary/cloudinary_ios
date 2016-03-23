//
//  Cloudinary.m
//  Cloudinary
//
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "CLCloudinary.h"
#import "Security/Security.h"
#import <CommonCrypto/CommonDigest.h>
#import "CLTransformation.h"
#import "NSString+CLURLEncoding.h"
#import "NSDictionary+CLUtilities.h"

NSString * const CL_VERSION = @"1.0.15";

NSString * const CL_CF_SHARED_CDN = @"d3jpl91pxevbkh.cloudfront.net";
NSString * const CL_OLD_AKAMAI_SHARED_CDN = @"cloudinary-a.akamaihd.net";
NSString * const CL_AKAMAI_SHARED_CDN = @"res.cloudinary.com";
NSString * const CL_SHARED_CDN = @"res.cloudinary.com";

@implementation CLCloudinary {
    NSMutableDictionary *_config;
}

+ (NSString *)version
{
    return CL_VERSION;
}

- (CLCloudinary *)init
{
    if ( self = [super init] )
    {
        _config = [NSMutableDictionary dictionary];
        char* url = getenv("CLOUDINARY_URL");
        if (url != nil)
        {
            [self parseUrl:@(url)];
        }
    }
    return self;
}

- (CLCloudinary *)initWithUrl:(NSString *)url
{
    CLCloudinary* cloudinary = [self init];
    [cloudinary parseUrl:url];
    return cloudinary;
}

- (CLCloudinary *)initWithDictionary:(NSDictionary *)options
{
    if ( self = [super init] )
    {
        _config = [NSMutableDictionary dictionaryWithDictionary:options];
    }
    return self;
}

- (void)parseUrl:(NSString *)url
{
    NSURL *uri = [NSURL URLWithString:url];
    [_config setValue:[uri user] forKey:@"api_key"];
    [_config setValue:[uri password] forKey:@"api_secret"];
    [_config setValue:[uri host] forKey:@"cloud_name"];
    if ([[uri path] isEqualToString:@""])
    {
        [_config setValue:@NO forKey:@"private_cdn"];
    }
    else
    {
        [_config setValue:@YES forKey:@"private_cdn"];
        [_config setValue:[[uri path] substringFromIndex:1] forKey:@"secure_distribution"];
    }
    for (NSString *param in [[uri query] componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        if([elts count] < 2) continue;
        [_config setValue:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
    }
}

- (NSDictionary *)config
{
    return _config;
}

- (NSString *)cloudinaryApiUrl:(NSString *)action options:(NSDictionary *)options
{
    NSMutableArray* components = [NSMutableArray arrayWithCapacity:5];
    NSString *upload_prefix = [self get:@"upload_prefix" options:options defaultValue: @"https://api.cloudinary.com"];
    [components addObject:upload_prefix];
    [components addObject:@"v1_1"];
    NSString *cloud_name = [self get:@"cloud_name" options:options defaultValue: nil];
    if (cloud_name == nil)[NSException raise:@"CloudinaryError" format:@"Must supply cloud_name in tag or in configuration"];
    [components addObject:cloud_name];
    if (![action isEqualToString:@"delete_by_token"]) {
        NSString *resource_type = [options cl_valueForKey:@"resource_type" defaultValue:@"image"];
        [components addObject:resource_type];
    }
    [components addObject:action];
    return [components componentsJoinedByString:@"/"];
}

#define RANDOM_BYTES_LEN 8
- (NSString *)randomPublicId
{
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(RANDOM_BYTES_LEN * 2)];
    for (int i = 0; i < RANDOM_BYTES_LEN; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02x", arc4random() & 0xFF]];
    return [NSString stringWithString:hexString];
}

- (NSString *)signedPreloadedImage:(NSDictionary *)result
{
    NSMutableString     *identifier = [NSMutableString stringWithCapacity:40];
    [identifier appendFormat:@"%@/%@/v%@/%@",
     [result valueForKey:@"resource_type"],
     [result valueForKey:@"type"],
     [result valueForKey:@"version"],
     [result valueForKey:@"public_id"]];
    
    NSString *format = [result valueForKey:@"format"];
    if (format != nil) {
        [identifier appendFormat:@".%@", format];
    }
    [identifier appendFormat:@"#%@", [result valueForKey:@"signature"]];
    return [NSString stringWithString:identifier];
}

- (NSString *)apiSignRequest:(NSDictionary *) paramsToSign secret:(NSString *)apiSecret
{
    NSArray* paramNames = [paramsToSign allKeys];
    NSMutableArray *params = [NSMutableArray arrayWithCapacity:[paramsToSign count]];
    paramNames = [paramNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString *param in paramNames) {
        NSObject* value = [paramsToSign valueForKey:param];
        NSString* paramValue;
        if ([value isKindOfClass:[NSArray class]]) {
            NSArray *arrayValue = (NSArray*) value;
            if ([arrayValue count] == 0) continue;
            paramValue = [arrayValue componentsJoinedByString:@","];
        } else {
            paramValue = [CLCloudinary asString:value];
            if ([paramValue length] == 0) continue;
        }
        NSArray* encoded = @[param, paramValue];
        [params addObject:[encoded componentsJoinedByString:@"="]];
    }
    NSString *toSign = [params componentsJoinedByString:@"&"];
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1_CTX ctx;
    CC_SHA1_Init(&ctx);
    NSData *stringBytes = [toSign dataUsingEncoding: NSUTF8StringEncoding];
    CC_SHA1_Update(&ctx, [stringBytes bytes], (CC_LONG) [stringBytes length]);
    stringBytes = [apiSecret dataUsingEncoding: NSUTF8StringEncoding];
    CC_SHA1_Update(&ctx, [stringBytes bytes], (CC_LONG) [stringBytes length]);

    CC_SHA1_Final(digest, &ctx);
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(CC_SHA1_DIGEST_LENGTH * 2)];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02x", (unsigned)digest[i]]];
    return [NSString stringWithString:hexString];
}

- (NSString *)url:(NSString *)source
{
    return [self url:source options:@{}];
}

- (id)get:(NSString *)key options:(NSDictionary *)options defaultValue:(id)defaultValue
{
    return [options cl_valueForKey:key defaultValue:[_config cl_valueForKey:key defaultValue:defaultValue]];
    
}

- (NSString*) finalizeResourceType:(NSString*)resourceType type:(NSString*)type options:(NSDictionary*) options
{
    NSString* urlSuffix = [self get:@"url_suffix" options:options defaultValue:nil];
    NSNumber* useRootPath = [self get:@"use_root_path" options:options defaultValue:@NO];
    NSNumber* privateCdn = [self get:@"private_cdn" options:options defaultValue:@NO];
    NSNumber* shorten = [self get:@"shorten" options:options defaultValue:@NO];
    if (![privateCdn boolValue]) {
        if ([urlSuffix length] > 0) {
            [NSException raise:@"CloudinaryError" format:@"URL Suffix only supported in private CDN"];
        }
    }
    
    NSString* resourceTypeAndType = [NSString stringWithFormat:@"%@/%@", resourceType, type];
    if ([urlSuffix length] > 0) {
        if ([resourceTypeAndType isEqualToString:@"image/upload"]) {
            resourceTypeAndType = @"images";
        } else if ([resourceTypeAndType isEqualToString:@"raw/upload"]) {
            resourceTypeAndType = @"files";
        } else {
            [NSException raise:@"CloudinaryError" format:@"URL Suffix only supported for image/upload and raw/upload"];
        }
    }
    if ([useRootPath boolValue]) {
        if ([resourceTypeAndType isEqualToString:@"image/upload"] || [resourceTypeAndType isEqualToString:@"images"]) {
            resourceTypeAndType = @"";
        } else {
            [NSException raise:@"CloudinaryError" format:@"Root path only supported for image/upload"];
        }
    }
    if ([shorten boolValue] && [resourceTypeAndType isEqualToString:@"image/upload"])
    {
        resourceTypeAndType = @"iu";
    }
    return resourceTypeAndType;
}

- (NSString*)finalizePrefix:(NSString*)source options:(NSDictionary*)options
{
    NSString *cloudName = [self get:@"cloud_name" options:options defaultValue:nil];
    if ([cloudName length] == 0) {
        [NSException raise:@"CloudinaryError" format:@"Must supply cloud_name in tag or in configuration"];
    }
    NSNumber* secure = [self get:@"secure" options:options defaultValue:@NO];
    NSNumber* privateCdn = [self get:@"private_cdn" options:options defaultValue:@NO];
    NSNumber* cdnSubdomain = [self get:@"cdn_subdomain" options:options defaultValue:@NO];
    NSNumber* secureCdnSubdomain = [self get:@"secure_cdn_subdomain" options:options defaultValue:nil];
    NSString *secureDistribution = [self get:@"secure_distribution" options:options defaultValue:nil];
    NSString *cname = [self get:@"cname" options:options defaultValue:nil];

    NSMutableString* prefix = [NSMutableString string];
    BOOL sharedDomain = ![privateCdn boolValue];
    if ([secure boolValue])
    {
        if ([secureDistribution length] == 0 || [secureDistribution isEqualToString:CL_OLD_AKAMAI_SHARED_CDN])
        {
            secureDistribution = [privateCdn boolValue] ? [NSString stringWithFormat:@"%@-res.cloudinary.com", cloudName] : CL_SHARED_CDN;
        }
        sharedDomain = sharedDomain || [secureDistribution isEqualToString:CL_SHARED_CDN];
        if (secureCdnSubdomain == nil && sharedDomain) {
            secureCdnSubdomain = cdnSubdomain;
        }
        if ([secureCdnSubdomain boolValue]) {
            NSString* shardedDomain = [NSString stringWithFormat:@"res-%d.cloudinary.com", [self crc32:source] % 5 + 1];
            secureDistribution = [secureDistribution stringByReplacingOccurrencesOfString:@"res.cloudinary.com" withString:shardedDomain];
        }

        [prefix appendFormat:@"https://%@", secureDistribution];
    }
    else if ([cname length] > 0)
    {
        [prefix appendString:@"http://"];
        if ([cdnSubdomain boolValue])
        {
            [prefix appendFormat:@"a%d.", [self crc32:source] % 5 + 1];
        }
        [prefix appendString:cname];
    }
    else
    {
        [prefix appendString:@"http://"];
        if ([privateCdn boolValue])
        {
            [prefix appendFormat:@"%@-", cloudName];
        }
        [prefix appendString:@"res"];
        if ([cdnSubdomain boolValue])
        {
            [prefix appendFormat:@"-%d", [self crc32:source] % 5 + 1];
        }
        [prefix appendString:@".cloudinary.com"];
    }
    if (sharedDomain)
    {
        [prefix appendString:@"/"];
        [prefix appendString:cloudName];
    }
    return prefix;
}

- (NSString *)url:(NSString *)source options:(NSDictionary *)options
{
    NSString *type = [options cl_valueForKey:@"type" defaultValue:@"upload"];
    NSString *resourceType = [options cl_valueForKey:@"resource_type" defaultValue:@"image"];
    NSString *format = [options valueForKey:@"format"];
    NSString *version = [CLCloudinary asString:[options cl_valueForKey:@"version" defaultValue:@""]];
    NSString* urlSuffix = [self get:@"url_suffix" options:options defaultValue:nil];
    NSNumber* signUrl = [self get:@"sign_url" options:options defaultValue:@NO];
    NSString* apiSecret = [self get:@"api_secret" options:options defaultValue:nil];
    if ([signUrl boolValue] && apiSecret == NULL) {
        [NSException raise:@"CloudinaryError" format:@"Must supply api_secret for signing urls"];
    }

    static NSRegularExpression *preloadedRegex;
    static dispatch_once_t preloadedOnceToken;
    dispatch_once(&preloadedOnceToken, ^{
        preloadedRegex = [NSRegularExpression regularExpressionWithPattern:@"^([^/]+)/([^/]+)/v([0-9]+)/([^#]+)(#[0-9a-f]+)?$" options:NSRegularExpressionCaseInsensitive error:nil];
    });

    NSArray *preloadedComponentsMatch = [preloadedRegex matchesInString:source options:0 range:NSMakeRange(0, [source length])];
    if ([preloadedComponentsMatch count] > 0) {
        NSTextCheckingResult* preloadedComponents = preloadedComponentsMatch[0];
        resourceType = [source substringWithRange:[preloadedComponents rangeAtIndex:1]];
        type = [source substringWithRange:[preloadedComponents rangeAtIndex:2]];
        version = [source substringWithRange:[preloadedComponents rangeAtIndex:3]];
        source = [source substringWithRange:[preloadedComponents rangeAtIndex:4]];
    }

    CLTransformation* transformation = [options valueForKey:@"transformation"];
    if (transformation == nil) transformation = [CLTransformation transformation];
    if ([type isEqualToString:@"fetch"] && [format length] > 0)
    {
        [transformation setFetchFormat:format];
        format = nil;
    }
    NSString *transformationStr = [transformation generate];
    
    if (source == nil) return nil;
    
    if ([source rangeOfString:@"/"].location != NSNotFound &&
        [source rangeOfString:@"^v[0-9]+/.*" options:NSRegularExpressionSearch].location == NSNotFound &&
        [source rangeOfString:@"^https?:/.*" options:NSCaseInsensitiveSearch|NSRegularExpressionSearch].location == NSNotFound &&
        [version length] == 0)
    {
        version = @"1";
    }
    
    if ([version length] > 0)
    {
        version = [NSString stringWithFormat:@"v%@", version];
    }

    NSMutableString *toSign = [NSMutableString string];
    if ([transformationStr length] > 0) {
        [toSign appendString:transformationStr];
        [toSign appendString:@"/"];
    }
    if ([source rangeOfString:@"^https?:/.*" options:NSCaseInsensitiveSearch|NSRegularExpressionSearch].location != NSNotFound)
    {
        source = [source cl_smartEncodeUrl:NSUTF8StringEncoding];
        [toSign appendString:source];
    } else {
        source = [[source stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] cl_smartEncodeUrl:NSUTF8StringEncoding];
        [toSign appendString:source];
        if ([urlSuffix length] > 0) {
            if ([urlSuffix rangeOfString:@"[/\\.]" options:NSRegularExpressionSearch].location != NSNotFound) {
                [NSException raise:@"CloudinaryError" format:@"url_suffix should not include . or /"];
            }
            source = [NSString stringWithFormat:@"%@/%@", source, urlSuffix];
        }
        if (format != nil) {
            source = [NSString stringWithFormat:@"%@.%@", source, format];
            [toSign appendString:@"."];
            [toSign appendString:format];
        }
    }

    NSString* prefix = [self finalizePrefix:source options:options];
    NSString* resourceTypeAndType = [self finalizeResourceType:resourceType type:type options:options];

    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"([^:])\\/+"
                                                          options:NSRegularExpressionCaseInsensitive
                                                            error:nil];
    });
    
    NSString* signature = @"";
    if ([signUrl boolValue])
    {
        [toSign appendString:apiSecret];
        NSString *encoded = [self sha1Base64:toSign];

        signature = [NSString stringWithFormat:@"s--%@--", [encoded substringWithRange:NSMakeRange(0, 8)]];
    }
    
    NSString *url = [@[prefix, resourceTypeAndType, signature, transformationStr, version, source] componentsJoinedByString:@"/"];
    
    return [regex stringByReplacingMatchesInString:url options:0 range:NSMakeRange(0, [url length]) withTemplate:@"$1/"];
}

- (NSString *)imageTag:(NSString *)source
{
    return [self imageTag:source options:@{}];
}

- (NSString *)imageTag:(NSString *)source options:(NSDictionary *)options
{
    return [self imageTag:source options:options htmlOptions:@{}];
}

- (NSString *)imageTag:(NSString *)source options:(NSDictionary *)options htmlOptions:(NSDictionary *)htmlOptions
{
    NSMutableDictionary *mutableOptions = [NSMutableDictionary dictionaryWithDictionary:options];
    CLTransformation *transformation = mutableOptions[@"transformation"];
    if (transformation == nil)
    {
        transformation = [CLTransformation transformation];
        [mutableOptions setValue:transformation forKey:@"transformation"];
    }
    NSString *url = [self url:source options:mutableOptions];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:htmlOptions];
    if (transformation.htmlHeight != nil) [attributes setValue:transformation.htmlHeight forKey:@"height"];
    if (transformation.htmlWidth != nil) [attributes setValue:transformation.htmlWidth forKey:@"width"];
    NSMutableString* tag = [NSMutableString string];
    [tag appendString:@"<img src='"];
    [tag appendString:url];
    [tag appendString:@"'"];
    for (NSString *key in [attributes allKeys])
    {
        [tag appendFormat:@" %@='%@'", key, [attributes valueForKey:key], nil];
    }
    [tag appendString:@"/>"];
    return tag;
}

+ (NSArray *)asArray:(id)value
{
    if (value == nil) {
        return @[];
    } else if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return @[value];
    }
}	

+ (NSString *)asString:(id)value
{
    if (value == nil) {
        return nil;
    } else if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber* number = value;
        return [number stringValue];
    } else {
        [NSException raise:@"CloudinaryError" format:@"Expected NSString or NSNumber"];
        return nil;
    }
}

+ (NSNumber *)asBool:(id)value
{
    if (value == nil) {
        return nil;
    } else if ([value isKindOfClass:[NSString class]]) {
        return @([(NSString *)value isEqualToString:@"true"]);
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)value;
        return @([number boolValue]);
        // existing code caused a compile warning
        // return [NSNumber numberWithBool:[(NSNumber*)value integerValue] == 1];
    } else {
        [NSException raise:@"CloudinaryError" format:@"Expected NSString or NSNumber"];
        return nil;
    }
}

- (NSString *)sha1Base64:(NSString *)string
{
    unsigned char sha1[CC_SHA1_DIGEST_LENGTH];
    const char *cStr = [string UTF8String];
    CC_SHA1(cStr, (CC_LONG) strlen(cStr), sha1);
    NSData *pwHashData = [[NSData alloc] initWithBytes:sha1 length: sizeof sha1];
    NSString *base64 =  [pwHashData base64EncodedStringWithOptions:0];
    NSString *encoded = [[[base64
                           stringByReplacingOccurrencesOfString:@"/" withString:@"_"]
                           stringByReplacingOccurrencesOfString:@"+" withString:@"-"]
                           stringByReplacingOccurrencesOfString:@"=" withString:@""];
    return encoded;
}

- (unsigned)crc32:(NSString *)str
{
    // http://kevin.vanzonneveld.net
    // +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
    // +   improved by: T0bsn
    // +   improved by: http://stackoverflow.com/questions/2647935/javascript-crc32-function-and-php-crc32-not-matching
    NSString *table = @"00000000 77073096 EE0E612C 990951BA 076DC419 706AF48F E963A535 9E6495A3 0EDB8832 79DCB8A4 E0D5E91E 97D2D988 09B64C2B 7EB17CBD E7B82D07 90BF1D91 1DB71064 6AB020F2 F3B97148 84BE41DE 1ADAD47D 6DDDE4EB F4D4B551 83D385C7 136C9856 646BA8C0 FD62F97A 8A65C9EC 14015C4F 63066CD9 FA0F3D63 8D080DF5 3B6E20C8 4C69105E D56041E4 A2677172 3C03E4D1 4B04D447 D20D85FD A50AB56B 35B5A8FA 42B2986C DBBBC9D6 ACBCF940 32D86CE3 45DF5C75 DCD60DCF ABD13D59 26D930AC 51DE003A C8D75180 BFD06116 21B4F4B5 56B3C423 CFBA9599 B8BDA50F 2802B89E 5F058808 C60CD9B2 B10BE924 2F6F7C87 58684C11 C1611DAB B6662D3D 76DC4190 01DB7106 98D220BC EFD5102A 71B18589 06B6B51F 9FBFE4A5 E8B8D433 7807C9A2 0F00F934 9609A88E E10E9818 7F6A0DBB 086D3D2D 91646C97 E6635C01 6B6B51F4 1C6C6162 856530D8 F262004E 6C0695ED 1B01A57B 8208F4C1 F50FC457 65B0D9C6 12B7E950 8BBEB8EA FCB9887C 62DD1DDF 15DA2D49 8CD37CF3 FBD44C65 4DB26158 3AB551CE A3BC0074 D4BB30E2 4ADFA541 3DD895D7 A4D1C46D D3D6F4FB 4369E96A 346ED9FC AD678846 DA60B8D0 44042D73 33031DE5 AA0A4C5F DD0D7CC9 5005713C 270241AA BE0B1010 C90C2086 5768B525 206F85B3 B966D409 CE61E49F 5EDEF90E 29D9C998 B0D09822 C7D7A8B4 59B33D17 2EB40D81 B7BD5C3B C0BA6CAD EDB88320 9ABFB3B6 03B6E20C 74B1D29A EAD54739 9DD277AF 04DB2615 73DC1683 E3630B12 94643B84 0D6D6A3E 7A6A5AA8 E40ECF0B 9309FF9D 0A00AE27 7D079EB1 F00F9344 8708A3D2 1E01F268 6906C2FE F762575D 806567CB 196C3671 6E6B06E7 FED41B76 89D32BE0 10DA7A5A 67DD4ACC F9B9DF6F 8EBEEFF9 17B7BE43 60B08ED5 D6D6A3E8 A1D1937E 38D8C2C4 4FDFF252 D1BB67F1 A6BC5767 3FB506DD 48B2364B D80D2BDA AF0A1B4C 36034AF6 41047A60 DF60EFC3 A867DF55 316E8EEF 4669BE79 CB61B38C BC66831A 256FD2A0 5268E236 CC0C7795 BB0B4703 220216B9 5505262F C5BA3BBE B2BD0B28 2BB45A92 5CB36A04 C2D7FFA7 B5D0CF31 2CD99E8B 5BDEAE1D 9B64C2B0 EC63F226 756AA39C 026D930A 9C0906A9 EB0E363F 72076785 05005713 95BF4A82 E2B87A14 7BB12BAE 0CB61B38 92D28E9B E5D5BE0D 7CDCEFB7 0BDBDF21 86D3D2D4 F1D4E242 68DDB3F8 1FDA836E 81BE16CD F6B9265B 6FB077E1 18B74777 88085AE6 FF0F6A70 66063BCA 11010B5C 8F659EFF F862AE69 616BFFD3 166CCF45 A00AE278 D70DD2EE 4E048354 3903B3C2 A7672661 D06016F7 4969474D 3E6E77DB AED16A4A D9D65ADC 40DF0B66 37D83BF0 A9BCAE53 DEBB9EC5 47B2CF7F 30B5FFE9 BDBDF21C CABAC28A 53B39330 24B4A3A6 BAD03605 CDD70693 54DE5729 23D967BF B3667A2E C4614AB8 5D681B02 2A6F2B94 B40BBE37 C30C8EA1 5A05DF1B 2D02EF8D";
    
    int crc = 0;
    unsigned int x = 0;
    int y = 0;
    unsigned long iTop = [str length];
    crc = crc ^ (-1);
    for (unsigned long i = 0; i < iTop; i++) {
        char ch = [str characterAtIndex:i];
        y = (crc ^ ch) & 0xFF;
        NSString *tableEntry = [table substringWithRange:(NSRange){y*9, 8}];
        NSScanner *scan = [NSScanner scannerWithString:tableEntry];
        [scan scanHexInt:&x];
        crc = ((crc >> 8) & 0x00FFFFFF) ^ x;
    }
    
    return crc ^ (-1);
}

@end
