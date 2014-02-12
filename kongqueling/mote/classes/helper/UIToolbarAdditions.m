//
//  UIToolbarAdditions.m
//  wochacha
//
//  Created by Alen Zhou on 3/6/12.
//  Copyright (c) 2012 wochacha. All rights reserved.
//

#import "UIToolbarAdditions.h"

@implementation UIToolbar (Additions)

- (UIBarButtonItem*)itemWithTag:(NSInteger)tag {
    for (UIBarButtonItem* button in self.items) {
        if (button.tag == tag) {
            return button;
        }
    }
    return nil;
}

- (void)replaceItemWithTag:(NSInteger)tag withItem:(UIBarButtonItem*)item {
    NSInteger buttonIndex = 0;
    for (UIBarButtonItem* button in self.items) {
        if (button.tag == tag) {
            NSMutableArray* newItems = [NSMutableArray arrayWithArray:self.items];
            [newItems replaceObjectAtIndex:buttonIndex withObject:item];
            self.items = newItems;
            break;
        }
        ++buttonIndex;
    }
}

@end
