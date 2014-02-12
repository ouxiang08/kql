//
//  DateEditViewController.m
//  mote
//
//  Created by sean on 12/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "DateEditViewController.h"

@interface DateEditViewController ()<SetDateDelegate>

@end

@implementation DateEditViewController

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
    self.title = @"选择日期";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"choosing_moka_picture_cancel_bg" selector:@selector(onCancel) target:self];
    [self initDateView];
    
    // Do any additional setup after loading the view from its nib.
}



-(void)initDateView{
    self.dateVC = [[DateViewController alloc] init];
    self.dateVC.bIsBtnClicked = YES;
    self.dateVC.delegate = self;
    [self.view addSubview:self.dateVC.view];
}

-(void)setDateSuccess{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onCancel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onSaveDate:(id)sender{
    [self.dateVC saveDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
