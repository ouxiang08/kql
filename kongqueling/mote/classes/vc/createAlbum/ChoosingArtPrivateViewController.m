//
//  ChoosingArtPrivateViewController.m
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingArtPrivateViewController.h"

@interface ChoosingArtPrivateViewController (){
    int _iDefaultSelectedIndex;
}

@end

@implementation ChoosingArtPrivateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _iDefaultSelectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择权限";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Button Click

-(IBAction)onOpenClick:(id)sender{
    [self.choosePrivateDelegate chooseArtLevelWithText:@"所有人可见" pubFlag:1];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onPrivateClick:(id)sender{
    [self.choosePrivateDelegate chooseArtLevelWithText:@"仅自己可见" pubFlag:0];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
