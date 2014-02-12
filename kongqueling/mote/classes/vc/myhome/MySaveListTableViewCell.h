//
//  MyFinderTableViewCell.h
//  mote
//
//  Created by sean on 12/24/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySaveListTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewRate;
@property(nonatomic, strong) IBOutlet UILabel *labelArea;
@property(nonatomic, strong) IBOutlet UILabel *labelIndustry;
@property(nonatomic, strong) IBOutlet UIButton *buttonSend;

@end
