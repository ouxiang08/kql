//
//  MyAppListTableViewCell.m
//  mote
//
//  Created by sean on 12/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MyAppListTableViewCell.h"

@implementation MyAppListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyAppListTableViewCell" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
