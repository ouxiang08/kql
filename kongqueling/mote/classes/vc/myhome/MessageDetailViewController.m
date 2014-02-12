//
//  MessageDetailViewController.m
//  mote
//
//  Created by harry on 13-12-30.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MessageDetailViewController.h"

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
    [formatter setDateFormat:@"YYYY-MM-dd"]; //
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
