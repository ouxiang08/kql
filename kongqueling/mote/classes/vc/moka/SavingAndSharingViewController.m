//
//  SavingAndSharingViewController.m
//  mote
//
//  Created by sean on 11/10/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "SavingAndSharingViewController.h"
#import "MyCardListViewController.h"

@interface SavingAndSharingViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *imageViewChoice;

@end

@implementation SavingAndSharingViewController

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
    self.title = @"保存/分享";
    
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"我的模卡" selector:@selector(onMyMokaList) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    // Do any additional setup after loading the view from its nib.
}

-(void)onMyMokaList{
    MyCardListViewController *cardListVC = [[MyCardListViewController alloc] init];
    [self.navigationController pushViewController:cardListVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
