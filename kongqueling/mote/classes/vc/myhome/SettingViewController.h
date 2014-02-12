//
//  SettingViewController.h
//  mote
//
//  Created by harry on 13-12-29.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface SettingViewController : MokaNetworkController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *formTableView;

@end
