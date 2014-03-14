//
//  Cloudinary.h
//  Cloudinary
//
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>

extern NSString * const CL_SHARED_CDN;
extern NSString * const CL_CF_SHARED_CDN;
extern NSString * const CL_OLD_AKAMAI_SHARED_CDN;
extern NSString * const CL_AKAMAI_SHARED_CDN;

@interface CLCloudinary : NSObject

+ (NSString *)version;

- (CLCloudinary *)init;
- (CLCloudinary *)initWithUrl:(NSString *)cloudinaryUrl;
- (NSMutableDictionary *)config;

- (NSString *)url:(NSString *)source;
- (NSString *)url:(NSString *)source options:(NSDictionary*)options;
- (NSString *)imageTag:(NSString *)source;
- (NSString *)imageTag:(NSString *)source options:(NSDictionary*)options;
- (NSString *)imageTag:(NSString *)source options:(NSDictionary*)options htmlOptions:(NSDictionary*)htmlOptions;

- (id)get:(NSString *)key options:(NSDictionary*)options defaultValue:(id)defaultValue;

- (NSString *)cloudinaryApiUrl:(NSString *)action options:(NSDictionary *)options;
- (NSString *)apiSignRequest:(NSDictionary*)paramsToSign secret:(NSString *)apiSecret;
- (NSString *)randomPublicId;
- (NSString *)signedPreloadedImage:(NSDictionary*)uploadResult;

+ (NSArray *)asArray:(id)value;
+ (NSString *)asString:(id)value;
+ (NSNumber *)asBool:(id)value;

@end
