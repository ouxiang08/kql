//
//  AreaViewController.h
//  mote
//
//  Created by sean on 1/26/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaChooseDelegate <NSObject>

-(void)chooseAreaWithName:(NSString *)str;

@end

@interface AreaViewController : UITableViewController

@property(nonatomic, strong) NSArray *arrArea;
@property(nonatomic, assign) id<AreaChooseDelegate>chooseAreaDelegate;

@end
