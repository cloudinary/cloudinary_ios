//
//  Cloudinary.h
//  Cloudinary
//
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import "NSDictionary+Utilities.h"

extern NSString * const SHARED_CDN;

@interface Cloudinary : NSObject {
    NSMutableDictionary* config;
}

- (Cloudinary*) init;
- (Cloudinary*) initWithUrl: (NSString *)cloudinaryUrl;
- (NSMutableDictionary*) config;

- (NSString*) url:(NSString*) source;
- (NSString*) url:(NSString*) source options:(NSDictionary*) options;
- (NSString*) imageTag:(NSString*) source;
- (NSString*) imageTag:(NSString*) source options:(NSDictionary*) options;
- (NSString*) imageTag:(NSString*) source options:(NSDictionary*) options htmlOptions:(NSDictionary*) htmlOptions;

- (id) get:(NSString*)key options:(NSDictionary*)options defaultValue:(id)defaultValue;

- (NSString *) cloudinaryApiUrl: (NSString*) action options: (NSDictionary*) options;
- (NSString *) apiSignRequest: (NSDictionary*) paramsToSign secret:(NSString*) apiSecret;
- (NSString *) randomPublicId;

+ (NSArray*) asArray: (id) value;
+ (NSString*) asString: (id) value;
+ (NSNumber*) asBool: (id) value;

@end
