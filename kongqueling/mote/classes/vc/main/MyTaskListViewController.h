//
//  MyTaskListViewController.h
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "DateViewController.h"
#import <UIKit/UIKit.h>

@interface MyTaskListViewController : MokaNetworkController

@property(nonatomic, strong) DateViewController *dateVC;
@property(nonatomic, strong) IBOutlet UITableView *tableViewList;
@property(nonatomic, strong) IBOutlet UITableView *tableViewDateTask;

@property(nonatomic, strong) NSDate *selectedDate;

@end
