//
//  ChoosingMokaPictureCell.m
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "SetHomePictureTableViewCell.h"

@implementation SetHomePictureTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self = [[[NSBundle mainBundle] loadNibNamed:@"SetHomePictureTableViewCell" owner:self options:nil] lastObject];
    }
    
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    self.imageView3.image = nil;
    self.imageView4.image = nil;

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
