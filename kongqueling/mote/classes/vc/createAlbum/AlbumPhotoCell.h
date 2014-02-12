//
//  AlbumPhotoCell.h
//  mote
//
//  Created by sean on 11/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    KNormalCell = 0,
    KEditCell = 1
}AlbumPhotoCellType;

@protocol AlbumPhotoSelecedDelegate <NSObject>

-(void)selectPhotoWithIndex:(int)index;

@end

@interface AlbumPhotoCell : UITableViewCell

@property(nonatomic, assign) id<AlbumPhotoSelecedDelegate> delegate;
@property(nonatomic,strong) IBOutlet UIImageView *imageViewLeft;
@property(nonatomic,strong) IBOutlet UIImageView *imageViewMiddle;
@property(nonatomic,strong) IBOutlet UIImageView *imageViewRight;

@property(nonatomic, strong) IBOutlet  UIButton *buttonLeft;
@property(nonatomic, strong) IBOutlet  UIButton *buttonMiddle;
@property(nonatomic, strong) IBOutlet  UIButton *buttonRight;

@property(nonatomic, assign) BOOL bButtonLeftSelected;
@property(nonatomic, assign) BOOL bButtonMiddleSelected;
@property(nonatomic, assign) BOOL bButtonRightSelected;

@property(nonatomic, assign) AlbumPhotoCellType type;

@end
