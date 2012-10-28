//
//  NSDictionary+Utilities.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Utilities)
- (id) valueForKey:(NSString*)key defaultValue: (id)value;
@end
