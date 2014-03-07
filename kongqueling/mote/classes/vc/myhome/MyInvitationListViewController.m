//
//  MyInvitationListViewController.m
//  mote
//
//  Created by sean on 1/2/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "MyInvitationTableViewCell.h"
#import "MyInvitationListViewController.h"
#import "MyMerchantListViewController.h"

@interface MyInvitationListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_arrInvitationList;
}

@end

@implementation MyInvitationListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _arrInvitationList = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.iStatus == 0) {
        self.title = @"我的邀约";
    }else{
        self.title = @"认证机构";
    }
    
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

-(void)getData{
    NSString *strUrl = [UrlHelper stringUrlGetUserMerchant:self.iStatus];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _arrInvitationList = (NSMutableArray *)dictResponse;
        [self.tableViewInvitation reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrInvitationList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"MyInvitationTableViewCell";
    
    MyInvitationTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (contentCell == nil) {
        contentCell = [[MyInvitationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    NSDictionary *dict = [_arrInvitationList objectAtIndex:indexPath.row];
    contentCell.labelTitle.text = [dict valueForKey:@"name"];
    contentCell.labelArea.text = [dict valueForKey:@"district"];
    contentCell.labelTag.text = [dict valueForKey:@"industry"];
    [contentCell.imageViewLogo setImageWithURL:urlFromImageURLstr([dict valueForKey:@"img"]) placeholderImage:[UIImage imageNamed:@"no_image"]];
    
    /*--------------------------------jiajingjing------------------------------------------*/
    int isInvited = [[dict valueForKey:@"invite_status"] intValue];
    UIImage *inviteImage = [UIImage imageNamed:@"inviteStatu"];
    UIImageView *inviteImageView = [[UIImageView alloc] initWithImage:inviteImage];
    inviteImageView.frame = CGRectMake(238, 26, 45, 21);
    inviteImageView.tag = 1024;
    UILabel *inviteLabel = [[UILabel alloc]initWithFrame:inviteImageView.bounds];
    inviteLabel.textAlignment = NSTextAlignmentCenter;
    inviteLabel.backgroundColor = [UIColor clearColor];
    inviteLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    inviteLabel.textColor = [UIColor blackColor];
    [inviteImageView addSubview:inviteLabel];
    
    UIImageView *oldImageView = (UIImageView *)[contentCell viewWithTag:1024];
    
    if (isInvited==1) {
        inviteLabel.text = @"已通过";
    }else if (isInvited==-1){
        inviteLabel.text = @"已拒绝";
    }else if (isInvited==0){
        inviteLabel.text = @"待回复";
    }
    
    if (oldImageView) {
        [oldImageView removeFromSuperview];
    }
    
    [contentCell addSubview:inviteImageView];
    
    int score = [[dict valueForKey:@"score"] integerValue];
    if (score == 0) {
        contentCell.imageViewRate.image = [UIImage imageNamed:@"finder_start_0"];
    }else if (score == 1) {
        contentCell.imageViewRate.image = [UIImage imageNamed:@"finder_start_1"];
    }else if (score == 2) {
        contentCell.imageViewRate.image = [UIImage imageNamed:@"finder_start_2"];
    }else if (score == 3) {
        contentCell.imageViewRate.image = [UIImage imageNamed:@"finder_start_3"];
    }else if (score == 4) {
        contentCell.imageViewRate.image = [UIImage imageNamed:@"finder_start_4"];
    }else {
        contentCell.imageViewRate.image = [UIImage imageNamed:@"finder_start_5"];
    }
       
    return contentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictFinder = [_arrInvitationList objectAtIndex:indexPath.row];
    MyMerchantListViewController *myMerchantVC = [[MyMerchantListViewController alloc] init];
    myMerchantVC.strMid =  [dictFinder valueForKey:@"mId"];
    [self.navigationController pushViewController:myMerchantVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
