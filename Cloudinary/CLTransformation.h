//
//  Transformation.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTransformation : NSObject

- (id)initWithDictionaries:(NSArray *)transformations;
- (id)init;
+ (id)transformation;

@property id width;
- (void)setWidthWithInt:(int)value;
- (void)setWidthWithFloat:(float)value;
@property id height;
- (void)setHeightWithInt:(int)value;
- (void)setHeightWithFloat:(float)value;
@property id named; // Supports array
@property NSString *crop;
@property NSString *background;
@property NSString *effect;
- (void)setEffect:(NSString *)value param:(id)param;
@property id angle; // Supports array
- (void)setAngleWithInt:(int)value;
@property NSString *border;
- (void)setBorder:(int)width color:(NSString *)color;
@property id x;
- (void)setXWithInt:(int)value;
- (void)setXWithFloat:(float)value;
@property id y;
- (void)setYWithInt:(int)value;
- (void)setYWithFloat:(float)value;
@property id radius;
- (void)setRadiusWithInt:(int)value;
@property id quality;
- (void)setQualityWithFloat:(float)value;
@property NSString *defaultImage;
@property NSString *gravity;
@property NSString *colorSpace;
@property NSString *prefix;
@property NSString *overlay;
@property NSString *underlay;
@property NSString *fetchFormat;
@property id density;
- (void)setDensityWithInt:(int)value;
@property id page;
- (void)setPageWithInt:(int)value;
@property id delay;
- (void)setDelayWithInt:(int)value;
@property NSString *rawTransformation;
@property id flags; // Supports array

@property NSDictionary *params;
- (void)chain;
- (void)param:(NSString *)param value:(id)value;

@property (readonly)NSString *htmlWidth;
@property (readonly)NSString *htmlHeight;

- (NSString *)generate;

@end
