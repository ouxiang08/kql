//
//  StartPageViewController.h
//  mote
//
//  Created by harry on 14-1-1.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface StartPageViewController : UIViewController

- (IBAction)clickLogin:(id)sender;
- (IBAction)clickReg:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (weak, nonatomic) IBOutlet UIButton *btLogin;
@property (weak, nonatomic) IBOutlet UILabel *lblReg;
@property (weak, nonatomic) IBOutlet UIButton *btReg;
@end
