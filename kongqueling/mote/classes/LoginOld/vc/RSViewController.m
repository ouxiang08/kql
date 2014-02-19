//
//  RSViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "RSViewController.h"
#import "RegisterViewController.h"
#import "MokaTabBarViewController.h"
#import "FindPasswordViewController.h"
@interface RSViewController ()

@end

@implementation RSViewController
@synthesize userText;
@synthesize passText;


-(void)viewWillAppear:(BOOL)animated{
    
//    [self.userText becomeFirstResponder];
//    [self.passText becomeFirstResponder];
}

//http://prj.morework.cn/dologin

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"登录";
    
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    UIImageView *subimg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 300, 80)];
    subimg.image=[UIImage imageNamed:@"6-1_07.png"];
    [self.view addSubview:subimg];

//    UIButton *backbtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    backbtn.frame=CGRectMake(10,7, 50, 30);
//    [backbtn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    [backbtn addTarget:self action:@selector(backToTheUpLevel) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:backbtn];

    UILabel *userLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 36, 65, 39)];
    userLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    userLabel.backgroundColor=[UIColor clearColor];
    userLabel.text=@"账  号：";
    userLabel.textColor=[UIColor blackColor];
    //userLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:userLabel];
    UILabel *passLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 76, 65, 39)];
    passLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    passLabel.backgroundColor=[UIColor clearColor];
    passLabel.text=@"密  码：";
    passLabel.textColor=[UIColor blackColor];
    [self.view addSubview:passLabel];
    
    self.userText=[[UITextField alloc] initWithFrame:CGRectMake(80, 48, 225, 20)];
    self.userText.placeholder=@"请输入手机号";
    //self.userText.text = kDefaultMobile;
    self.userText.backgroundColor=[UIColor clearColor];
    self.userText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.userText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:self.userText];
    
    self.passText=[[UITextField alloc] initWithFrame:CGRectMake(80, 88, 225, 20)];
    self.passText.placeholder=@"请输入密码";
    //self.passText.text = kDefaultPassword;
    self.passText.backgroundColor=[UIColor clearColor];
    self.passText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.passText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.passText setSecureTextEntry:YES];
    [self.view addSubview:self.passText];
    
    [self.userText becomeFirstResponder];
    //[self.passText becomeFirstResponder];

    
    UIButton *nextbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    nextbtn.frame=CGRectMake(10,130, 300, 40);
    [nextbtn setBackgroundImage:[UIImage imageNamed:@"99999_06.png"] forState:UIControlStateNormal];
    [nextbtn addTarget:self action:@selector(nextToFinishYourInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextbtn];
    
    NSArray *objrctArr=[[NSArray alloc] initWithObjects:@"忘记密码",@"没有账号，手机一秒注册", nil];
    
    UIButton *forgetbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    forgetbtn.frame=CGRectMake(10,180, 300, 40);
    [forgetbtn setBackgroundImage:[UIImage imageNamed:@"99999_08.png"] forState:UIControlStateNormal];
    [forgetbtn addTarget:self action:@selector(ForgetYourPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetbtn];
    
    UIButton *newuserbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    newuserbtn.frame=CGRectMake(10,230, 300, 40);
    [newuserbtn setBackgroundImage:[UIImage imageNamed:@"99999_08.png"] forState:UIControlStateNormal];
    [newuserbtn addTarget:self action:@selector(MakeTheNewUserWithPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:newuserbtn];
    
    for (int i=0; i<2; i++) {
        UILabel *subLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 183+50*i, 300, 40)];
        subLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
        subLabel.backgroundColor=[UIColor clearColor];
        subLabel.text=[objrctArr objectAtIndex:i];
        subLabel.textColor=[UIColor grayColor];
        [self.view addSubview:subLabel];
    }


}


-(void)nextToFinishYourInformation{
    //if ((self.userText.text.length==11)&&[[self.userText.text substringToIndex:1] isEqualToString:@"1"]&&![self.passText.text isEqualToString:@""]) {
    if (![self.userText.text isEqualToString:@""]&&![self.passText.text isEqualToString:@""]) {

        NSString *strUrl = [UrlHelper stringUrlDoLogin:self.userText.text password:self.passText.text bduid:[[MainModel sharedObject] strBDUid] bdcid:[[MainModel sharedObject] strBDChannelId]];
        [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
            self.maskView.hidden = YES;
            [self.indicatorView stopAnimating];
            int errorNo = [[dictResponse valueForKey:@"code"] integerValue];
            if (errorNo == 1) {
                NSDictionary *dictUserInfo = [dictResponse valueForKey:@"userinfo"];
                NSArray *arrPriceInfo = [dictResponse valueForKey:@"priceinfo"];
                [[MainModel sharedObject] saveUid:[NSString stringWithFormat:@"%d",[[dictUserInfo valueForKey:@"id"] integerValue]]];
                [[MainModel sharedObject] saveUserType:[dictUserInfo valueForKey:@"usertype"]];
                [[MainModel sharedObject] saveDictUserInfo:dictUserInfo];
                [[MainModel sharedObject] savePriceInfo:arrPriceInfo];
                
                [[MainModel sharedObject] saveUserName:self.userText.text];
                [[MainModel sharedObject] savePassword:self.passText.text];
                
                [self.navigationController dismissViewControllerAnimated:NO completion:^(void){}];
                [[MainModel sharedObject].appDelegate.mokaTabBar touchDownAtItemAtIndex:0];
//                UINavigationController *navStart = self.navigationController;
//                [navStart popViewControllerAnimated:NO];
//                
//                MokaTabBarViewController *mokaTabBarVC = [[MokaTabBarViewController alloc] init];
//                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mokaTabBarVC];
//                [UIView beginAnimations: nil context:NULL];
//                [UIView setAnimationDuration:0.5];
//                [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:nav.view cache:YES];
//                [navStart presentViewController:nav animated:NO completion:^(void){}];
//                [UIView commitAnimations];
            }else{
                self.maskView.hidden = YES;
                [self showAlert:@"用户名或密码错误！"];
            }
        } andFailureBlock:^(NSError *error) {
            self.maskView.hidden = YES;
            [self showAlert:@"网络不可用！"];
            //[self showAlert:[error localizedDescription]];
        }];

        
//    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:@"http://prj.morework.cn/dologin"];
//    //第二步，创建请求
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//	    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
//    NSString *str = [NSString stringWithFormat:@"mobile=%@&pass=%@",self.userText.text,self.passText.text];//设置参数
//    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:data];
//   //第三步，连接服务器
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    
//    NSError *error = nil;
//    SBJSON *parser = [[SBJSON alloc] init];
//    NSDictionary *rootDic = [parser objectWithString:jsonString error:&error];
//    NSLog(@"rootDic is %@",rootDic);
//    NSString *resultstring=[rootDic valueForKey:@"msg"];
//    NSLog(@"resultstring is %@",resultstring);
//        if ([resultstring isEqualToString:@""]) {
//            
//         [self showAlert:@"登录成功"];
//            
//        }
//        else{
//            [self showAlert:resultstring];
//        
//        }
    }
    else if((self.userText.text.length==11)&&[[self.userText.text substringToIndex:1] isEqualToString:@"1"]&&[self.passText.text isEqualToString:@""]) {
        
        [self showAlert:@"密码不能为空"];
    }

    else{
        [self showAlert:@"手机号码不合法"];
    }
}

- (void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)ForgetYourPassword{
    FindPasswordViewController *findpassVC=[[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findpassVC animated:YES];
    
    
}

-(void)MakeTheNewUserWithPhone{
    
    RegisterViewController *registerVC=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    
}



-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.userText resignFirstResponder];
    [self.passText resignFirstResponder];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
