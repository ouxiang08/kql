//
//  AlbumPhotoListViewController.h
//  mote
//
//  Created by sean on 11/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

@protocol DeleteAlbumDelegate <NSObject>

-(void)deleteAlbum;

@end

@interface AlbumPhotoListViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewPhoto;
@property(nonatomic, strong) IBOutlet UIView *viewEdit;
@property(nonatomic, strong) NSDictionary *dictAlbum;
@property(nonatomic, strong) AlbumModel *model;
@property(nonatomic, strong) NSMutableArray *arrAlbum;
@property(nonatomic, assign) int iDefaultAlbumSelectedIndex;
@property(nonatomic, assign) id<DeleteAlbumDelegate>deleteAlbum;

@end
