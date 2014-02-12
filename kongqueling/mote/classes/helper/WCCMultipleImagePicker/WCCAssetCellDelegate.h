//
//  WCCAssetCellDelegate.h
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WCCAssetCellDelegate <NSObject>
@required
- (NSInteger)numberOfSelected;
- (NSInteger)maxNumberOfSelected;
- (void)cellItemTapedWithSelected:(BOOL)bSelected;
@end
