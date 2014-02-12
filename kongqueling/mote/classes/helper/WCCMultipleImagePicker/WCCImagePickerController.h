//
//  WCCImagePickerController.h
//  ImagePicker
//
//  Created by sean on 13-10-12.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCCAssetSelectionDelegate.h"

@class WCCImagePickerController;

@protocol WCCImagePickerControllerDelegate <UINavigationControllerDelegate>

- (void)elcImagePickerController:(WCCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)elcImagePickerControllerDidCancel:(WCCImagePickerController *)picker;

@end

@interface WCCImagePickerController : UINavigationController <WCCAssetSelectionDelegate>

@property (nonatomic, assign) id<WCCImagePickerControllerDelegate> delegate;

- (void)cancelImagePicker;

@end


