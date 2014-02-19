//
//  MyMerchantListViewController.m
//  mote
//
//  Created by sean on 12/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "UtilityHelper.h"
#import "MyMerchantListViewController.h"
#import "SendInvitationViewController.h"
#import "MechantWebViewController.h"

@interface MyMerchantListViewController ()<SendInvitationDelegate>{
    NSDictionary *_dictDetail;
}

@end

@implementation MyMerchantListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"机构详情";
    self.scrollViewInfo.contentSize = CGSizeMake(320, 767);
    [self.scrollViewInfo addSubview:self.viewInfo];
    
    [self getMerchantData];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

-(void)getMerchantData{
    NSString *strUrl = [UrlHelper stringUrlGetMerchantDetail:self.strMid];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _dictDetail = [dictResponse valueForKey:@"detail"];
        [self initViewDisplay];
        
    } andFailureBlock:^(NSError *error) {
        
    }];
}

-(void)initViewDisplay{
    self.labelTitle.text = [_dictDetail valueForKey:@"name"];
    [self.imageViewLogo setImageWithURL:[NSURL URLWithString:[_dictDetail valueForKey:@"logo"]] placeholderImage:[UIImage imageNamed:@"merchant_logo_default"]];
    int score = [[_dictDetail valueForKey:@"score"] integerValue];
    
    if (score == 0) {
        self.imageViewRate.image = [UIImage imageNamed:@"finder_start_0"];
    }else if (score == 1) {
        self.imageViewRate.image = [UIImage imageNamed:@"finder_start_1"];
    }else if (score == 2) {
        self.imageViewRate.image = [UIImage imageNamed:@"finder_start_2"];
    }else if (score == 3) {
        self.imageViewRate.image = [UIImage imageNamed:@"finder_start_3"];
    }else if (score == 4) {
        self.imageViewRate.image = [UIImage imageNamed:@"finder_start_4"];
    }else {
        self.imageViewRate.image = [UIImage imageNamed:@"finder_start_5"];
    }
    
    self.labelCity.text = [_dictDetail valueForKey:@"city"];
    self.labelWalkers.text = [_dictDetail valueForKey:@"labels"];
    self.labelAddress.text = [_dictDetail valueForKey:@"address"];
    self.labelTel.text = [_dictDetail valueForKey:@"tel"];
    if ([[_dictDetail valueForKey:@"tel"] length]>0) {
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTel)];
        _labelTel.userInteractionEnabled=YES;
        [_labelTel addGestureRecognizer:tapGesture];
    }
    self.labelPhone.text = [_dictDetail valueForKey:@"mobile"];
    if ([[_dictDetail valueForKey:@"mobile"] length]>0) {
              
        UITapGestureRecognizer *tapGesture2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickPhone)];
        _labelPhone.userInteractionEnabled=YES;
        [_labelPhone addGestureRecognizer:tapGesture2];
    }
    
    self.labelIntro.text = [[_dictDetail valueForKey:@"desc"] isEqual:[NSNull null]]?@"":[_dictDetail valueForKey:@"desc"];
    NSString *strEmailTmp = [[_dictDetail valueForKey:@"email"] isEqual:[NSNull null]]?@"":[_dictDetail valueForKey:@"email"];
    BOOL bEmail = [UtilityHelper isValidateEmail:strEmailTmp];
    if (!bEmail) {
        self.labelEmail.text = @"";
    }else{
        self.labelEmail.text = strEmailTmp;
         UITapGestureRecognizer *tapGesture3=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickEmail)];
         _labelEmail.userInteractionEnabled=YES;
         [_labelEmail addGestureRecognizer:tapGesture3];
    }
    
    BOOL _bInvite = [[_dictDetail valueForKey:@"is_invite"] boolValue];
    BOOL _bFav = [[_dictDetail valueForKey:@"isFav"] boolValue];
    
    if (_bInvite) {
        self.buttonSend.enabled = NO;
        [self.buttonSend setTitle:@"已发邀约" forState:UIControlStateNormal];
        [self.buttonSend setBackgroundImage:[UIImage imageNamed:@"merchant_invite_btn_bg"] forState:UIControlStateNormal];
    }else{
        self.buttonSend.enabled = YES;
         [self.buttonSend setTitle:@"发送邀约" forState:UIControlStateNormal];
        [self.buttonSend setBackgroundImage:[UIImage imageNamed:@"finder_btn_send_enable"] forState:UIControlStateNormal];
    }
    
    if (_bFav) {
        self.buttonSave.enabled = NO;
        [self.buttonSave setTitle:@"已收藏" forState:UIControlStateNormal];
    }else{
        self.buttonSave.enabled = YES;
        [self.buttonSave setTitle:@"收藏" forState:UIControlStateNormal];
    }
}

- (void)onClickPhone{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"拨打 %@?",[_dictDetail valueForKey:@"mobile"] ] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=1;
    [alertView show];
    
}

- (void)onClickTel{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"拨打 %@?",[_dictDetail valueForKey:@"tel"] ] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag=2;
    [alertView show];
    
}

- (void)onClickEmail{
    
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",[_dictDetail valueForKey:@"email"] ]]];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag==1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[_dictDetail valueForKey:@"mobile"] ]]];
        }
        if (alertView.tag==2) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[_dictDetail valueForKey:@"tel"] ]]];
        }
    }
}

#pragma mark - SendInvitation Delegate
-(void)sendSucess{
    self.buttonSend.enabled = NO;
    [self.buttonSend setTitle:@"已发邀约" forState:UIControlStateNormal];
    [self.buttonSend setBackgroundImage:[UIImage imageNamed:@"merchant_invite_btn_bg"] forState:UIControlStateNormal];
}

#pragma mark - IBActions

-(IBAction)onSendClick:(id)sender{
    SendInvitationViewController *sendInvitationVC = [[SendInvitationViewController alloc] init];
    sendInvitationVC.strMid = [_dictDetail valueForKey:@"sid"];
    sendInvitationVC.delegate = self;
    [self.navigationController pushViewController:sendInvitationVC animated:YES];
}

-(IBAction)onSaveClick:(id)sender{
    NSString *strUrl = [UrlHelper stringUrlSetMfav];
    NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
    [dictParameter setObject:[_dictDetail valueForKey:@"sid"] forKey:@"mid"];
    [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        self.buttonSave.enabled = NO;
        [self.buttonSave setTitle:@"已收藏" forState:UIControlStateNormal];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickViewDetail:(id)sender {
    MechantWebViewController *mwvc = [[MechantWebViewController alloc] init];
    mwvc.url = [_dictDetail valueForKey:@"desc_url"];
    [self.navigationController pushViewController:mwvc animated:YES];
    
}
- (IBAction)clickMemberD:(id)sender {
}

- (IBAction)clickMemberM:(id)sender {
}

- (IBAction)clickMemberP:(id)sender {
}
@end
