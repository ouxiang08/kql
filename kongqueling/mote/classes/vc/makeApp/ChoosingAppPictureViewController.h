//
//  ChoosingMokaPictureViewController.h
//  mote
//
//  Created by sean on 11/29/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "AlbumModel.h"
#import "MokaNetworkController.h"

@protocol ReChooseMokaAlbumDelegate <NSObject>

-(void)selectAlbumWithArray:(NSMutableArray *)arrPhoto;

@end

@protocol ConfirmAppPictureDelegate <NSObject>

-(void)selectPictureWitUrlArray:(NSMutableArray *)arrPhotoImageUrl;

@end

@interface ChoosingAppPictureViewController : MokaNetworkController

@property(nonatomic, strong) AlbumModel *model;
@property(nonatomic, strong) IBOutlet UITableView *tableViewPhoto;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollViewChoose;
@property(nonatomic, strong) NSMutableArray *arrImageSelectedUrl;
@property(nonatomic, strong) IBOutlet UILabel *labelConfirm;
@property(nonatomic, strong) IBOutlet UIButton *buttonConfirm;
@property(nonatomic, strong) NSDictionary *dicMoka;
@property(nonatomic, assign) id<ReChooseMokaAlbumDelegate>rechooseDelegate;
@property(nonatomic, assign) id<ConfirmAppPictureDelegate>confirmDelegate;
@property(nonatomic, assign) int iMaxPictureNumber;

@end
