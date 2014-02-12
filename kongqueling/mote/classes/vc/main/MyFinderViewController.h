//
//  MyFinderViewController.h
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFinderViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewFinderList;
@property(nonatomic, strong) IBOutlet UIButton *buttonArea;
@property(nonatomic, strong) IBOutlet UIButton *buttonIndustry;
@property(nonatomic, strong) IBOutlet UIButton *buttonDefault;


@end
