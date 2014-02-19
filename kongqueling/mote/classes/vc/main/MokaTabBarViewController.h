//
//  MokaTabBarViewController.h
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MokaTabBarViewController : UITabBarController

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex;
- (void) setBadgeNumer:(int)index number:(int)numer;
@end
