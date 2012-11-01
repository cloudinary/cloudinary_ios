//
//  Uploader.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 26/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLCloudinary.h"

@protocol CLUploaderDelegate <NSObject>
- (void) uploaderSuccess:(NSDictionary*)result context:(id)context;
- (void) uploaderError:(NSString*)result code:(int) code context:(id)context;
@end

@interface CLUploader : NSObject
- (id) init:(CLCloudinary*)cloudinary delegate:(id <CLUploaderDelegate> )delegate;
- (void) upload:(id)file options:(NSDictionary*) options;
- (void) destroy:(NSString*)publicId options:(NSDictionary*) options;
- (void) explicit:(NSString*)publicId options:(NSDictionary*) options;
- (void) addTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (void) removeTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (void) replaceTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*) options;
- (void) text:(NSString*)text options:(NSDictionary*) options;
@end
