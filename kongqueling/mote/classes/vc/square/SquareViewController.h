//
//  PiazzaViewController.h
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIButton *buttonGender;
@property(nonatomic, strong) IBOutlet UIButton *buttonCate;
@property(nonatomic, strong) IBOutlet UIButton *buttonDefault;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;

@end
