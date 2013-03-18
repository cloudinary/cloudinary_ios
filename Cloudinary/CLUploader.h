//
//  Uploader.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 26/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLCloudinary.h"

@protocol CLUploaderDelegate;

typedef void(^CLUploaderCompletion)(NSDictionary* successResult, NSString* errorResult, NSInteger code, id context);
typedef void(^CLUploaderProgress)(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite, id context);

@interface CLUploader : NSObject

@property (assign)id<CLUploaderDelegate> delegate;
@property (readonly)CLCloudinary *cloudinary;

- (id)init:(CLCloudinary*)cloudinary delegate:(id <CLUploaderDelegate> )delegate;
- (void)cancel;

- (void)upload:(id)file options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;
- (void)destroy:(NSString*)publicId options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;
- (void)explicit:(NSString*)publicId options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;
- (void)addTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;
- (void)removeTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;
- (void)replaceTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;
- (void)text:(NSString*)text options:(NSDictionary*)options withCompletion:(CLUploaderCompletion)completionBlock andProgress:(CLUploaderProgress)progressBlock;

- (void)upload:(id)file options:(NSDictionary*)options;
- (void)destroy:(NSString*)publicId options:(NSDictionary*)options;
- (void)explicit:(NSString*)publicId options:(NSDictionary*)options;
- (void)addTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*)options;
- (void)removeTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*)options;
- (void)replaceTag:(NSString*)tag publicIds:(NSArray*)publicIds options:(NSDictionary*)options;
- (void)text:(NSString*)text options:(NSDictionary*)options;

@end

@protocol CLUploaderDelegate <NSObject>
@optional
- (void)uploaderProgress:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite context:(id)context;
- (void)uploaderSuccess:(NSDictionary*)result context:(id)context;
- (void)uploaderError:(NSString*)result code:(NSInteger)code context:(id)context;
@end
