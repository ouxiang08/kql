//
//  PrepareUploadPhotoViewController.h
//  mote
//
//  Created by harry on 13-12-27.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoosingPicturesViewController.h"

@interface PrepareUploadPhotoViewController : MokaNetworkController

@property(nonatomic, strong) NSMutableArray *arrAlbum;
@property(nonatomic, assign) int iDefaultAlbumSelectedIndex;

- (IBAction)clickAddPhoto:(id)sender;
@end
