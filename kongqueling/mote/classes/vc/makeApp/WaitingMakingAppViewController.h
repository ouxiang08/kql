//
//  WaitingMakingAppViewController.h
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface WaitingMakingAppViewController : MokaNetworkController

@property (nonatomic, strong)  NSArray *arrImage;
@property (nonatomic, strong) NSDictionary *dictMusic;
@property (nonatomic, strong) NSString *strAppName;
@property (nonatomic, strong) NSString *strHomePath;
@property (weak, nonatomic) IBOutlet UIImageView *imgvCycle;

@end
