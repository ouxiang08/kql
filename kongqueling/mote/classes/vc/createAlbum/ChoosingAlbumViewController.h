//
//  ChoosingAlbumViewController.h
//  mote
//
//  Created by sean on 11/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

@protocol ChoosingAlbumDelegate <NSObject>

-(void)choosingAlbumAtIndex:(int)iSelectedIndex;

@end

#import <UIKit/UIKit.h>

@interface ChoosingAlbumViewController : UITableViewController

@property(nonatomic,strong) NSArray *arrAlbum;
@property(nonatomic,assign) id<ChoosingAlbumDelegate>choosingAlbumDelegate;

@end
