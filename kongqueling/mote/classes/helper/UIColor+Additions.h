//
//  UIColor+Additions.h
//  wochacha
//
//  Created by Alen Zhou on 11/2/12.
//  Copyright (c) 2012 wochacha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Additions)

// String RGB like #123456 or 123456
+ (UIColor *)colorWithStringRGB:(NSString*)RGB;

// Integer RGB from 0 to 255
+ (UIColor *)colorWithIntRed:(NSUInteger)red intGreen:(NSUInteger)green intBlue:(NSUInteger)blue alpha:(CGFloat)alpha;

@end
