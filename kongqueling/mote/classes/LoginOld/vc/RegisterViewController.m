//
//  RegisterViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "RegisterViewController.h"
#import "AuthCodeViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize userText;
@synthesize passText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"验证号码(1/6)";
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    _gocounter = 0;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"验证号码" style: UIBarButtonItemStyleBordered target: nil action: nil];
    self.navigationItem.backBarButtonItem = newBackButton;
    
    UIImageView *subimg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 300, 80)];
    subimg.image=[UIImage imageNamed:@"6-1_07.png"];
    [self.view addSubview:subimg];
    
    UILabel *userLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 36, 70, 39)];
    userLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    userLabel.backgroundColor=[UIColor clearColor];
    userLabel.text=@"账   号：";
    userLabel.textColor=[UIColor blackColor];
    //userLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:userLabel];
    UILabel *passLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 76, 70, 39)];
    passLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    passLabel.backgroundColor=[UIColor clearColor];
    passLabel.text=@"邀请码：";
    passLabel.textColor=[UIColor blackColor];
    [self.view addSubview:passLabel];
    
    self.userText=[[UITextField alloc] initWithFrame:CGRectMake(90, 47, 215, 20)];
    self.userText.placeholder=@"请输入手机号";
    self.userText.keyboardType = UIKeyboardTypePhonePad;
    [self.userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    self.userText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.userText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:self.userText];
    
    self.passText=[[UITextField alloc] initWithFrame:CGRectMake(90, 87, 215, 20)];
    self.passText.placeholder=@"官方微信kqlapp上申请";
    self.passText.keyboardType = UIKeyboardTypeDefault;
    [self.userText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    self.passText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.passText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:self.passText];
    
    UILabel *inforLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 120, 300, 70)];
    inforLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    inforLabel.backgroundColor=[UIColor clearColor];
    inforLabel.text=@"输入你的手机号码。免费注册孔雀翎，孔雀翎不会再任何地方泄露你的号码。";
    inforLabel.lineBreakMode = NSLineBreakByWordWrapping;
    inforLabel.numberOfLines = 0;
    inforLabel.textColor=[UIColor lightGrayColor];
    [self.view addSubview:inforLabel];
    
    
    [self.userText becomeFirstResponder];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mobilechange:)
                                                 name:@"mobilechange" object:nil];


}

- (void)mobilechange:(NSNotification *)notification {
    _gocounter = 1;
}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextToFinishYourInformation{
    
    if ((self.userText.text.length==11)&&[self.userText.text substringToIndex:1]) {
        if (_gocounter==1) {
            AuthCodeViewController *authcodeVC=[[AuthCodeViewController alloc] initWithThePhoneNumber:self.userText.text];
            authcodeVC.needCounter = 1;
            authcodeVC.invitecode = self.passText.text;
            [self.navigationController pushViewController:authcodeVC animated:YES];
        }else{
            //第一步，创建URL
            NSString *requsturl = [NSString stringWithFormat:@"%@/sendregsms",KHomeUrlDefault];
            NSURL *url = [NSURL URLWithString:requsturl];
           //第二步，创建请求
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
            [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
            NSString *str = [NSString stringWithFormat:@"mobile=%@&invitecode=%@",self.userText.text,self.passText.text];//设置参数
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:data];
            //第三步，连接服务器
            NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *jsonStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
            
            NSError *error = nil;
            SBJSON *parsermsg = [[SBJSON alloc] init];
            NSDictionary *roDic = [parsermsg objectWithString:jsonStr error:&error];
            NSLog(@"roDic is %@",roDic);
            NSString *resultstr=[roDic valueForKey:@"msg"];
            NSLog(@"resultstr is %@",resultstr);
            if ([resultstr isEqualToString:@""]) {
                AuthCodeViewController *authcodeVC=[[AuthCodeViewController alloc] initWithThePhoneNumber:self.userText.text];
                authcodeVC.invitecode = self.passText.text;
                [self.navigationController pushViewController:authcodeVC animated:YES];
            }
            else{
                [self showAlert:resultstr];
            
            }
        }
    }
    else if((self.userText.text.length<11)&&![self.userText.text isEqualToString:@""]){
          [self showAlert:@"手机号码不合法"];
    }
    else{
        [self showAlert:@"请输入手机号码"];
    }

    
//    AuthCodeViewController *authcodeVC=[[AuthCodeViewController alloc] initWithThePhoneNumber:self.userText.text];
//    [self.navigationController pushViewController:authcodeVC animated:YES];
}

- (void)showAlert:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)textFieldDidChange{
    if ([self.userText.text length]>0 || [self.passText.text length]>0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_0.png" selector:@selector(nextToFinishYourInformation) target:self];
        
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    }
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
