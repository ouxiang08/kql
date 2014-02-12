//
//  FindPasswordViewController.m
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "FindPasswordViewController.h"

@interface FindPasswordViewController (){
    NSTimer *_timer;
    int iResendVarcodeCount;
    UIButton *againbtn;
    UILabel *inforLabel;
}

@end

@implementation FindPasswordViewController

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
    self.title = @"找回密码";
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    UIImageView *labImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 36,300, 40)];
    labImage.image=[UIImage imageNamed:@"text_box.png"];
    [self.view addSubview:labImage];
    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 48,80, 20)];
    nameLabel.text=[NSString stringWithFormat:@"手机号："];
    nameLabel.backgroundColor=[UIColor clearColor];
    [nameLabel setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:nameLabel];
    
    phoneNumber=[[UITextField alloc] initWithFrame:CGRectMake(100, 50, 210, 20)];
    phoneNumber.backgroundColor=[UIColor clearColor];
    phoneNumber.clearButtonMode=UITextFieldViewModeWhileEditing;
    [phoneNumber setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:phoneNumber];
    
    againbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    againbtn.frame=CGRectMake(10,86, 300, 40);
    [againbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [againbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [againbtn setBackgroundImage:[UIImage imageNamed:@"chongfa.png"] forState:UIControlStateDisabled];
    [againbtn setBackgroundImage:[UIImage imageNamed:@"546555_072.png"] forState:UIControlStateNormal];
    [againbtn setTitle:@"获取密码" forState:UIControlStateNormal];
    [againbtn addTarget:self action:@selector(FindYourPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againbtn];
    
    inforLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 146, 300, 40)];
    inforLabel.font=[UIFont fontWithName:KdefaultFont size:12];
    inforLabel.backgroundColor=[UIColor clearColor];
    inforLabel.text=@"(密码已经发送至你的手机，如未收到，可重新获取)";
    inforLabel.hidden = YES;
    [self.view addSubview:inforLabel];
    /*
    UIImageView *passImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 196,300, 40)];
    passImage.image=[UIImage imageNamed:@"text_box.png"];
    [self.view addSubview:passImage];
    UILabel *passLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 196,70, 40)];
    passLabel.text=[NSString stringWithFormat:@"密码："];
    passLabel.backgroundColor=[UIColor clearColor];
    [passLabel setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:passLabel];
    
    passWord=[[UITextField alloc] initWithFrame:CGRectMake(90, 206, 210, 20)];
    passWord.backgroundColor=[UIColor clearColor];
    passWord.clearButtonMode=UITextFieldViewModeWhileEditing;
    [passWord setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [passWord setSecureTextEntry:YES];
    [self.view addSubview:passWord];
    
    UIButton *surebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    surebtn.frame=CGRectMake(10,246, 300, 40);
    [surebtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [surebtn setBackgroundImage:[UIImage imageNamed:@"546555_072.png"] forState:UIControlStateNormal];
    [surebtn addTarget:self action:@selector(MakeSureYourPasswordRight) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:surebtn];
     */
    [phoneNumber becomeFirstResponder];
}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)FindYourPassword{
    NSLog(@"mobile=%@",phoneNumber.text);
    
    if ((phoneNumber.text.length==11)&&[[phoneNumber.text substringToIndex:1] isEqualToString:@"1"]) {
        inforLabel.hidden = NO;
        
        
        //第一步，创建URLhttp://prj.morework.cn/getpass
        NSString *requsturl = [NSString stringWithFormat:@"%@/getpass",KHomeUrlDefault];
        NSURL *url = [NSURL URLWithString:requsturl];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = [NSString stringWithFormat:@"mobile=%@",phoneNumber.text];//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        
        
        NSError *error = nil;
        SBJSON *parser = [[SBJSON alloc] init];
        NSDictionary *rootDic = [parser objectWithString:jsonString error:&error];
        NSLog(@"rootDic is %@",rootDic);
        NSString *resultstring=[rootDic valueForKey:@"msg"];
        NSLog(@"resultstring is %@",resultstring);
        if([resultstring isEqualToString:@""]){
            [self showAlert:@"密码已发送至您的手机"];
            [self resendAgainBtn];
        }
        else{
            [self showAlert:resultstring];
            
        }

        
    }
    
    else{
        [self showAlert:@"手机号码不合法"];
    }

}

- (void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(void)resendAgainBtn{
    againbtn.enabled = NO;
    iResendVarcodeCount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector:@selector(refreshResendCaption) userInfo: nil repeats: YES];
}

- (void)refreshResendCaption
{
    iResendVarcodeCount--;
    if ( iResendVarcodeCount >= 0 ) {
        [againbtn setTitle: [NSString stringWithFormat: @"重发验证码(%i)", iResendVarcodeCount] forState:(UIControlStateNormal)];
    } else {
        [_timer invalidate];
        _timer = nil;
        [againbtn setTitle: [NSString stringWithFormat: @"重发验证码"] forState:(UIControlStateNormal)];
        againbtn.enabled = YES;
    }
}


-(void)MakeSureYourPasswordRight{
    if ((phoneNumber.text.length==11)&&[[phoneNumber.text substringToIndex:1] isEqualToString:@"1"]&&![passWord.text isEqualToString:@""]) {
        //第一步，创建URLhttp://prj.morework.cn/dologin
        NSString *requsturl = [NSString stringWithFormat:@"%@/dologin",KHomeUrlDefault];
        NSURL *url = [NSURL URLWithString:requsturl];
        //第二步，创建请求
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
	    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        NSString *str = [NSString stringWithFormat:@"mobile=%@&pass=%@",phoneNumber.text,passWord.text];//设置参数
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
        NSError *error = nil;
        SBJSON *parser = [[SBJSON alloc] init];
        NSDictionary *rootDic = [parser objectWithString:jsonString error:&error];
        NSLog(@"rootDic is %@",rootDic);
        NSString *resultstring=[rootDic valueForKey:@"msg"];
        NSLog(@"resultstring is %@",resultstring);
        if([resultstring isEqualToString:@""]){
        
            [self showAlert:@"登录成功"];
        }
        else{
            [self showAlert:resultstring];
        }
        
    }
    else if((phoneNumber.text.length==11)&&[[phoneNumber.text substringToIndex:1] isEqualToString:@"1"]&&[passWord.text isEqualToString:@""]) {
        
        [self showAlert:@"密码不能为空"];
    }
    
    else{
        [self showAlert:@"手机号码不合法"];
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [phoneNumber resignFirstResponder];
    [passWord resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
