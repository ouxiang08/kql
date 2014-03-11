//
//  MyInvitationTableViewCell.h
//  mote
//
//  Created by sean on 1/2/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInvitationTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewRate;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UILabel *labelArea;
@property(nonatomic, strong) IBOutlet UILabel *labelTag;
@property (strong, nonatomic) IBOutlet UIButton *buttonSend;
@end
