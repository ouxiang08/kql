//
//  ChoosingMokaAlbumViewController.h
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosingAppPictureViewController.h"

@interface ChoosingAppAlbumViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewAlbum;
@property(nonatomic, strong) ChoosingAppPictureViewController *chooseVC;
@property(nonatomic, assign) int iMaxPictureNumber;
@property(nonatomic, strong) NSMutableArray *arrImageSelectedUrl;
@end
