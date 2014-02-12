//
//  AlbumPhotoViewController.h
//  mote
//
//  Created by sean on 12/2/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#import "PhotoModel.h"

@protocol DeletePictureDelegate <NSObject>

-(void)deletePictureSuccess;

@end

@interface AlbumPhotoViewController : MokaNetworkController

@property(nonatomic, strong) NSDictionary *dictAlbum;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewPhoto;
@property(nonatomic, strong) AlbumModel *albumModel;
@property(nonatomic, strong) PhotoModel *photoModel;
@property(nonatomic, strong) NSArray *arrPhoto;
@property(nonatomic, assign) int iSelectedIndex;
@property(nonatomic, assign) id<DeletePictureDelegate>delegate;

@end
