//
//  ChoosingBgMusicViewController.h
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@protocol ChoosingBgMusicDelegate <NSObject>

-(void)selectBgMusicWithDict:(NSDictionary *)dictMusic;

@end

@interface ChoosingBgMusicViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewMusicList;
@property(nonatomic, assign) id<ChoosingBgMusicDelegate> musicDelegate;

@end
