//
//  WCCAssetTablePicker.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WCCAsset.h"
#import "WCCAssetSelectionDelegate.h"
#import "WCCAssetPickerFilterDelegate.h"
#import "WCCAssetCellDelegate.h"

@interface WCCAssetTablePicker : UITableViewController <WCCAssetDelegate,WCCAssetCellDelegate>

@property (nonatomic, assign) NSInteger iMaxSelected;
@property (nonatomic, assign) NSInteger iMinSelected;
@property (nonatomic, assign) id <WCCAssetSelectionDelegate> parent;
@property (nonatomic, retain) ALAssetsGroup *assetGroup;
@property (nonatomic, retain) NSMutableArray *elcAssets;
@property (nonatomic, retain) IBOutlet UILabel *selectedAssetsLabel;
@property (nonatomic, assign) BOOL singleSelection;
@property (nonatomic, assign) BOOL immediateReturn;

// optional, can be used to filter the assets displayed
@property(nonatomic, assign) id<WCCAssetPickerFilterDelegate> assetPickerFilterDelegate;

- (int)totalSelectedAssets;
- (void)preparePhotos;

- (void)doneAction:(id)sender;

- (void)assetSelected:(WCCAsset *)asset;

@end
