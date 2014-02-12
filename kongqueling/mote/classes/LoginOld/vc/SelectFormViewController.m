//
//  SelectFormViewController.m
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "SelectFormViewController.h"

@interface SelectFormViewController ()

@end

@implementation SelectFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithVC:(FormViewController *)formviewcontroller{
    formVC=formviewcontroller;
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
	UIImageView *barImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    barImageview.image=[UIImage imageNamed:@"nav_bar.png"];
    [self.view addSubview:barImageview];
    
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(80, 4, 160, 40)];
    titleLabel.font=[UIFont fontWithName:KdefaultFont size:20];
    titleLabel.backgroundColor=[UIColor clearColor];
    titleLabel.text=@"模特选择";
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backbtn.frame=CGRectMake(10,7, 50, 30);
    [backbtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backbtn addTarget:self action:@selector(backToTheUpLevel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backbtn];
    
    objrctArr=[[NSArray alloc] initWithObjects:@"时装模特",@"平面模特",@"内衣模特",@"部件模特",@"T台模特", nil];
    for (int i=0; i<5; i++) {
        UIButton *selectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectbtn.tag=50+i;
        selectbtn.frame=CGRectMake(0,44+50*i, 320, 50);
        [selectbtn setBackgroundImage:[UIImage imageNamed:@"09344323.png"] forState:UIControlStateNormal];
        [selectbtn addTarget:self action:@selector(selectTheProm:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectbtn];
        UILabel *subLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 46+50*i, 100, 50)];
        subLabel.font=[UIFont fontWithName:KdefaultFont size:15];
        subLabel.backgroundColor=[UIColor clearColor];
        subLabel.text=[objrctArr objectAtIndex:i];
        [self.view addSubview:subLabel];
        
        UIImageView *selectimage=[[UIImageView alloc] initWithFrame:CGRectMake(270, 56+50*i, 25, 20)];
        selectimage.image=[UIImage imageNamed:@"093449_03.png"];
        selectimage.tag=20+i;
        selectimage.hidden=YES;
        [self.view addSubview:selectimage];
    }
     
    finishbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    finishbtn.frame=CGRectMake(265,7, 50, 30);
    [finishbtn setBackgroundImage:[UIImage imageNamed:@"complete-0.png"] forState:UIControlStateNormal];
    [finishbtn addTarget:self action:@selector(finishToSlectForm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishbtn];
    finishbtn.enabled=NO;


}

-(void)backToTheUpLevel{
     [self dismissViewControllerAnimated:YES completion:^(void){}];
}


-(void)selectTheProm:(id)sender{
    finishbtn.enabled=YES;
    [finishbtn setBackgroundImage:[UIImage imageNamed:@"complete-0.png"] forState:UIControlStateNormal];
    UIImageView *oneimage=(UIImageView *)[self.view viewWithTag:20];
    UIImageView *twoimage=(UIImageView *)[self.view viewWithTag:21];
    UIImageView *threeimage=(UIImageView *)[self.view viewWithTag:22];
    UIImageView *fourimage=(UIImageView *)[self.view viewWithTag:23];
    UIImageView *fiveimage=(UIImageView *)[self.view viewWithTag:24];
    oneimage.hidden=YES;
    twoimage.hidden=YES;
    threeimage.hidden=YES;
    fourimage.hidden=YES;
    fiveimage.hidden=YES;
    UIButton *senbtn=(UIButton *)sender;
    switch (senbtn.tag) {
        case 50:{
            oneimage.hidden=NO;
            formVC.modeString=[objrctArr objectAtIndex:0];
        
            }
            break;
        case 51:{
        
            twoimage.hidden=NO;
            formVC.modeString=[objrctArr objectAtIndex:1];
          
        }
            break;
        case 52:{
            
            threeimage.hidden=NO;
            formVC.modeString=[objrctArr objectAtIndex:2];
    
        }
            break;
        case 53:{
            fourimage.hidden=NO;
            formVC.modeString=[objrctArr objectAtIndex:3];
        }
            break;

        case 54:{
            fiveimage.hidden=NO;
            formVC.modeString=[objrctArr objectAtIndex:4];
        }
            break;

        default:
            break;
    }
    
}


-(void)finishToSlectForm{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
