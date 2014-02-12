//
//  SendInvitationPriceViewController.m
//  mote
//
//  Created by sean on 12/30/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "SendInvitationPriceViewController.h"

@interface SendInvitationPriceViewController ()

@end

@implementation SendInvitationPriceViewController

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
    self.view.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;
    [self initDisplayView];
    self.title = @"价格";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"确定" selector:@selector(onSure) target:self];
    // Do any additional setup after loading the view from its nib.
}

-(void)initDisplayView{
    if (self.iType == KQiPaiView) {
        [self.view addSubview:self.viewPriceQipai];
    }else{
        [self.view addSubview:self.viewPriceUnit];
    }
}

-(void)onSure{
    if (self.iType == KQiPaiView) {
        if ([self.textFieldQipai.text isNotNilOrBlankString]) {
            [self.delegate modifyPriceQipai:self.textFieldQipai.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"价格不能为空！"];
        }
    }else{
        if ([self.textFieldByDay.text isNotNilOrBlankString]&&[self.textFieldByUnit.text isNotNilOrBlankString]) {
            [self.delegate modifyPriceByDay:self.textFieldByDay.text byUnit:self.textFieldByUnit.text];
             [self.navigationController popViewControllerAnimated:YES];
        }else if([self.textFieldByDay.text isNotNilOrBlankString]){
            [self.delegate modifyPriceByDay:self.textFieldByDay.text byUnit:@""];
             [self.navigationController popViewControllerAnimated:YES];
        }else if([self.textFieldByUnit.text isNotNilOrBlankString]){
            [self.delegate modifyPriceByDay:@"" byUnit:self.textFieldByUnit.text];
             [self.navigationController popViewControllerAnimated:YES];
        }else{
              [[ToastViewAlert defaultCenter] postAlertWithMessage:@"价格不能为空！"];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
