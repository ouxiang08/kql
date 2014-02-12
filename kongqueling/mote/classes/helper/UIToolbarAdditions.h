//
//  UIToolbarAdditions.h
//  wochacha
//
//  Created by Alen Zhou on 3/6/12.
//  Copyright (c) 2012 wochacha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIToolbar (Additions) 

// get the BarButtonItem with its tag
- (UIBarButtonItem*)itemWithTag:(NSInteger)tag;

// replace the item with specified tag to another specified BarButtonItem
- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item;

@end
