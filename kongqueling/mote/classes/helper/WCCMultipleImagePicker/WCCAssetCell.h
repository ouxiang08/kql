//
//  WCCAssetCell.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCCAssetCellDelegate.h"

@interface WCCAssetCell : UITableViewCell

@property (nonatomic,assign) NSObject<WCCAssetCellDelegate> *delegate;

- (id)initWithAssets:(NSArray *)assets reuseIdentifier:(NSString *)identifier;
- (void)setAssets:(NSArray *)assets;

@end
