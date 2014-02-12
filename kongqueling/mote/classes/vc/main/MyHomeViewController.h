//
//  MyHomeViewController.h
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHomeViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIView *viewTableHeadView;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellMessage;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellApp;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellMoka;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellCollection;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellInvitation;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellDangqi;
@property(nonatomic, strong) IBOutlet UITableViewCell *tableViewCellPersonal;

@property(nonatomic, strong) IBOutlet UITableView *tableViewHome;

@property (weak, nonatomic) IBOutlet UIImageView *imgviewHeader;
@property(nonatomic, strong) IBOutlet UIImageView *imageLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblNickname;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewGender;
@property (weak, nonatomic) IBOutlet UILabel *lblJob;
- (IBAction)onclickUserinfo:(id)sender;
@end
