//
//  WCCAsset.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@class WCCAsset;

@protocol WCCAssetDelegate <NSObject>

@optional
- (void)assetSelected:(WCCAsset *)asset;

@end

@interface WCCAsset : NSObject

@property (nonatomic, retain) ALAsset *asset;
@property (nonatomic, assign) id<WCCAssetDelegate> parent;
@property (nonatomic, assign) BOOL selected;

- (id)initWithAsset:(ALAsset *)asset;

@end