//
//  NSString+URLEncoding.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)

-(NSString *)smartEncodeUrl:(NSStringEncoding)encoding
{
	return (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();@&=+$,?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));    
}


@end
