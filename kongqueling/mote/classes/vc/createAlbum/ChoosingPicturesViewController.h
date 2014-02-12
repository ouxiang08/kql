//
//  ChoosingPicturesViewController.h
//  mote
//
//  Created by sean on 11/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

@protocol UploadSuccessDelegate <NSObject>

-(void)uploadSuccessWithModel:(AlbumModel *)model;

@end

@interface ChoosingPicturesViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UILabel *labelAlbum;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewCheck;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellHighQualityPicture;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellBottom;
@property(nonatomic, strong) IBOutlet UITableView *tableViewPicture;
@property(nonatomic, strong) NSMutableArray *arrAlbum;
@property(nonatomic, assign) int iDefaultAlbumSelectedIndex;

@property(nonatomic, strong) id<UploadSuccessDelegate>uploadDelegate;

@end
