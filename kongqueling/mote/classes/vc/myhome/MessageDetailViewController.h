//
//  MessageDetailViewController.h
//  mote
//
//  Created by harry on 13-12-30.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"


@interface MessageDetailViewController : MokaNetworkController
@property(nonatomic, assign) int msgTypeId;
@property(nonatomic, strong) NSDictionary *msgInfo;

@end
