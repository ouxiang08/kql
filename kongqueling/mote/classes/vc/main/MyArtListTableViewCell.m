//
//  MyArtListTableViewCell.m
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MyArtListTableViewCell.h"

@implementation MyArtListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MyArtListTableViewCell" owner:self options:nil] lastObject];
    if (self) {
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
