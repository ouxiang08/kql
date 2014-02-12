//
//  LoginViewController.m
//  mote
//
//  Created by sean on 11/17/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "LoginViewController.h"
#import "MokaTabBarViewController.h"
#import "CreateUploadViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - On Button Click
-(IBAction)onLoginClick:(id)sender{
//    MokaTabBarViewController *mokaTabBarVC = [[MokaTabBarViewController alloc] init];
//    [self.navigationController pushViewController:mokaTabBarVC animated:YES];
    NSString *strUrl = [UrlHelper stringUrlDoLogin:nil password:nil bduid:[[MainModel sharedObject] strBDUid] bdcid:[[MainModel sharedObject] strBDChannelId]];
   
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [self.indicatorView stopAnimating];
        int errorNo = [[dictResponse valueForKey:@"code"] integerValue];
        if (errorNo == 1) {
            NSDictionary *dictUserInfo = [dictResponse valueForKey:@"userinfo"];
           
            [[MainModel sharedObject] saveUid:[NSString stringWithFormat:@"%d",[[dictUserInfo valueForKey:@"id"] integerValue]]];
//            CreateUploadViewController *viewController = [[CreateUploadViewController alloc] init];
//            [self.navigationController pushViewController:viewController animated:YES];
                MokaTabBarViewController *mokaTabBarVC = [[MokaTabBarViewController alloc] init];
                [self.navigationController pushViewController:mokaTabBarVC animated:YES];
        }else{
            
        }
    } andFailureBlock:^(NSError *error) {
        
    }];
}

-(IBAction)onForgetPasswordClick:(id)sender{
    
}

-(IBAction)onRegistClick:(id)sender{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
