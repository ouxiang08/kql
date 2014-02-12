//
//  ChoosingMokaPictureCell.m
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingMokaPictureCell.h"

@implementation ChoosingMokaPictureCell

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
    
    self.isChecked1 = NO;
    self.isChecked2 = NO;
    self.isChecked3 = NO;
    self.isChecked4 = NO;
    
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

-(IBAction)onPictureClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (button.tag%4 == 0) {
        if (self.isChecked1) {
             [button setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
            self.isChecked1 = NO;
            [self.delegate didUnClickCellAtIndex:button.tag];
        }else{
            [button setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            self.isChecked1 = YES;
            [self.delegate didClickCellAtIndex:button.tag];
        }
    }else if(button.tag%4 == 1){
        if (self.isChecked2) {
            [button setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
            self.isChecked2 = NO;
            [self.delegate didUnClickCellAtIndex:button.tag];
        }else{
            [button setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            self.isChecked2 = YES;
            [self.delegate didClickCellAtIndex:button.tag];
        }
    }else if(button.tag%4 == 2){
        if (self.isChecked3) {
            [button setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
            self.isChecked3 = NO;
            [self.delegate didUnClickCellAtIndex:button.tag];
        }else{
            [button setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            self.isChecked3 = YES;
            [self.delegate didClickCellAtIndex:button.tag];
        }
    }else if(button.tag%4 == 3){
        if (self.isChecked4) {
            [button setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
            self.isChecked4 = NO;
            [self.delegate didUnClickCellAtIndex:button.tag];
        }else{
            [button setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            self.isChecked4 = YES;
            [self.delegate didClickCellAtIndex:button.tag];
        }
    }else{
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
