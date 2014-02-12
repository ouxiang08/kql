//
//  UpdatePasswordViewController.m
//  mote
//
//  Created by harry on 13-12-29.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    self.title = @"修改密码";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete-1" selector:nil target:nil];
    
    UIImage *bgimg = [UIImage imageNamed:@"chgpass_cellbg.png"];
    UIImageView *subimg=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, bgimg.size.width, bgimg.size.height)];
    subimg.image= bgimg;
    [self.view addSubview:subimg];
    
    UILabel *userLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 39, 90, 15)];
    userLabel.font=[UIFont systemFontOfSize:16];
    userLabel.backgroundColor=[UIColor clearColor];
    userLabel.text=@"原密码：";
    userLabel.textAlignment = NSTextAlignmentRight;
    userLabel.textColor=[UIColor blackColor];
    //userLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:userLabel];
    
    UILabel *passLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 84, 90, 15)];
    passLabel.font=[UIFont systemFontOfSize:16];
    passLabel.backgroundColor=[UIColor clearColor];
    passLabel.text=@"新密码：";
    passLabel.textAlignment = NSTextAlignmentRight;
    passLabel.textColor=[UIColor blackColor];
    [self.view addSubview:passLabel];
    
    UILabel *repassLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, 125, 90, 15)];
    repassLabel.font=[UIFont systemFontOfSize:16];
    repassLabel.backgroundColor=[UIColor clearColor];
    repassLabel.text=@"重复密码：";
    repassLabel.textAlignment = NSTextAlignmentRight;
    repassLabel.textColor=[UIColor blackColor];
    [self.view addSubview:repassLabel];
    
    
    oldPassText=[[UITextField alloc] initWithFrame:CGRectMake(105, 39, 200, 20)];
    oldPassText.backgroundColor=[UIColor clearColor];
    oldPassText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [oldPassText setSecureTextEntry:YES];
    oldPassText.font=[UIFont systemFontOfSize:16];
    [oldPassText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:oldPassText];

    
    newPassText=[[UITextField alloc] initWithFrame:CGRectMake(105, 82, 200, 20)];
    newPassText.placeholder=@"不少于6位";
    newPassText.backgroundColor=[UIColor clearColor];
    newPassText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [newPassText setSecureTextEntry:YES];
    newPassText.font=[UIFont systemFontOfSize:16];
    [newPassText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:newPassText];
    
    renewPassText=[[UITextField alloc] initWithFrame:CGRectMake(105, 123, 200, 20)];
    renewPassText.placeholder=@"再次输入密码";
    renewPassText.backgroundColor=[UIColor clearColor];
    renewPassText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [renewPassText setSecureTextEntry:YES];
    renewPassText.font=[UIFont systemFontOfSize:16];
    [renewPassText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:renewPassText];
    
    
}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextToFinishYourInformation{
    //fullMsgStr=[NSString stringWithFormat:@"%@,%@",messageStr,passText.text];
    
   if ([newPassText.text length]>0 && [renewPassText.text length]>0 && [oldPassText.text length]>0) {
        if ([newPassText.text isEqualToString:renewPassText.text]&&(renewPassText.text.length>=6)) {
            NSString *strUrl = [UrlHelper stringUrlUpdatePass];
                     
            NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
            [dicParameter setObject:[UrlHelper getMD5String:oldPassText.text]  forKey:@"oldpass"];
            [dicParameter setObject:[UrlHelper getMD5String:newPassText.text]  forKey:@"newpass"];
            [dicParameter setObject:[UrlHelper getMD5String:renewPassText.text]  forKey:@"renewpass"];
            
            
            [self actionRequestWithUrl:strUrl parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
            
                int errorNo = [[dictResponse valueForKey:@"code"] integerValue];
                
                if (errorNo == 1) {
                    [[ToastViewAlert defaultCenter] postAlertWithMessage:@"密码已更新"];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    self.maskView.hidden = YES;
                    NSString *info = [dictResponse valueForKey:@"msg"];
                    [[ToastViewAlert defaultCenter] postAlertWithMessage:info];
                }
                
            } andFailureBlock:^(NSError *error) {
                
                [[ToastViewAlert defaultCenter] postAlertWithMessage:@"修改失败"];
            }];
            
        }
        else if(newPassText.text.length<6){
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"密码不能少于6位"];
        }
        else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"两次输入不一致"];
        }
    }else{
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请输入密码"];
    }
    
    
    
}

- (void)textFieldDidChange{
    if ([newPassText.text length]>0 && [renewPassText.text length]>0 && [oldPassText.text length]>0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete-0.png" selector:@selector(nextToFinishYourInformation) target:self];
        
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete-1.png" selector:nil target:nil];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [renewPassText resignFirstResponder];
    [newPassText resignFirstResponder];
    [oldPassText resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
