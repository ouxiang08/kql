//
//  AuthCodeViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "AuthCodeViewController.h"
#import "SetPasswordViewController.h"

@interface AuthCodeViewController (){
    NSTimer *_timer;
    int iResendVarcodeCount;
}

@end

@implementation AuthCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithThePhoneNumber:(NSString *)PhoneNumber{

    phoneStr=PhoneNumber;
    return self;

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    messArray=[[NSMutableArray alloc] initWithCapacity:0];
    
	self.view.backgroundColor= MOKA_VIEW_BG_COLOR_BLUE;
    self.title = @"验证号码(2/6)";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1" selector:nil target:nil];
  
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"验证号码" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
  
    
    
    UILabel *numLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 40)];
    numLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.text=[NSString stringWithFormat:@"验证码短信已发送到：+86 %@",phoneStr];
    [self.view addSubview:numLabel];
    
    UIImageView *textImageview=[[UIImageView alloc] initWithFrame:CGRectMake(10, 60,300, 40)];
    textImageview.image=[UIImage imageNamed:@"text_box.png"];
    [self.view addSubview:textImageview];
    codeText=[[UITextField alloc] initWithFrame:CGRectMake(20, 74,290, 20)];
    codeText.placeholder=@" 输入验证码";
    codeText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [codeText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];

    [codeText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:codeText];
    
    againbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    againbtn.frame=CGRectMake(10,110, 300, 40);
    [againbtn setTitle:@"重发验证码(60)" forState:(UIControlStateNormal)];
    [againbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [againbtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [againbtn setBackgroundImage:[UIImage imageNamed:@"chongfa.png"] forState:UIControlStateDisabled];
    [againbtn setBackgroundImage:[UIImage imageNamed:@"546555_072.png"] forState:UIControlStateNormal];
    [againbtn addTarget:self action:@selector(AgainToWriteYourCode) forControlEvents:UIControlEventTouchUpInside];
    
    againbtn.enabled = NO;
    iResendVarcodeCount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector:@selector(refreshResendCaption) userInfo: nil repeats: YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mobilechange" object:nil userInfo:nil];
    
    if (_needCounter==1) {
        [self resendAgainBtn];
    }
    
    [self.view addSubview:againbtn];
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


-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)nextToFinishYourInformation{
    
    NSLog(@"验证码：%@",codeText.text);
    //第一步，创建URL
    NSString *requsturl = [NSString stringWithFormat:@"%@/checkregsms",KHomeUrlDefault];
    NSURL *url = [NSURL URLWithString:requsturl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"mobile=%@&vercode=%@",phoneStr,codeText.text];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    SBJSON *parsermsg = [[SBJSON alloc] init];
    NSDictionary *roDic = [parsermsg objectWithString:jsonStr error:&error];
    NSLog(@"roDic is %@",roDic);
    NSString *codestr=[roDic valueForKey:@"code"];
    NSLog(@"resultstr is %@",codestr);
    NSString *resultstr=[roDic valueForKey:@"msg"];
    NSLog(@"resultstr is %@",resultstr);
    if ([resultstr isEqualToString:@""]) {
        
        messArray=[NSMutableArray arrayWithObjects:phoneStr,_invitecode,nil];
        SetPasswordViewController *setpassVC=[[SetPasswordViewController alloc] initWithTheMessArray:messArray];
        [self.navigationController pushViewController:setpassVC animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:resultstr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    
    }
    NSLog(@"-----%@",phoneStr);
    
//    messArray=[NSMutableArray arrayWithObjects:phoneStr,codeText.text,nil];
//            SetPasswordViewController *setpassVC=[[SetPasswordViewController alloc] initWithTheMessArray:messArray];
//    [self.navigationController pushViewController:setpassVC animated:YES];
}

-(void)AgainToWriteYourCode{
    //第一步，创建URL
    NSString *requsturl = [NSString stringWithFormat:@"%@/sendregsms",KHomeUrlDefault];
    NSURL *url = [NSURL URLWithString:requsturl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"mobile=%@&invitecode=%@",phoneStr,_invitecode];//设置参数
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:@"验证码已发送至你的手机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self resendAgainBtn];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"message:@"发送失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        
        }

    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [codeText resignFirstResponder];
   
    
}

- (void)textFieldDidChange{
    if ([codeText.text length]>0) {
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
