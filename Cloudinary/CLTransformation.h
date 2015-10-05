//
//  Transformation.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLLayer.h"

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
- (void)setOverlayWithLayer:(CLLayer*)layer;
- (void)setUnderlayWithLayer:(CLLayer*)layer;
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
@property id dpr;
- (void)setDprWithFloat:(float)value;

@property id zoom;
- (void)setZoomWithFloat:(float)value;
@property NSString *audioCodec;
@property NSString *aspectRatio;
- (void)setAspectRatioWithNominator:(int)nom andDemominator:(int)denom;
- (void)setAspectRatioWithFloat:(float)value;
@property id audioFrequency;
- (void)setAudioFrequencyWithInt:(int)value;
@property id bitRate;
- (void)setBitRateWithInt:(int)bitRate;
- (void)setBitRateKilobytesWithInt:(int)bitRate;
@property id videoSampling;
- (void)setVideoSamplingDelayWithFloat:(float)videoSamplingDelay;
- (void)setVideoSamplingFramesWithInt:(int)videoSamplingFrames;
@property id duration;
- (void)setDurationSecondsWithFloat:(float)durationSeconds;
- (void)setDurationPercentsWithFloat:(float)durationPercents;
@property id startOffset;
- (void)setStartOffsetSecondsWithFloat:(float)startOffsetSeconds;
- (void)setStartOffsetPercentsWithFloat:(float)startOffsetPercents;
@property id endOffset;
- (void)setEndOffsetSecondsWithFloat:(float)endOffsetSeconds;
- (void)setEndOffsetPercentsWithFloat:(float)endOffsetPercents;
- (void)setStartOffsetSecondsWithFloat:(float)startOffsetSeconds andEndOffsetSeconds:(float)endOffsetSeconds;
- (void)setStartOffsetPercentsWithFloat:(float)startOffsetPercents andEndOffsetPercents:(float)endOffsetPercents;
@property NSString* videoCodec;
- (void)setVideoCodec:(NSString*)videoCodec andVideoProfile:(NSString*)videoProfile;
- (void)setVideoCodec:(NSString*)videoCodec andVideoProfile:(NSString*)videoProfile andLevel:(NSString*)level;

@property NSDictionary *params;
- (void)chain;
- (void)param:(NSString *)param value:(id)value;

@property (readonly)NSString *htmlWidth;
@property (readonly)NSString *htmlHeight;

- (NSString *)generate;

@end
