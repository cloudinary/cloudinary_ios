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
{
	NSMutableDictionary* params;
	NSMutableArray* transformations;
	NSString* htmlWidth;
	NSString* htmlHeight;
}

- (NSString*) generateWithParams:(NSDictionary*) params;
@end;


@implementation CLTransformation

@synthesize htmlHeight;
@synthesize htmlWidth;

- (id) init
{
    return [self initWithDictionaries:[NSArray array]];
}

- (id) initWithDictionaries: (NSArray*) dictionaries
{
    if ( self = [super init] )
    {
        transformations = [NSMutableArray arrayWithArray:dictionaries];
        [self chain];
    }
    return self;
}


+ (id) transformation
{
    return [[CLTransformation alloc] init];
}

- (void) setWidth: (id) value { [self param:@"width" value:value]; }
- (id) width { return [params valueForKey:@"width"]; }
- (void) setWidthWithInt: (int) value { [self setWidth:[NSNumber numberWithInt:value]]; }
- (void) setWidthWithFloat: (float) value { [self setWidth:[NSNumber numberWithFloat:value]]; }
- (void) setHeight: (id) value { [self param:@"height" value:value]; }
- (id) height { return [params valueForKey:@"height"]; }
- (void) setHeightWithInt: (int) value { [self setHeight:[NSNumber numberWithInt:value]]; }
- (void) setHeightWithFloat: (float) value { [self setHeight:[NSNumber numberWithFloat:value]]; }
- (void) setNamed: (id) value { [self param:@"transformation" value:value]; }
- (id) named { return [params valueForKey:@"transformation"]; }

- (void) setCrop: (NSString *) value { [self param:@"crop" value:value]; }
- (NSString *) crop { return [params valueForKey:@"crop"]; }

- (void) setBackground: (NSString *) value { [self param:@"background" value:value]; }
- (NSString *) background { return [params valueForKey:@"background"]; }

- (void) setEffect: (NSString *) value { [self param:@"effect" value:value]; }
- (NSString *) effect { return [params valueForKey:@"effect"]; }
- (void) setEffect: (NSString *) value param:(id) param
{
    [self setEffect:[NSString stringWithFormat:@"%@:%@", value, param]];
}
- (void) setAngle: (id) value { [self param:@"angle" value:value]; }
- (id) angle { return [params valueForKey:@"angle"]; }
- (void) setAngleWithInt: (int) value { [self setAngle:[NSNumber numberWithInt:value]]; }
- (void) setBorder: (NSString *) value { [self param:@"border" value:value]; }
- (NSString *) border { return [params valueForKey:@"border"]; }
- (void) setBorder: (int) width color:(NSString *) color
{
    color = [color stringByReplacingOccurrencesOfString:@"#" withString:@"rgb:"];
    [self setBorder:[NSString stringWithFormat:@"%dpx_solid_%@", width, color]];
}
- (void) setX: (id) value { [self param:@"x" value:value]; }
- (id) x { return [params valueForKey:@"x"]; }
- (void) setXWithInt: (int) value { [self setX:[NSNumber numberWithInt:value]]; }
- (void) setXWithFloat: (float) value { [self setX:[NSNumber numberWithFloat:value]]; }

- (void) setY: (id) value { [self param:@"y" value:value]; }
- (id) y { return [params valueForKey:@"y"]; }
- (void) setYWithInt: (int) value { [self setY:[NSNumber numberWithInt:value]]; }
- (void) setYWithFloat: (float) value { [self setY:[NSNumber numberWithFloat:value]]; }

- (void) setRadius: (id) value { [self param:@"radius" value:value]; }
- (id) radius { return [params valueForKey:@"radius"]; }
- (void) setRadiusWithInt: (int) value { [self setRadius:[NSNumber numberWithInt:value]]; }

- (void) setQuality: (id) value { [self param:@"quality" value:value]; }
- (id) quality { return [params valueForKey:@"quality"]; }
- (void) setQualityWithFloat: (float) value { [self setQuality:[NSNumber numberWithFloat:value]]; }

- (void) setDefaultImage: (NSString *) value { [self param:@"default_image" value:value]; }
- (NSString *) defaultImage { return [params valueForKey:@"default_image"]; }

- (void) setGravity: (NSString *) value { [self param:@"gravity" value:value]; }
- (NSString *) gravity { return [params valueForKey:@"gravity"]; }

- (void) setColorSpace: (NSString *) value { [self param:@"color_space" value:value]; }
- (NSString *) colorSpace { return [params valueForKey:@"color_space"]; }

- (void) setPrefix: (NSString *) value { [self param:@"prefix" value:value]; }
- (NSString *) prefix { return [params valueForKey:@"prefix"]; }

- (void) setOverlay: (NSString *) value { [self param:@"overlay" value:value]; }
- (NSString *) overlay { return [params valueForKey:@"overlay"]; }

- (void) setUnderlay: (NSString *) value { [self param:@"underlay" value:value]; }
- (NSString *) underlay { return [params valueForKey:@"underlay"]; }

- (void) setFetchFormat: (NSString *) value { [self param:@"fetch_format" value:value]; }
- (NSString *) fetchFormat { return [params valueForKey:@"fetch_format"]; }

- (void) setDensity: (id) value { [self param:@"density" value:value]; }
- (id) density { return [params valueForKey:@"density"]; }
- (void) setDensityWithInt: (int) value { [self setDensity:[NSNumber numberWithInt:value]]; }

- (void) setPage: (id) value { [self param:@"page" value:value]; }
- (id) page { return [params valueForKey:@"page"]; }
- (void) setPageWithInt: (int) value { [self setPage:[NSNumber numberWithInt:value]]; }

- (void) setDelay: (id) value { [self param:@"delay" value:value]; }
- (id) delay { return [params valueForKey:@"delay"]; }
- (void) setDelayWithInt: (int) value { [self setDelay:[NSNumber numberWithInt:value]]; }

- (void) setRawTransformation:(NSString *) value { [self param:@"raw_transformation" value:value]; }
- (id) rawTransformation { return [params valueForKey:@"raw_transformation"]; }

- (void) setFlags: (id) value { [self param:@"flags" value:value]; }
- (id) flags { return [params valueForKey:@"flags"]; }

- (void) setParams: (NSDictionary *) value
{
    [params addEntriesFromDictionary:value];
}
- (NSDictionary*) params { return params; }

- (void) chain;
{
    params = [NSMutableDictionary dictionary];
    [transformations addObject: params];
}
- (void) param: (NSString *) param value: (id) value
{
    [params setValue:value forKey:param];
}
- (NSString*) generate
{
    NSMutableArray* components = [NSMutableArray array];
    for (NSDictionary* options in transformations) {
        [components addObject:[self generateWithParams:options]];
    }
    return [components componentsJoinedByString:@"/"];
}

- (NSString*) generateWithParams:(NSDictionary*) options
{
    NSString* width = [CLCloudinary asString:[options valueForKey:@"width"]];
    NSString* height = [CLCloudinary asString:[options valueForKey:@"height"]];
    NSString* size = [options valueForKey:@"size"];
    if (size != nil)
    {
        NSArray* sizeComponents = [size componentsSeparatedByString:@"x"];
        width = [sizeComponents objectAtIndex:0];
        height = [sizeComponents objectAtIndex:1];
    }
    htmlWidth = width;
    htmlHeight = height;
    BOOL hasLayer = [[options valueForKey:@"overlay"] length] > 0 || [[options valueForKey:@"underlay"] length] > 0;
    
    NSString* crop = [options valueForKey:@"crop"];
    NSString* angle = [[CLCloudinary asArray:[options valueForKey:@"angle"]] componentsJoinedByString:@"."];
    
    BOOL noHtmlSizes = hasLayer || [angle length] > 0 || [crop isEqualToString:@"fit"] || [crop isEqualToString:@"limit"];
    
    if (width != nil && ([width rangeOfString:@"."].location != NSNotFound || noHtmlSizes))
    {
        htmlWidth = nil;
    }
    if (height != nil && ([height rangeOfString:@"."].location != NSNotFound || noHtmlSizes))
    {
        htmlHeight = nil;
    }
    
    NSString* background = [options valueForKey:@"background"];
    if (background != nil)
    {
        background = [background stringByReplacingOccurrencesOfString:@"#" withString:@"rgb:"];
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
                NSDictionary* transOptions = [NSDictionary dictionaryWithObject:trans forKey:@"transformation"];
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
    [transformation addObject:[NSArray arrayWithObjects:@"w", width, nil]];
    [transformation addObject:[NSArray arrayWithObjects:@"h", height, nil]];
    [transformation addObject:[NSArray arrayWithObjects:@"t", namedTransformations, nil]];
    [transformation addObject:[NSArray arrayWithObjects:@"c", crop, nil]];
    [transformation addObject:[NSArray arrayWithObjects:@"b", background, nil]];
    [transformation addObject:[NSArray arrayWithObjects:@"a", angle, nil]];
    [transformation addObject:[NSArray arrayWithObjects:@"fl", flags, nil]];
    NSArray* simpleParams = [NSArray arrayWithObjects:
        @"x", @"x", @"y", @"y", @"r", @"radius", @"d", @"default_image", @"g", @"gravity", @"cs", @"color_space",
        @"p", @"prefix", @"l", @"overlay", @"u", @"underlay", @"f", @"fetch_format", @"dn", @"density",
        @"pg", @"page", @"dl", @"delay", @"e", @"effect", @"bo", @"border", @"q", @"quality", nil
    ];
    for (int i = 0; i < [simpleParams count]; i+=2)
    {
        NSString* paramShort = [simpleParams objectAtIndex:i];
        NSString* paramName = [simpleParams objectAtIndex:i+1];
        NSString* value = [CLCloudinary asString:[options valueForKey:paramName]];
        [transformation addObject:[NSArray arrayWithObjects:paramShort, value, nil]];
    }
    [transformation sortUsingComparator: ^(NSArray* obj1, NSArray* obj2) {
        NSString* name1 = [obj1 objectAtIndex:0];
        NSString* name2 = [obj2 objectAtIndex:0];
        return [name1 compare:name2];
    }];
    
    NSMutableArray* components = [NSMutableArray array];
    for (NSArray* param in transformation) {
        if ([param count] == 1) continue;
        NSString* paramName = [param objectAtIndex:0];
        NSString* paramValue = [param objectAtIndex:1];
        if ([paramValue length] > 0)
        {
            NSArray* encoded = [NSArray arrayWithObjects:paramName, paramValue, nil];
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
