//
//  MyTaskListTableViewCell.h
//  mote
//
//  Created by sean on 1/9/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTaskDateTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UILabel *labelDescription;

@end
