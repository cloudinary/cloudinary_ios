//
//  Cloudinary.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 24/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/NSDictionary.h>
#import "NSDictionary+Utilities.h"

extern NSString * const SHARED_CDN;

@interface Cloudinary : NSObject {
    NSMutableDictionary* config;
}

- (Cloudinary*) initWithUrl: (NSString *)url;
- (NSDictionary*) config;
- (NSString *) cloudinaryApiUrl: (NSString*) action options: (NSDictionary*) options;
- (NSString *) apiSignRequest: (NSDictionary*) paramsToSign secret:(NSString*) apiSecret;
- (NSString *) signedPreloadedImage: (NSDictionary*) result;
- (NSString *) randomPublicId;
- (id) get:(NSString*)key options:(NSDictionary*)options defaultValue:(id)defaultValue;
+ (NSArray*) asArray: (id) value;
+ (NSString*) asString: (id) value;
+ (NSNumber*) asBool: (id) value;
- (NSString*) url:(NSString*) source;
- (NSString*) url:(NSString*) source options:(NSDictionary*) options;
- (NSString*) imageTag:(NSString*) source;
- (NSString*) imageTag:(NSString*) source options:(NSDictionary*) options;
- (NSString*) imageTag:(NSString*) source options:(NSDictionary*) options htmlOptions:(NSDictionary*) htmlOptions;

@end
