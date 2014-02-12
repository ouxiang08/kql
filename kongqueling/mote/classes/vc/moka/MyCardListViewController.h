//
//  MyCardListViewController.h
//  mote
//
//  Created by sean on 12/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface MyCardListViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewCardList;
@property (weak, nonatomic) IBOutlet UIImageView *bgimgv;

@end
