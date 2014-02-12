//
//  AlbumPhotoCell.m
//  mote
//
//  Created by sean on 11/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "AlbumPhotoCell.h"

@implementation AlbumPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)onButtonClick:(id)sender{
    if (self.type == KNormalCell) {
        UIButton *button = (UIButton *)sender;
        [self.delegate selectPhotoWithIndex:button.tag];
    }else{
        UIButton *button = (UIButton *)sender;
        if (button == self.buttonLeft) {
            if (self.bButtonLeftSelected) {
                self.bButtonLeftSelected = NO;
                [self.buttonLeft setBackgroundImage:nil forState:UIControlStateNormal];
            }else{
                self.bButtonLeftSelected = YES;
                [self.buttonLeft setBackgroundImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            }
        }else  if (button == self.buttonMiddle) {
            if (self.bButtonMiddleSelected) {
                self.bButtonMiddleSelected = NO;
                [self.buttonMiddle setBackgroundImage:nil forState:UIControlStateNormal];
            }else{
                self.bButtonMiddleSelected = YES;
                [self.buttonMiddle setBackgroundImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            }
        }else{
            if (self.bButtonRightSelected) {
                self.bButtonRightSelected = NO;
                [self.buttonRight setBackgroundImage:nil forState:UIControlStateNormal];
            }else{
                self.bButtonRightSelected = YES;
                [self.buttonRight setBackgroundImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            }
        }
        [self.delegate selectPhotoWithIndex:button.tag];
    }
}

@end
