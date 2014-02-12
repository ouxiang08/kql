//
//  UIColor+Additions.m
//  wochacha
//
//  Created by Alen Zhou on 11/2/12.
//  Copyright (c) 2012 wochacha. All rights reserved.
//

#import "UIColor+Additions.h"
#import "NSString+Additions.h"

@implementation UIColor (Additions)

+ (UIColor*)colorWithStringRGB:(NSString*)RGB
{
    UIColor* color = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"^#?[0-9a-fA-F]{6}$"
                                                                           options:0
                                                                             error:NULL];
    
    NSUInteger number = [regex numberOfMatchesInString:RGB options:0 range:NSMakeRange(0, RGB.length)];
    
    if (number) {
        if ('#' == [RGB characterAtIndex:0]) {
            RGB = [RGB substringFromIndex:1];
        }
        NSUInteger red = [[RGB substringWithRange:NSMakeRange(0, 2)] integerValueFromHex];
        NSUInteger green = [[RGB substringWithRange:NSMakeRange(2, 2)] integerValueFromHex];
        NSUInteger blue = [[RGB substringWithRange:NSMakeRange(4, 2)] integerValueFromHex];
        color = [UIColor colorWithIntRed:red intGreen:green intBlue:blue alpha:1.0];
    }
    return color;
}

+ (UIColor*)colorWithIntRed:(NSUInteger)red intGreen:(NSUInteger)green intBlue:(NSUInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

@end
