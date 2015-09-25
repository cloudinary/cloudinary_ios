//
//  Transformation.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "CLTransformation.h"
#import "CLCloudinary.h"

@interface CLTransformation ()

- (NSString *) generateWithParams:(NSDictionary *)params;

@end;

@implementation CLTransformation
{
	NSMutableDictionary *_params;
	NSMutableArray *_transformations;
}

- (id)init
{
    return [self initWithDictionaries:@[]];
}

- (id)initWithDictionaries:(NSArray *)dictionaries
{
    if ( self = [super init] )
    {
        _transformations = [NSMutableArray arrayWithArray:dictionaries];
        [self chain];
    }
    return self;
}

+ (id)transformation
{
    return [[CLTransformation alloc] init];
}

- (void)setWidth:(id)value { [self param:@"width" value:value]; }
- (id)width { return [_params valueForKey:@"width"]; }
- (void)setWidthWithInt:(int)value { [self setWidth:@(value)]; }
- (void)setWidthWithFloat:(float)value { [self setWidth:[self formatFloat:value]]; }
- (void)setHeight:(id)value { [self param:@"height" value:value]; }
- (id)height { return [_params valueForKey:@"height"]; }
- (void)setHeightWithInt:(int)value { [self setHeight:@(value)]; }
- (void)setHeightWithFloat:(float)value { [self setHeight:[self formatFloat:value]]; }
- (void)setNamed:(id)value { [self param:@"transformation" value:value]; }
- (id)named { return [_params valueForKey:@"transformation"]; }

- (void)setCrop:(NSString *)value { [self param:@"crop" value:value]; }
- (NSString *)crop { return [_params valueForKey:@"crop"]; }

- (void)setBackground:(NSString *)value { [self param:@"background" value:value]; }
- (NSString *)background { return [_params valueForKey:@"background"]; }

- (void)setColor:(NSString *)value { [self param:@"color" value:value]; }
- (NSString *)color { return [_params valueForKey:@"color"]; }

- (void)setEffect:(NSString *)value { [self param:@"effect" value:value]; }
- (NSString *)effect { return [_params valueForKey:@"effect"]; }
- (void)setEffect:(NSString *)value param:(id)param
{
    [self setEffect:[NSString stringWithFormat:@"%@:%@", value, param]];
}
- (void)setAngle:(id)value { [self param:@"angle" value:value]; }
- (id)angle { return [_params valueForKey:@"angle"]; }
- (void)setAngleWithInt:(int)value { [self setAngle:@(value)]; }
- (void)setBorder:(NSString *)value { [self param:@"border" value:value]; }
- (NSString *)border { return [_params valueForKey:@"border"]; }
- (void)setBorder:(int)width color:(NSString *)color
{
    color = [color stringByReplacingOccurrencesOfString:@"#" withString:@"rgb:"];
    [self setBorder:[NSString stringWithFormat:@"%dpx_solid_%@", width, color]];
}
- (void)setX:(id)value { [self param:@"x" value:value]; }
- (id)x { return [_params valueForKey:@"x"]; }
- (void)setXWithInt:(int)value { [self setX:@(value)]; }
- (void)setXWithFloat:(float)value { [self setX:[self formatFloat:value]]; }

- (void)setY:(id)value { [self param:@"y" value:value]; }
- (id)y { return [_params valueForKey:@"y"]; }
- (void)setYWithInt:(int)value { [self setY:@(value)]; }
- (void)setYWithFloat:(float)value { [self setY:[self formatFloat:value]]; }

- (void)setRadius:(id)value { [self param:@"radius" value:value]; }
- (id)radius { return [_params valueForKey:@"radius"]; }
- (void)setRadiusWithInt:(int)value { [self setRadius:@(value)]; }

- (void)setQuality:(id)value { [self param:@"quality" value:value]; }
- (id)quality { return [_params valueForKey:@"quality"]; }
- (void)setQualityWithFloat:(float)value { [self setQuality:@(value)]; }

- (void)setDefaultImage:(NSString *)value { [self param:@"default_image" value:value]; }
- (NSString *)defaultImage { return [_params valueForKey:@"default_image"]; }

- (void)setGravity:(NSString *)value { [self param:@"gravity" value:value]; }
- (NSString *)gravity { return [_params valueForKey:@"gravity"]; }

- (void)setColorSpace:(NSString *)value { [self param:@"color_space" value:value]; }
- (NSString *)colorSpace { return [_params valueForKey:@"color_space"]; }

- (void)setPrefix:(NSString *)value { [self param:@"prefix" value:value]; }
- (NSString *) prefix { return [_params valueForKey:@"prefix"]; }

- (void)setOverlay:(NSString *)value { [self param:@"overlay" value:value]; }
- (NSString *) overlay { return [_params valueForKey:@"overlay"]; }

- (void)setUnderlay:(NSString *)value { [self param:@"underlay" value:value]; }
- (NSString *)underlay { return [_params valueForKey:@"underlay"]; }

- (void)setFetchFormat:(NSString *)value { [self param:@"fetch_format" value:value]; }
- (NSString *) fetchFormat { return [_params valueForKey:@"fetch_format"]; }

- (void)setDensity:(id)value { [self param:@"density" value:value]; }
- (id) density { return [_params valueForKey:@"density"]; }
- (void)setDensityWithInt:(int)value { [self setDensity:@(value)]; }

- (void)setPage:(id)value { [self param:@"page" value:value]; }
- (id) page { return [_params valueForKey:@"page"]; }
- (void) setPageWithInt:(int)value { [self setPage:@(value)]; }

- (void)setDelay:(id)value { [self param:@"delay" value:value]; }
- (id)delay { return [_params valueForKey:@"delay"]; }
- (void)setDelayWithInt:(int) value { [self setDelay:@(value)]; }

- (void)setRawTransformation:(NSString *)value { [self param:@"raw_transformation" value:value]; }
- (id)rawTransformation { return [_params valueForKey:@"raw_transformation"]; }

- (void)setFlags:(id)value { [self param:@"flags" value:value]; }
- (id)flags { return [_params valueForKey:@"flags"]; }

- (void)setDpr:(id)value { [self param:@"dpr" value:value]; }
- (id)dpr { return [_params valueForKey:@"dpr"]; }
- (void)setDprWithFloat:(float)value { [self setDpr:[self formatFloat:value]]; }

- (void)setZoom:(id)value { [self param:@"zoom" value:value]; }
- (id)zoom { return [_params valueForKey:@"zoom"]; }
- (void)setZoomWithFloat:(float)value { [self setZoom:[self formatFloat:value]]; }

- (void)setAspectRatio:(NSString *)value { [self param:@"aspect_ratio" value:value]; }
- (void)setAspectRatioWithNominator:(int)nom andDemominator:(int)denom { [self setAspectRatio:[NSString stringWithFormat:@"%d:%d", nom, denom]]; }
- (void)setAspectRatioWithFloat:(float)value { [self setAspectRatio:[self formatFloat:value]]; }
- (NSString *)aspectRatio { return [_params valueForKey:@"aspect_ratio"]; }

- (void)setAudioCodec:(NSString *)value { [self param:@"audio_codec" value:value]; }
- (NSString *)audioCodec { return [_params valueForKey:@"audio_codec"]; }

- (void)setAudioFrequency:(id)value { [self param:@"audio_frequency" value:value]; }
- (id)audioFrequency { return [_params valueForKey:@"audio_frequency"]; }
- (void)setAudioFrequencyWithInt:(int)value { [self setAudioFrequency:@(value)]; }

- (void)setBitRate:(id)value { [self param:@"bit_rate" value:value]; }
- (id)bitRate { return [_params valueForKey:@"bit_rate"]; }
- (void)setBitRateWithInt:(int)value { [self setBitRate:@(value)]; }
- (void)setBitRateKilobytesWithInt:(int)value { [self setBitRate:[NSString stringWithFormat:@"%dk", value]]; }

- (void)setVideoSampling:(id)value { [self param:@"video_sampling" value:value]; }
- (id)videoSampling { return [_params valueForKey:@"video_sampling"]; }
- (void)setVideoSamplingDelayWithFloat:(float)value { [self setVideoSampling:[NSString stringWithFormat:@"%@s", [self formatFloat:value]]]; }
- (void)setVideoSamplingFramesWithInt:(int)value { [self setVideoSampling:@(value)]; }

- (void)setDuration:(id)value { [self param:@"duration" value:value]; }
- (id)duration { return [_params valueForKey:@"duration"]; }
- (void)setDurationSecondsWithFloat:(float)value { [self setDuration:@(value)]; }
- (void)setDurationPercentsWithFloat:(float)value { [self setDuration:[NSString stringWithFormat:@"%@p", [self formatFloat:value]]]; }

- (void)setStartOffset:(id)value { [self param:@"start_offset" value:value]; }
- (id)startOffset { return [_params valueForKey:@"start_offset"]; }
- (void)setStartOffsetSecondsWithFloat:(float)value { [self setStartOffset:@(value)]; }
- (void)setStartOffsetPercentsWithFloat:(float)value { [self setStartOffset:[NSString stringWithFormat:@"%@p", [self formatFloat:value]]]; }

- (void)setEndOffset:(id)value { [self param:@"end_offset" value:value]; }
- (id)endOffset { return [_params valueForKey:@"end_offset"]; }
- (void)setEndOffsetSecondsWithFloat:(float)value { [self setEndOffset:@(value)]; }
- (void)setEndOffsetPercentsWithFloat:(float)value { [self setEndOffset:[NSString stringWithFormat:@"%@p", [self formatFloat:value]]]; }

- (void)setStartOffsetSecondsWithFloat:(float)startOffsetSeconds andEndOffsetSeconds:(float)endOffsetSeconds { [self setStartOffsetSecondsWithFloat: startOffsetSeconds]; [self setEndOffsetSecondsWithFloat:endOffsetSeconds]; };
- (void)setStartOffsetPercentsWithFloat:(float)startOffsetPercents andEndOffsetPercents:(float)endOffsetPercents { [self setStartOffsetPercentsWithFloat:startOffsetPercents]; [self setEndOffsetSecondsWithFloat:endOffsetPercents];}

- (void)setVideoCodec:(NSString *)value { [self param:@"video_codec" value:value]; }
- (NSString *)videoCodec { return [_params valueForKey:@"video_codec"]; }
- (void)setVideoCodec:(NSString*)videoCodec andVideoProfile:(NSString*)videoProfile { [self setVideoCodec:[NSString stringWithFormat:@"%@:%@", videoCodec, videoProfile]]; }
- (void)setVideoCodec:(NSString*)videoCodec andVideoProfile:(NSString*)videoProfile andLevel:(NSString*)level { [self setVideoCodec:[NSString stringWithFormat:@"%@:%@:%@", videoCodec, videoProfile, level]]; }

- (void)setOverlayWithLayer:(CLLayer*)layer { [self setOverlay:[layer generate:@"overlay"]];}
- (void)setUnderlayWithLayer:(CLLayer*)layer { [self setUnderlay:[layer generate:@"underlay"]];}

- (void)setParams:(NSDictionary *)value
{
    [_params addEntriesFromDictionary:value];
}
- (NSDictionary*)params { return _params; }

- (void)chain;
{
    _params = [NSMutableDictionary dictionary];
    [_transformations addObject: _params];
}
- (void)param:(NSString *)param value:(id)value
{
    [_params setValue:value forKey:param];
}
- (NSString*)generate
{
    NSMutableArray* components = [NSMutableArray array];
    for (NSDictionary* options in _transformations) {
        [components addObject:[self generateWithParams:options]];
    }
    return [components componentsJoinedByString:@"/"];
}

- (NSString*) formatFloat:(float)value
{
    return [NSString stringWithFormat:@"%1.1f", value];
}

- (NSString*)generateWithParams:(NSDictionary *)options
{
    NSString* width = [CLCloudinary asString:[options valueForKey:@"width"]];
    NSString* height = [CLCloudinary asString:[options valueForKey:@"height"]];
    NSString* size = [options valueForKey:@"size"];
    if (size != nil)
    {
        NSArray* sizeComponents = [size componentsSeparatedByString:@"x"];
        width = sizeComponents[0];
        height = sizeComponents[1];
    }
    _htmlWidth = width;
    _htmlHeight = height;
    BOOL hasLayer = [[options valueForKey:@"overlay"] length] > 0 || [[options valueForKey:@"underlay"] length] > 0;
    
    NSString* crop = [options valueForKey:@"crop"];
    NSString* angle = [[CLCloudinary asArray:[options valueForKey:@"angle"]] componentsJoinedByString:@"."];
    
    BOOL noHtmlSizes = hasLayer || [angle length] > 0 || [crop isEqualToString:@"fit"] || [crop isEqualToString:@"limit"];
    
    if (width != nil && ([width rangeOfString:@"."].location != NSNotFound || noHtmlSizes))
    {
        _htmlWidth = nil;
    }
    if (height != nil && ([height rangeOfString:@"."].location != NSNotFound || noHtmlSizes))
    {
        _htmlHeight = nil;
    }
    
    NSString* background = [options valueForKey:@"background"];
    if (background != nil)
    {
        background = [background stringByReplacingOccurrencesOfString:@"#" withString:@"rgb:"];
    }
    NSString* color = [options valueForKey:@"color"];
    if (color != nil)
    {
        color = [color stringByReplacingOccurrencesOfString:@"#" withString:@"rgb:"];
    }
    NSArray* transformationParam = [CLCloudinary asArray:[options valueForKey:@"transformation"]];
    BOOL allNamed = TRUE;
    for (id trans in transformationParam) {
        if (![trans isKindOfClass:[NSString class]])
        {
            allNamed = FALSE;
            break;
        }
    }

    NSString* namedTransformations = nil;
    NSMutableArray* baseTransformations = [NSMutableArray array];
    if (allNamed)
    {
        namedTransformations = [transformationParam componentsJoinedByString:@"."];
    }
    else
    {
        for (id trans in transformationParam) {
            if ([trans isKindOfClass:[NSString class]])
            {
                NSDictionary* transOptions = @{@"transformation": trans};
                [baseTransformations addObject:[self generateWithParams:transOptions]];
            }
            else
            {
                [baseTransformations addObject:[self generateWithParams:trans]];                
            }
        }
    }
    NSString* flags = [[CLCloudinary asArray:[options valueForKey:@"flags"]] componentsJoinedByString:@"."];

    NSMutableArray* transformation = [NSMutableArray array];
    if (width)      [transformation addObject:@[@"w", width]];
    if (height)     [transformation addObject:@[@"h", height]];
    if (namedTransformations) [transformation addObject:@[@"t", namedTransformations]];
    if (crop)       [transformation addObject:@[@"c", crop]];
    if (background) [transformation addObject:@[@"b", background]];
    if (color)      [transformation addObject:@[@"co", color]];
    if (angle)      [transformation addObject:@[@"a", angle]];
    if (flags)      [transformation addObject:@[@"fl", flags]];
    
    NSArray* simpleParams = @[
        @"ac", @"audio_codec",
        @"af", @"audio_frequency",
        @"ar", @"aspect_ratio",
        @"bo", @"border",
        @"br", @"bit_rate",
        @"cs", @"color_space",
        @"d", @"default_image",
        @"dl", @"delay",
        @"dn", @"density",
        @"dpr", @"dpr",
        @"du", @"duration",
        @"e", @"effect",
        @"eo", @"end_offset",
        @"f", @"fetch_format",
        @"g", @"gravity",
        @"l", @"overlay",
        @"p", @"prefix",
        @"pg", @"page",
        @"q", @"quality",
        @"r", @"radius",
        @"so", @"start_offset",
        @"u", @"underlay",
        @"vs", @"video_sampling",
        @"vc", @"video_codec",
        @"x", @"x",
        @"y", @"y",
        @"z", @"zoom",
        ];
    for (int i = 0; i < [simpleParams count]; i+=2)
    {
        NSString* paramShort = simpleParams[i];
        NSString* paramName = simpleParams[i+1];
        NSString* value = [CLCloudinary asString:[options valueForKey:paramName]];
        if (value) [transformation addObject:@[paramShort, value]];
    }
    [transformation sortUsingComparator: ^(NSArray* obj1, NSArray* obj2) {
        NSString* name1 = obj1[0];
        NSString* name2 = obj2[0];
        return [name1 compare:name2];
    }];
    
    NSMutableArray* components = [NSMutableArray array];
    for (NSArray* param in transformation) {
        if ([param count] == 1) continue;
        NSString* paramName = param[0];
        NSString* paramValue = param[1];
        if ([paramValue length] > 0)
        {
            NSArray* encoded = @[paramName, paramValue];
            [components addObject:[encoded componentsJoinedByString:@"_"]];            
        }
    }
    NSString* rawTransformation = [options valueForKey:@"raw_transformation"];
    if ([rawTransformation length] > 0)
    {
        [components addObject:rawTransformation];
    }

    if ([components count] > 0)
    {
        [baseTransformations addObject:[components componentsJoinedByString:@","]];
    }
    return [baseTransformations componentsJoinedByString:@"/"];
}

@end
