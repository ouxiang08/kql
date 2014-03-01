//
//  AlbumPhotoViewController1.h
//  mote
//
//  Created by 贾程阳 on 28/2/14.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#import "PhotoModel.h"

@protocol DeletePictureDelegate <NSObject>

-(void)deletePictureSuccess;

@end

@interface AlbumPhotoViewController1 : MokaNetworkController<UIActionSheetDelegate,UIScrollViewDelegate>

@property(nonatomic, strong) NSDictionary *dictAlbum;
@property(nonatomic, strong) AlbumModel *albumModel;
@property(nonatomic, strong) PhotoModel *photoModel;
@property(nonatomic, strong) NSArray *arrPhoto;
@property(nonatomic, assign) int iSelectedIndex;
@property(nonatomic, assign) id<DeletePictureDelegate>delegate;

@property (nonatomic, retain) UIScrollView *bigImgScl;
@property (nonatomic, assign) int currentPic;

@end
