//
//  MyInvitationListViewController.h
//  mote
//
//  Created by sean on 1/2/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface MyInvitationListViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewInvitation;
@property(nonatomic, assign) int iStatus;

@end
