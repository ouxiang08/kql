//
//  StartPageViewController.m
//  mote
//
//  Created by harry on 14-1-1.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "StartPageViewController.h"
#import "RSViewController.h"
#import "RegisterViewController.h"
#import "HeadViewController.h"
#import "MokaTabBarViewController.h"

@interface StartPageViewController ()

@end

@implementation StartPageViewController

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

    CGRect rect1 = _btLogin.frame;
    CGRect rect2 = _btReg.frame;
    CGRect rect3 = _lblLogin.frame;
    CGRect rect4 = _lblReg.frame;
    
    rect1.origin.y = MOKA_SCREEN_HEIGHT - 50;
    rect2.origin.y = MOKA_SCREEN_HEIGHT - 50;
    rect3.origin.y = MOKA_SCREEN_HEIGHT - 41;
    rect4.origin.y = MOKA_SCREEN_HEIGHT - 41;
    
    _btLogin.frame = rect1;
    _btReg.frame = rect2;
    _lblLogin.frame = rect3;
    _lblReg.frame = rect4;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
//    if ([[MainModel sharedObject] strUid]) {
//        MokaTabBarViewController *mokaTabBarVC = [[MokaTabBarViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mokaTabBarVC];
//        [self.navigationController presentViewController:nav animated:NO completion:^(void){}];
//    }
}



-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickLogin:(id)sender {    
    RSViewController *rVC = [[RSViewController alloc] init];
    //HeadViewController *rVC = [[HeadViewController alloc] init];
    [self.navigationController pushViewController:rVC animated:YES];    
}

- (IBAction)clickReg:(id)sender {
    RegisterViewController *rVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:rVC animated:YES];
}
@end
