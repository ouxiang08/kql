//
//  MessageDetailViewController.m
//  mote
//
//  Created by harry on 13-12-30.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MechantWebViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

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
    
    if (_msgTypeId==1) {
        self.title = @"系统消息";
    }
    if (_msgTypeId==2) {
        self.title = @"任务消息";
    }
    if (_msgTypeId==3) {
        self.title = @"邀约消息";
    }
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"delete.png" selector:@selector(onDelete) target:self];
    
    
    UILabel *labelTime = [[UILabel alloc] init];
    labelTime.font = [UIFont systemFontOfSize:13];
    labelTime.textColor = [UIColor darkGrayColor];
    labelTime.frame = CGRectMake(23, 22, 200, 20);
    labelTime.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:labelTime];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; //
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[_msgInfo objectForKey:@"add_time"] intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    labelTime.text = confromTimespStr;
    
    UIView *uvline = [[UIView alloc] initWithFrame:CGRectMake(23, 44, 300, 1)];
    uvline.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:uvline];
    
    
    UITextView *txtDesc = [[UITextView alloc] initWithFrame:CGRectMake(20, 55, 270, 300)];
    txtDesc.backgroundColor = [UIColor clearColor];
    txtDesc.textColor = [UIColor blackColor];
    [txtDesc setFont:[UIFont systemFontOfSize:13]];
    txtDesc.editable = NO;
    txtDesc.textAlignment = NSTextAlignmentLeft;
    txtDesc.text = [_msgInfo objectForKey:@"content"];
    [self.view addSubview:txtDesc];
    
    if (_msgTypeId==3) {
        
        UIButton *linkbt=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        linkbt.frame=CGRectMake(110,[UIScreen mainScreen].bounds.size.height-180, 100, 40);
        [linkbt setTitle:@"查看机构详细" forState:(UIControlStateNormal)];
        linkbt.tag = [[_msgInfo objectForKey:@"otherinfo"] intValue];
        [linkbt addTarget:self action:@selector(clickDetail:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:linkbt];
        
        
        
        if ([[_msgInfo objectForKey:@"status"] isEqualToString:@"0"]) {
            UIButton *acceptbtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            acceptbtn.frame=CGRectMake(10,[UIScreen mainScreen].bounds.size.height-120, 100, 40);
            [acceptbtn setTitle:@"接受" forState:(UIControlStateNormal)];
            acceptbtn.tag = 1;
            [acceptbtn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:acceptbtn];
            
            UIButton *refusebtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            refusebtn.frame=CGRectMake(210,[UIScreen mainScreen].bounds.size.height-120, 100, 40);
            [refusebtn setTitle:@"拒绝" forState:(UIControlStateNormal)];
            refusebtn.tag = 2;
            [refusebtn addTarget:self action:@selector(onAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:refusebtn];
        }else if([[_msgInfo objectForKey:@"status"] isEqualToString:@"1"]){
            UILabel *resultLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, 320, 12)];
            resultLabel.font=[UIFont fontWithName:KdefaultFont size:12];
            resultLabel.backgroundColor=[UIColor clearColor];
            resultLabel.textAlignment = NSTextAlignmentCenter;
            resultLabel.text= @"已通过邀约请求";
            [self.view addSubview:resultLabel];
        }else if([[_msgInfo objectForKey:@"status"] isEqualToString:@"-1"]){
            UILabel *resultLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-120, 320, 12)];
            resultLabel.font=[UIFont fontWithName:KdefaultFont size:12];
            resultLabel.backgroundColor=[UIColor clearColor];
            resultLabel.textAlignment = NSTextAlignmentCenter;
            resultLabel.text= @"已拒绝邀约请求";
            [self.view addSubview:resultLabel];
        }
    }
  
}

-(void)onDelete{
    
    NSString *strAlbum = [UrlHelper stringUrlMessageDelete];
    NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
    
    [dicParameter setObject:[_msgInfo objectForKey:@"id"] forKey:@"msgId"];
    
    [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
        NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
        if (errorNo == 1) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } andFailureBlock:^(NSError *error) {
        
    }];
}

- (void)clickDetail:(UIButton *)bt{
    MechantWebViewController *mwvc = [[MechantWebViewController alloc] init];
    
    NSString *weburl = [NSString stringWithFormat:@"http://www.tupai.cc/shopkql.html?id=%d",bt.tag];
    mwvc.url = weburl;
    [self.navigationController pushViewController:mwvc animated:YES];
}

-(void)onAction:(UIButton *)bt{
    
    NSString *strAlbum = [UrlHelper stringUrlMessageUpdte];
    NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
    
    [dicParameter setObject:[_msgInfo objectForKey:@"id"] forKey:@"msgId"];
    if (bt.tag==1) {
        [dicParameter setObject:@"1" forKey:@"status"];
    }
    if (bt.tag==2) {
        [dicParameter setObject:@"-1" forKey:@"status"];
    }
    
    [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
        NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
        if (errorNo == 1) {
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"操作成功！"];

            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } andFailureBlock:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
