//
//  NSString+URLEncoding.h
//  Cloudinary
//
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CLURLEncoding)
-(NSString *)cl_smartEncodeUrl:(NSStringEncoding)encoding;
@end
