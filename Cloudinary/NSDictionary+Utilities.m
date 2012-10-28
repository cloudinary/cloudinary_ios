//
//  NSDictionary+Utilities.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "NSDictionary+Utilities.h"

@implementation NSDictionary (Utilities)
- (id) valueForKey:(NSString*)key defaultValue: (id)defaultValue
{
    id value = [self valueForKey:key];
    if (value == nil) value = defaultValue;
    return value;
}
@end
