//
//  WCCAssetSelectionDelegate.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCCAssetSelectionDelegate <NSObject>

- (void)selectedAssets:(NSArray *)assets;

@end
