//
//  ChoosingMokaPictureCell.h
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosingAppPictureCellDelegate <NSObject>

-(void)didClickCellAtIndex:(int)index;
-(void)didUnClickCellAtIndex:(int)index;

@end

@interface ChoosingAppPictureCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *imageView1;
@property(nonatomic, strong) IBOutlet UIImageView *imageView2;
@property(nonatomic, strong) IBOutlet UIImageView *imageView3;
@property(nonatomic, strong) IBOutlet UIImageView *imageView4;

@property(nonatomic, strong) IBOutlet UIButton *buttonSelected1;
@property(nonatomic, strong) IBOutlet UIButton *buttonSelected2;
@property(nonatomic, strong) IBOutlet UIButton *buttonSelected3;
@property(nonatomic, strong) IBOutlet UIButton *buttonSelected4;

@property(nonatomic, assign) BOOL isChecked1;
@property(nonatomic, assign) BOOL isChecked2;
@property(nonatomic, assign) BOOL isChecked3;
@property(nonatomic, assign) BOOL isChecked4;

@property(nonatomic, assign) id<ChoosingAppPictureCellDelegate>delegate;

@end
