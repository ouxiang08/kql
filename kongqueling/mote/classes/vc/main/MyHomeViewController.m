//
//  MyHomeViewController.m
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PersonalCenterViewController.h"
#import "MyHomeViewController.h"
#import "MyCardListViewController.h"
#import "MyAppListViewController.h"
#import "SettingViewController.h"
#import "MessageCatViewController.h"
#import "MyTaskListViewController.h"
#import "MokaTabBarViewController.h"
#import "MyInvitationListViewController.h"
#import "MySaveListViewController.h"

@interface MyHomeViewController ()<UITableViewDelegate,UITableViewDataSource,ModifyLogoDelegate>{
    NSDictionary *_dictBaseInfo;
    NSArray *_arrPriceInfo;
}

@end

@implementation MyHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"个人中心";
		self.tabBarItem.image = [UIImage imageNamed:@"moka_tabbar_home_normal_bg"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgNumChange) name:kMessageDidChangeNofication object:nil];

    }
    return self;
}

#pragma mark - Modify Logo Delegate
-(void)modifyLogoWithUrl:(NSString *)strUrl{
    [_imageLogo setImageWithURL:urlFromImageURLstr(strUrl)];
}

-(void)findMerchant{
    MokaTabBarViewController *tabarVC = (MokaTabBarViewController *)self.parentViewController;
    [tabarVC touchDownAtItemAtIndex:2];
}

#pragma mark - TableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.viewTableHeadView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        /*---------------------------------------jiajingjing-----------------------------------------------*/
        UIImageView* badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(320-80, 12, 20, 20)];
        badgeView.image = [UIImage imageNamed:@"badge.png"];
        UILabel *badgeLabel = [[UILabel alloc]initWithFrame:badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor whiteColor];
        int totalNum = [[[MainModel sharedObject] getNumByIndex:3] intValue];
        [badgeView addSubview:badgeLabel];
        badgeView.hidden = YES;
        badgeView.tag = 2002;
        [self.tableViewCellMessage addSubview:badgeView];
        if (totalNum>0) {
            badgeLabel.text = [[MainModel sharedObject] getNumByIndex:3];
            UIImageView *image = (UIImageView *)[self.tableViewCellMessage viewWithTag:2002];
            image.hidden = NO;
        }
        return self.tableViewCellMessage;
        
    }else if(indexPath.row == 1){
        return self.tableViewCellApp;
    }else if(indexPath.row == 2){
        return self.tableViewCellMoka;
    }else if(indexPath.row == 3){
        return self.tableViewCellCollection;
    }else if(indexPath.row == 4){
        return self.tableViewCellInvitation;
    }else{
        return self.tableViewCellPersonal;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        MyAppListViewController *appListVC = [[MyAppListViewController alloc] init];
        [self.navigationController pushViewController:appListVC animated:YES];
    }else if (indexPath.row ==2) {
        MyCardListViewController *cardListVC = [[MyCardListViewController alloc] init];
        [self.navigationController pushViewController:cardListVC animated:YES];
    }else if (indexPath.row == 5) {
        SettingViewController *personal = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:personal animated:YES];
    }else if (indexPath.row == 0) {
        MessageCatViewController *msgListVC = [[MessageCatViewController alloc] init];
        [self.navigationController pushViewController:msgListVC animated:YES];
    }else if (indexPath.row == 4) {
        MyInvitationListViewController *invitationVC = [[MyInvitationListViewController alloc] init];
        invitationVC.iStatus = 0;
        [self.navigationController pushViewController:invitationVC animated:YES];
    }else if (indexPath.row == 3) {
        MySaveListViewController *saveVC = [[MySaveListViewController alloc] init];
        [self.navigationController pushViewController:saveVC animated:YES];
    }    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor= MOKA_VIEW_BG_COLOR_BLUE;

    
}

- (void)viewWillAppear:(BOOL)animated{
    _lblNickname.text =[[MainModel sharedObject] strNickName];
    NSString *strUrl = [UrlHelper stringUrlGetUserinfo:[MainModel sharedObject].strUid];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        
        NSDictionary *dictMsg = [dictResponse valueForKey:@"msg"];
        _dictBaseInfo = [dictMsg valueForKey:@"baseinfo"];
        _arrPriceInfo = [dictMsg valueForKey:@"priceinfo"];
        
        [[MainModel sharedObject] saveDictUserInfo:_dictBaseInfo];
        [[MainModel sharedObject] savePriceInfo:_arrPriceInfo];
        
        [self initLabelDisplay];
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

-(void)initLabelDisplay{
    if (_dictBaseInfo) {
        _lblNickname.text = [_dictBaseInfo valueForKey:@"nickname"];
        [[MainModel sharedObject] saveNickName: [_dictBaseInfo valueForKey:@"nickname"]];
        
        NSArray *jobdetail = [[_dictBaseInfo valueForKey:@"usertype"] componentsSeparatedByString:@"|"];
        NSString *joblist = @"";
        for (int i=0; i<[jobdetail count]; i++) {
            NSString *jobname = [jobdetail objectAtIndex:i];
            if ([jobname isEqualToString:@"d"]) {
                joblist = [joblist stringByAppendingString:@" 造型师"];
            }
            if ([jobname isEqualToString:@"m"]) {
                joblist = [joblist stringByAppendingString:@" 模特"];
            }
            if ([jobname isEqualToString:@"p"]) {
                joblist = [joblist stringByAppendingString:@" 摄影师"];
            }
        }
        _lblJob.text = joblist;
        
        NSString *gender = [_dictBaseInfo valueForKey:@"gender"];
        if ([gender isEqualToString:@"M"]) {
            _imgviewHeader.image = [UIImage imageNamed:@"myhome_top_male_bg.jpg"];
            _imgviewGender.image = [UIImage imageNamed:@"myhome_gender_male_logo.png"];
        }else{
            _imgviewHeader.image = [UIImage imageNamed:@"myhome_top_female_bg.jpg"];
            _imgviewGender.image = [UIImage imageNamed:@"myhome_gender_women_logo.png"];
        }
        
        // 头像view、
        _imageLogo.layer.cornerRadius = CGRectGetWidth(_imageLogo.frame)/2;
        _imageLogo.layer.masksToBounds = YES;
        _imageLogo.backgroundColor = [UIColor whiteColor];
      
        NSString *avatarurl = [_dictBaseInfo valueForKey:@"avatarPath"];
       
        if (![avatarurl isEqualToString:@""]) {
             [_imageLogo setImageWithURL:urlFromImageURLstr(avatarurl)];
        }else{
            [_imageLogo setImage:[UIImage imageNamed:@"no_image"]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
     [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onclickUserinfo:(id)sender {
    PersonalCenterViewController *personal = [[PersonalCenterViewController alloc] init];
    personal.delegate = self;
    [self.navigationController pushViewController:personal animated:YES];
}

- (void)msgNumChange{

    NSLog(@"msgNmuChange");
    UIImageView *image = (UIImageView *)[self.tableViewCellMessage viewWithTag:2002];
    UILabel *badgeLabel = (UILabel *)[image subviews][0];
    int totalNum = [[[MainModel sharedObject] getNumByIndex:3] intValue];
    if (totalNum>0) {
        badgeLabel.text = [[MainModel sharedObject] getNumByIndex:3];
        image.hidden = NO;
    }else{
        image.hidden = YES;
    }
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
