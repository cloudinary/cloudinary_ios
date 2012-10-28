//
//  Transformation.h
//  Cloudinary
//
//  Created by Tal Lev-Ami on 25/10/12.
//  Copyright (c) 2012 Cloudinary Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transformation : NSObject
{
	NSMutableDictionary* transformation;
	NSMutableArray* transformations;
	NSString* htmlWidth;
	NSString* htmlHeight;
}

- (id) initWithDictionaries: (NSArray*) transformations;
- (id) init;
+ (id) transformation;

- (void) width: (id) value;
- (void) iwidth: (int) value;
- (void) fwidth: (float) value;
- (void) height: (id) value;
- (void) iheight: (int) value;
- (void) fheight: (float) value;
- (void) named: (id) value; // Supports array
- (void) crop: (NSString *) value;
- (void) background: (NSString *) value;
- (void) effect: (NSString *) value;
- (void) effect: (NSString *) value param:(id) param;
- (void) angle: (id) value; // Supports array
- (void) iangle: (int) value; // Supports array
- (void) border: (NSString *) value;
- (void) border: (int) width color:(NSString *) color;
- (void) x: (id) value;
- (void) ix: (int) value;
- (void) fx: (float) value;
- (void) y: (id) value;
- (void) iy: (int) value;
- (void) fy: (float) value;
- (void) radius: (id) value;
- (void) iradius: (int) value;
- (void) quality: (id) value;
- (void) fquality: (float) value;
- (void) defaultImage: (NSString *) value;
- (void) gravity: (NSString *) value;
- (void) colorSpace: (NSString *) value;
- (void) prefix: (NSString *) value;
- (void) overlay: (NSString *) value;
- (void) underlay: (NSString *) value;
- (void) fetchFormat: (NSString *) value;
- (void) density: (id) value;
- (void) idensity: (int) value;
- (void) page: (id) value;
- (void) ipage: (int) value;
- (void) delay: (id) value;
- (void) idelay: (int) value;
- (void) rawTransformation: (NSString *) value;
- (void) flags: (NSString *) value; // Supports array

- (void) params: (NSDictionary *) value;
- (void) chain;
- (void) param: (NSString *) param value: (id) value;
- (NSString*) generate;
- (NSString*) generateWithDictionaries:(NSArray*) dictionaries;
- (NSString*) generateWithOptions:(NSDictionary*) options;
- (NSString*) htmlWidth;
- (NSString*) htmlHeight;

@end
