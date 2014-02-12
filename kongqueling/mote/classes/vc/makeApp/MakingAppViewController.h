//
//  MakingAppViewController.h
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakingAppViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UILabel *labelAlbum;
@property(nonatomic, strong) IBOutlet UILabel *labelBgMusic;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellBgMusic;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellAppName;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewHomePicture;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewHomePicture;
@property(nonatomic, strong) IBOutlet UITextField *textFieldAppName;
@property(nonatomic, strong) IBOutlet UITableView *tableViewPicture;


@end
