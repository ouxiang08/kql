//
//  MyArtListViewController.h
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyArtListViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIButton *buttonUpload;
@property(nonatomic, strong) IBOutlet UIButton *buttonCreateAlbum;
@property(nonatomic, strong) IBOutlet UIButton *buttonMakeMoka;
@property(nonatomic, strong) IBOutlet UIButton *buttonMakeApp;
@property(nonatomic, strong) IBOutlet UITableView *tableViewArtList;

@end
