//
//  MessageListViewController.h
//  mote
//
//  Created by harry on 13-12-30.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface MessageListViewController : MokaNetworkController
@property(nonatomic, assign) int msgTypeId;
@property (weak, nonatomic) IBOutlet UITableView *msglistTableview;

@end
