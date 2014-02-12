//
//  SetPasswordViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "ProfessionViewController.h"
@interface SetPasswordViewController ()

@end

@implementation SetPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr{

    messArray=MessageArr;
    return self;

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    self.title = @"设置密码(3/6)";
   self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1" selector:nil target:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"设置密码" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
    UIImageView *subimg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 300, 80)];
    subimg.image=[UIImage imageNamed:@"6-1_07.png"];
    [self.view addSubview:subimg];
    
    UILabel *userLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 26, 80, 39)];
    userLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    userLabel.backgroundColor=[UIColor clearColor];
    userLabel.text=@"设置密码：";
    userLabel.textColor=[UIColor blackColor];
    //userLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:userLabel];
    UILabel *passLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 66, 80, 39)];
    passLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    passLabel.backgroundColor=[UIColor clearColor];
    passLabel.text=@"重复密码：";
    passLabel.textColor=[UIColor blackColor];
    [self.view addSubview:passLabel];
    
    passText=[[UITextField alloc] initWithFrame:CGRectMake(100, 35, 210, 20)];
    passText.placeholder=@"不少于6位";
    passText.backgroundColor=[UIColor clearColor];
    passText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [passText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [passText setSecureTextEntry:YES];
    [passText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:passText];
    
    againpassText=[[UITextField alloc] initWithFrame:CGRectMake(100, 75, 210, 20)];
    againpassText.placeholder=@"再次输入密码";
    againpassText.backgroundColor=[UIColor clearColor];
    againpassText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [againpassText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [againpassText setSecureTextEntry:YES];
    [againpassText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:againpassText];
    
    UILabel *infoLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 120, 280, 39)];
    infoLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    infoLabel.backgroundColor=[UIColor clearColor];
    infoLabel.text=@"请勿输入过于简单的密码";
    infoLabel.textColor=[UIColor lightGrayColor];
    [self.view addSubview:infoLabel];

}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextToFinishYourInformation{
    //fullMsgStr=[NSString stringWithFormat:@"%@,%@",messageStr,passText.text];
    
    if (![passText.text isEqualToString:@""]&&![againpassText.text isEqualToString:@""]) {
        if ([passText.text isEqualToString:againpassText.text]&&(passText.text.length>=6)) {
//            nextbtn.enabled=YES;
//            [nextbtn setBackgroundImage:[UIImage imageNamed:@"next_step_0.png"] forState:UIControlStateNormal];
            
            if ([messArray count]<3) {
                [messArray addObject:passText.text];
            }
            else{
                [messArray removeObjectAtIndex:[messArray count]-1];
                [messArray addObject:passText.text];
            }
            
            NSLog(@"-----%@",messArray);
            ProfessionViewController *professionVC=[[ProfessionViewController alloc] initWithTheMessArray:messArray];
            [self.navigationController pushViewController:professionVC animated:YES];
        }
        else if(passText.text.length<6){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:@"密码不能少于6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:@"两次输入不一致" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    

    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [passText resignFirstResponder];
    [againpassText resignFirstResponder];
    
}

- (void)textFieldDidChange{
    if ([passText.text length]>0 && [againpassText.text length]>0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_0.png" selector:@selector(nextToFinishYourInformation) target:self];
        
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
