//
//  ObjcBaseTestCase.m
//  Cloudinary_Tests
//
//  Created by Oz Deutsch on 24/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

#import "ObjcBaseTestCase.h"

@implementation ObjcBaseTestCase

- (BOOL)setUpWithError:(NSError *__autoreleasing  _Nullable *)error {
    
   XCTSkipIf([self shouldSkipTest], "test skipped");
    
   return [super setUpWithError:error];
}

/**
 override this method to skip tests when needed
*/
- (BOOL)shouldSkipTest {
    return false;
}

@end
