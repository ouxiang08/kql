//
//  MechantWebViewController.m
//  mote
//
//  Created by harry on 14-1-4.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "MechantWebViewController.h"

@interface MechantWebViewController (){
     UIWebView* _webView;
}

@end

@implementation MechantWebViewController

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
    self.title = @"机构详细";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, 320, MOKA_SCREEN_HEIGHT)];
    [(UIScrollView *)[[_webView subviews] objectAtIndex:0] setBounces:NO];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    NSURL *url =  [NSURL URLWithString:_url];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
