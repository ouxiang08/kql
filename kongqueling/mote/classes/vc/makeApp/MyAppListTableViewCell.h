//
//  MyAppListTableViewCell.h
//  mote
//
//  Created by sean on 12/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAppListTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UILabel *labelDateTime;
@property(nonatomic, strong) IBOutlet UIButton *buttonInstall;
@property(nonatomic, strong) IBOutlet UIButton *buttonShare;

@end
