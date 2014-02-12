//
//  ChoosingTemplateCell.m
//  mote
//
//  Created by sean on 11/29/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingTemplateCell.h"

@implementation ChoosingTemplateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

-(IBAction)onImageViewBgButtonClick:(id)sender{

    [self.templateCellDelegate selectTemplateCellWithId:((UIButton *)sender).tag];
    
}

@end
