//
//  NSString+URLEncoding.m
//  Cloudinary
//
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "NSString+CLURLEncoding.h"

@implementation NSString (CLURLEncoding)

-(NSString *)cl_smartEncodeUrl:(NSStringEncoding)encoding
{
    CFStringRef ref = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'\"();@&=+$,?%#[] ",
                                                              CFStringConvertNSStringEncodingToEncoding(encoding));
    NSString *encoded = [NSString stringWithString: (__bridge NSString *)ref];
    CFRelease( ref );
    
    return encoded;
}

@end
