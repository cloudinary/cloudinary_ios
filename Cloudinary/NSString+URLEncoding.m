//
//  NSString+URLEncoding.m
//  Cloudinary
//
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
