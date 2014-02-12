//
//  EditProfileViewController.m
//  mote
//
//  Created by sean on 11/10/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "EditProfileViewController.h"
#import "MokaResultViewController.h"
#import "SanWeiInputViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface EditProfileViewController ()<InputFinishDelegate>

@end

@implementation EditProfileViewController

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
    self.title = @"编辑资料";
     self.view.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;
    
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"完成" selector:@selector(onDone) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    self.labelNameBg.layer.cornerRadius = 4;
    self.labelNameBg.layer.masksToBounds = YES;
    
    [self.labelNameBg.layer setBorderColor:[[UIColor colorWithRed:207 green:207 blue:207 alpha:1.0] CGColor]];
    [self.labelNameBg.layer setBorderWidth:2];
    self.textFieldName.text = [[MainModel sharedObject].dictUserInfo valueForKey:@"nickname"];
    self.textFieldHeight.text = [NSString stringWithFormat:@"%d",[[[MainModel sharedObject].dictUserInfo valueForKey:@"height"] integerValue]];
    self.textFieldWeight.text = [NSString stringWithFormat:@"%d",[[[MainModel sharedObject].dictUserInfo valueForKey:@"weight"] integerValue]];
    self.labelSanwei.text = [[MainModel sharedObject].dictUserInfo valueForKey:@"bodysize"];
    // Do any additional setup after loading the view from its nib.
}

-(void)inputWith:(NSString *)str{
    self.labelSanwei.text = str;
}

-(IBAction)onSanWeiClick:(id)sender{
    SanWeiInputViewController *sanWeiVC = [[SanWeiInputViewController alloc] init];
    sanWeiVC.delegate = self;
    [self.navigationController pushViewController:sanWeiVC animated:YES];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}


-(void)onDone{
    if ([self.textFieldName.text isNilOrBlankString]) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请输入姓名！"];
    }else if ([self.textFieldHeight.text isNilOrBlankString]) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请输入身高！"];
    }else if ([self.textFieldWeight.text isNilOrBlankString]) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请输入体重！"];
    }else if ([self.labelSanwei.text isNilOrBlankString]) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请输入三围！"];
    }else{
        MokaResultViewController *mokaViewController = [[MokaResultViewController alloc] init];
        mokaViewController.imageViewMokaResult.image = self.imageMoka;
        mokaViewController.imageMoka = self.imageMoka;
        mokaViewController.strNameAndHeight = [NSString stringWithFormat:@"姓名:%@ 身高:%@cm 体重:%@kg 三围:%@",self.textFieldName.text,self.textFieldHeight.text,self.textFieldWeight.text,self.labelSanwei.text];
        [self.navigationController pushViewController:mokaViewController animated:YES];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
