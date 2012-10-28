//
//  Uploader.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 26/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloudinary.h"

@interface Uploader : NSObject
- (id) init:(Cloudinary*)cloudinary delegate:(id)delegate;
- (void) upload:(id)file options:(NSDictionary*) options;
- (void) destroy:(NSString*)publicId options:(NSDictionary*) options;
- (void) explicit:(NSString*)publicId options:(NSDictionary*) options;
- (void) addTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (void) removeTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (void) replaceTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (void) text:(NSString*)text options:(NSDictionary*) options;

// internal
- (void) callApi:(NSString*)action file:(id)file params:(NSDictionary*)params options:(NSDictionary*) options;
- (void) callTagsApi:(NSString*)tag command:(NSString*)command publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (NSString*) buildEager:(NSArray*)transformations;
- (NSString*) buildCustomHeaders:(id)headers;
- (NSDictionary*) buildUploadParams:(NSDictionary*) options;

@end

@protocol UploaderDelegate <NSObject>
- (void) success:(NSDictionary*)result;
- (void) error:(NSString*)result;
@end