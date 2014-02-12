//
//  ChoosingTemplateCell.h
//  mote
//
//  Created by sean on 11/29/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosingTemplateCellDelegate <NSObject>

-(void)selectTemplateCellWithId:(int)buttonTag;

@end

@interface ChoosingTemplateCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageViewTemplateLeftSelected;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewTemplateLeft;
@property(nonatomic, strong) IBOutlet UIButton *buttonLeftImageView;
@property(nonatomic, assign) id<ChoosingTemplateCellDelegate>templateCellDelegate;

-(IBAction)onImageViewBgButtonClick:(id)sender;

@end
