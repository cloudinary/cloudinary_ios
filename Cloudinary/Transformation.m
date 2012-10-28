//
//  Transformation.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import "Transformation.h"
#import "Cloudinary.h"

@implementation Transformation

- (id) initWithDictionaries: (NSArray*) dictionaries
{
    if ( self = [super init] )
    {
        transformations = [NSMutableArray arrayWithArray:dictionaries];
        [self chain];
    }
    return self;
}

- (id) init
{
    return [self initWithDictionaries:[NSArray array]];
}

+ (id) transformation
{
    return [[Transformation alloc] init];
}

- (void) width: (id) value { [self param:@"width" value:value]; }
- (void) iwidth: (int) value { [self width:[NSNumber numberWithInt:value]]; }
- (void) fwidth: (float) value { [self width:[NSNumber numberWithFloat:value]]; }
- (void) height: (id) value { [self param:@"height" value:value]; }
- (void) iheight: (int) value { [self height:[NSNumber numberWithInt:value]]; }
- (void) fheight: (float) value { [self height:[NSNumber numberWithFloat:value]]; }
- (void) named: (id) value { [self param:@"transformation" value:value]; }
- (void) crop: (NSString *) value { [self param:@"crop" value:value]; }
- (void) background: (NSString *) value { [self param:@"background" value:value]; }
- (void) effect: (NSString *) value { [self param:@"effect" value:value]; }
- (void) effect: (NSString *) value param:(id) param
{
    [self effect:[NSString stringWithFormat:@"%@:%@", value, param]];
}
- (void) angle: (id) value { [self param:@"angle" value:value]; }
- (void) iangle: (int) value { [self angle:[NSNumber numberWithInt:value]]; }
- (void) border: (NSString *) value { [self param:@"border" value:value]; }
- (void) border: (int) width color:(NSString *) color
{
    color = [color stringByReplacingOccurrencesOfString:@"#" withString:@"rgb:"];
    [self border:[NSString stringWithFormat:@"%dpx_solid_%@", width, color]];
}
- (void) x: (id) value { [self param:@"x" value:value]; }
- (void) ix: (int) value { [self x:[NSNumber numberWithInt:value]]; }
- (void) fx: (float) value { [self x:[NSNumber numberWithFloat:value]]; }
- (void) y: (id) value { [self param:@"y" value:value]; }
- (void) iy: (int) value { [self y:[NSNumber numberWithInt:value]]; }
- (void) fy: (float) value { [self y:[NSNumber numberWithFloat:value]]; }
- (void) radius: (id) value { [self param:@"radius" value:value]; }
- (void) iradius: (int) value { [self radius:[NSNumber numberWithInt:value]]; }
- (void) quality: (id) value { [self param:@"quality" value:value]; }
- (void) fquality: (float) value { [self quality:[NSNumber numberWithFloat:value]]; }
- (void) defaultImage: (NSString *) value { [self param:@"default_image" value:value]; }
- (void) gravity: (NSString *) value { [self param:@"gravity" value:value]; }
- (void) colorSpace: (NSString *) value { [self param:@"color_space" value:value]; }
- (void) prefix: (NSString *) value { [self param:@"prefix" value:value]; }
- (void) overlay: (NSString *) value { [self param:@"overlay" value:value]; }
- (void) underlay: (NSString *) value { [self param:@"underlay" value:value]; }
- (void) fetchFormat: (NSString *) value { [self param:@"fetch_format" value:value]; }
- (void) density: (id) value { [self param:@"density" value:value]; }
- (void) idensity: (int) value { [self density:[NSNumber numberWithInt:value]]; }
- (void) page: (id) value { [self param:@"page" value:value]; }
- (void) ipage: (int) value { [self page:[NSNumber numberWithInt:value]]; }
- (void) delay: (id) value { [self param:@"delay" value:value]; }
- (void) idelay: (int) value { [self delay:[NSNumber numberWithInt:value]]; }
- (void) rawTransformation: (NSString *) value { [self param:@"raw_transformation" value:value]; }
- (void) flags: (id) value { [self param:@"flags" value:value]; }

- (void) params: (NSDictionary *) value
{
    [transformation addEntriesFromDictionary:value];
}
- (void) chain;
{
    transformation = [NSMutableDictionary dictionary];
    [transformations addObject: transformation];
}
- (void) param: (NSString *) param value: (id) value
{
    [transformation setValue:value forKey:param];
}
- (NSString*) htmlWidth
{
    return htmlWidth;
}
- (NSString*) htmlHeight
{
    return htmlHeight;
}
- (NSString*) generate
{
    return [self generateWithDictionaries:transformations];
}

- (NSString*) generateWithDictionaries:(NSArray*) dictionaries
{
    NSMutableArray* components = [NSMutableArray array];
    for (NSDictionary* options in dictionaries) {
        [components addObject:[self generateWithOptions:options]];
    }
    return [components componentsJoinedByString:@"/"];
}

- (NSString*) generateWithOptions:(NSDictionary*) options
{
    NSString* width = [Cloudinary asString:[options valueForKey:@"width"]];
    NSString* height = [Cloudinary asString:[options valueForKey:@"height"]];
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
    NSString* angle = [[Cloudinary asArray:[options valueForKey:@"angle"]] componentsJoinedByString:@"."];
    
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
    NSArray* transformationParam = [Cloudinary asArray:[options valueForKey:@"transformation"]];
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
                [baseTransformations addObject:[self generateWithOptions:transOptions]];
            }
            else
            {
                [baseTransformations addObject:[self generateWithOptions:trans]];                
            }
        }
    }
    NSString* flags = [[Cloudinary asArray:[options valueForKey:@"flags"]] componentsJoinedByString:@"."];
    
    NSMutableArray* params = [NSMutableArray array];
    [params addObject:[NSArray arrayWithObjects:@"w", width, nil]];
    [params addObject:[NSArray arrayWithObjects:@"h", height, nil]];
    [params addObject:[NSArray arrayWithObjects:@"t", namedTransformations, nil]];
    [params addObject:[NSArray arrayWithObjects:@"c", crop, nil]];
    [params addObject:[NSArray arrayWithObjects:@"b", background, nil]];
    [params addObject:[NSArray arrayWithObjects:@"a", angle, nil]];
    [params addObject:[NSArray arrayWithObjects:@"fl", flags, nil]];
    NSArray* simpleParams = [NSArray arrayWithObjects:
        @"x", @"x", @"y", @"y", @"r", @"radius", @"d", @"default_image", @"g", @"gravity", @"cs", @"color_space",
        @"p", @"prefix", @"l", @"overlay", @"u", @"underlay", @"f", @"fetch_format", @"dn", @"density",
        @"pg", @"page", @"dl", @"delay", @"e", @"effect", @"bo", @"border", @"q", @"quality", nil
    ];
    for (int i = 0; i < [simpleParams count]; i+=2)
    {
        NSString* paramShort = [simpleParams objectAtIndex:i];
        NSString* paramName = [simpleParams objectAtIndex:i+1];
        NSString* value = [Cloudinary asString:[options valueForKey:paramName]];
        [params addObject:[NSArray arrayWithObjects:paramShort, value, nil]];
    }
    [params sortUsingComparator: ^(NSArray* obj1, NSArray* obj2) {
        NSString* name1 = [obj1 objectAtIndex:0];
        NSString* name2 = [obj2 objectAtIndex:0];
        return [name1 compare:name2];
    }];
    
    NSMutableArray* components = [NSMutableArray array];
    for (NSArray* param in params) {
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
