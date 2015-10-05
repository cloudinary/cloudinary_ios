//
//  CLLayer.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 9/25/15.
//  Copyright © 2015 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLLayer : NSObject

+ (id)layer;

@property NSString* publicId;
@property NSString* format;
@property NSString* text;
@property NSString* resourceType;
@property NSString* type;
@property NSString* fontFamily;
@property NSString* fontSize;
- (void) setFontSizeWithInt:(int)fontSize;
@property NSString* fontStyle;
@property NSString* fontWeight;
@property NSString* textDecoration;
@property NSString* textAlign;
@property NSString* stroke;
@property NSString* letterSpacing;
- (void) setLetterSpacingWithInt:(int)letterSpacing;
- (void) setLetterSpacingWithFloat:(float)letterSpacing;

- (NSString*) generate:(NSString*)layerParameter;
@end
