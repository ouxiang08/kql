//
//  WCCAssetPickerFilterDelegate.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

@class WCCAsset;
@class WCCAssetTablePicker;

@protocol WCCAssetPickerFilterDelegate<NSObject>

// respond YES/NO to filter out (not show the asset)
-(BOOL)assetTablePicker:(WCCAssetTablePicker *)picker isAssetFilteredOut:(WCCAsset *)elcAsset;

@end
