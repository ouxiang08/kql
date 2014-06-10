//
//  AppDelegate.h
//  mote
//
//  Created by sean on 11/5/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BPush.h"
#import "MokaTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BPushDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
@property (strong ,nonatomic) MokaTabBarViewController *mokaTabBar;
@property (strong ,nonatomic) NSString *downloadurl;

@end
