//
//  ChoosingMokaAlbumViewController.h
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosingMokaAlbumViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewAlbum;
@property(nonatomic, strong) NSDictionary *dictMoka;

@end
