//
//  UIFontAdditions.m
//  wochacha
//
//  Created by Alen Zhou on 4/11/12.
//  Copyright (c) 2012 wochacha. All rights reserved.
//

#import "UIFontAdditions.h"

@implementation UIFont (Additions)

- (CGFloat)lineHeight
{
    return self.ascender - self.descender + 1.0;
}

@end
