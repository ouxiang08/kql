//
//  MyTaskListTableViewCell.m
//  mote
//
//  Created by sean on 1/9/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "MyTaskListTableViewCell.h"

@implementation MyTaskListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
         self = [[[NSBundle mainBundle] loadNibNamed:@"MyTaskListTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
