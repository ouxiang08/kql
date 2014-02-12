//
//  MyMokaListViewController.m
//  mote
//
//  Created by sean on 11/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MyMokaListViewController.h"
#import "AlbumPhotoListViewController.h"
#import "MakingMokaViewController.h"
#import "ChoosingPicturesViewController.h"

@interface MyMokaListViewController ()

@end

@implementation MyMokaListViewController

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
    self.title = @"我的模卡";
    
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"新建模卡" selector:@selector(onMakingNewMoka) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}



-(void)onMakingNewMoka{
    MakingMokaViewController *mokaViewController = [[MakingMokaViewController alloc] init];
    [self.navigationController pushViewController:mokaViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
