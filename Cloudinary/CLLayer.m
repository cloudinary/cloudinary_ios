//
//  CLLayer.m
//  Cloudinary
//
//  Created by Tal Lev-Ami on 9/25/15.
//  Copyright © 2015 Cloudinary Ltd. All rights reserved.
//

#import "CLLayer.h"
#import "NSString+CLURLEncoding.h"

@implementation CLLayer {
    
}

+ (id)layer
{
    return [[CLLayer alloc] init];
}

- (void) setFontSizeWithInt:(int)fontSize { [self setFontSize:[NSString stringWithFormat:@"%d", fontSize]]; }
- (void) setLetterSpacingWithInt:(int)letterSpacing { [self setLetterSpacing:[NSString stringWithFormat:@"%d", letterSpacing]]; }
- (void) setLetterSpacingWithFloat:(float)letterSpacing { [self setLetterSpacing:[NSString stringWithFormat:@"%1.1f", letterSpacing]]; }

- (NSString*) generateTextOptions:(NSString*)layerParameter {
    NSMutableArray* keywords = [NSMutableArray array];
    if ([self.fontWeight length] > 0 && ![self.fontWeight isEqualToString:@"normal"]) [keywords addObject:self.fontWeight];
    if ([self.fontStyle length] > 0 && ![self.fontStyle isEqualToString:@"normal"]) [keywords addObject:self.fontStyle];
    if ([self.textDecoration length] > 0 && ![self.textDecoration isEqualToString:@"none"]) [keywords addObject:self.textDecoration];
    if ([self.textAlign length] > 0) [keywords addObject:self.textAlign];
    if ([self.stroke length] > 0 && ![self.stroke isEqualToString:@"none"]) [keywords addObject:self.stroke];
    if ([self.letterSpacing length] > 0) [keywords addObject:[NSString stringWithFormat:@"letter_spacing_%@", self.letterSpacing]];
    bool hasTextOptions = [self.fontSize length] > 0 || [self.fontFamily length] > 0 || [keywords count] > 0;
    if (!hasTextOptions) return NULL;
    if ([self.fontFamily length] == 0) {
        [NSException raise:@"CloudinaryError" format:@"Must supply fontFamily for text in %@", layerParameter];
    }
    if ([self.fontSize length] == 0) {
        [NSException raise:@"CloudinaryError" format:@"Must supply fontSize for text in %@", layerParameter];
    }
    [keywords insertObject:self.fontSize atIndex:0];
    [keywords insertObject:self.fontFamily atIndex:0];
    return [keywords componentsJoinedByString:@"_"];
}

- (NSString*) generate:(NSString*)layerParameter {
    NSMutableArray* components = [NSMutableArray array];
    NSString* text = self.text;
    NSString* publicId = self.publicId;
    NSString* resourceType = self.resourceType;
    if ([text length] > 0 && [resourceType length] == 0) resourceType = @"text";
    if ([publicId length] > 0 && [self.format length] > 0) publicId = [NSString stringWithFormat:@"%@.%@", publicId, self.format];
    if ([publicId length] == 0 && ![resourceType isEqualToString:@"text"]) {
        [NSException raise:@"CloudinaryError" format:@"Must supply publicId for non-text %@", layerParameter];
    }
    if ([resourceType length] > 0 && ![resourceType isEqualToString:@"image"]) [components addObject:resourceType];
    if ([self.type length] > 0 && ![self.type isEqualToString:@"upload"]) [components addObject:self.type];
    if ([resourceType isEqualToString:@"text"] || [resourceType isEqualToString:@"subtitles"]) {
        if ([text length] == 0 && [publicId length] == 0) {
            [NSException raise:@"CloudinaryError" format:@"Must supply either text or publicId in %@", layerParameter];
        }
        NSString* textOptions = [self generateTextOptions:layerParameter];
        if ([textOptions length] > 0) {
            [components addObject:textOptions];
        }
        if ([publicId length] > 0) {
            [components addObject:[publicId stringByReplacingOccurrencesOfString:@"/" withString:@":"]];
        }
        if ([text length] > 0) {
            text = [text cl_smartEncodeUrl:NSUTF8StringEncoding];
            text = [text stringByReplacingOccurrencesOfString:@"%2C" withString:@"%E2%80%9A"];
            text = [text stringByReplacingOccurrencesOfString:@"/" withString:@"%E2%81%84"];
            [components addObject:text];
        }
    } else {
        [components addObject:[publicId stringByReplacingOccurrencesOfString:@"/" withString:@":"]];
    }
    
    return [components componentsJoinedByString:@":"];
}

@end
