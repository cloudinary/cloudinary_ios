//
//  NSString+URLEncoding.h
//  Cloudinary
//
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)
-(NSString *)smartEncodeUrl:(NSStringEncoding)encoding;
@end
