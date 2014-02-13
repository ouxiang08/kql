//
//  ChoosingMokaPictureCell.m
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingAppPictureCell.h"

@implementation ChoosingAppPictureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         self = [[[NSBundle mainBundle] loadNibNamed:@"ChoosingMokaPictureCell" owner:self options:nil] lastObject];
    }
    
    self.imageView1.image = nil;
    self.imageView2.image = nil;
    self.imageView3.image = nil;
    self.imageView4.image = nil;
    
    self.buttonSelected1.tag = -1;
    self.buttonSelected2.tag = -1;
    self.buttonSelected3.tag = -1;
    self.buttonSelected4.tag = -1;
    
    [self.buttonSelected1 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    [self.buttonSelected2 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    [self.buttonSelected3 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    [self.buttonSelected4 setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
