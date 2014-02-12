//
//  AlbumModel.h
//  mote
//
//  Created by sean on 11/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumModel : NSObject

@property(nonatomic, assign) int aid;
@property(nonatomic, assign) int iPubFlag;
@property(nonatomic, assign) int count;
@property(nonatomic, strong) NSString *strAlbumName;
@property(nonatomic, strong) NSString *strHomeImgPath;

@end
