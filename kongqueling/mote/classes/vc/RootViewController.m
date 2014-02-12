//
//  RootViewController.m
//  mote
//
//  Created by sean on 11/5/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "RootViewController.h"
#import "MakingMokaViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RootViewController ()


@end

@implementation RootViewController

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
    MakingMokaViewController *mokaViewController = [[MakingMokaViewController alloc] init];
    [self.navigationController pushViewController:mokaViewController animated:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
