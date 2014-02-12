//
//  WCCAlbumPickerControllerViewController.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WCCAssetSelectionDelegate.h"
#import "WCCAssetPickerFilterDelegate.h"

@interface WCCAlbumPickerController : UITableViewController <WCCAssetSelectionDelegate>

@property (nonatomic, assign) NSInteger iMaxSelected;
@property (nonatomic, assign) NSInteger iMinSelected;
@property (nonatomic, assign) id<WCCAssetSelectionDelegate> parent;
@property (nonatomic, retain) NSMutableArray *assetGroups;

// optional, can be used to filter the assets displayed
@property (nonatomic, assign) id<WCCAssetPickerFilterDelegate> assetPickerFilterDelegate;

@end