//
//  AboutViewController.m
//  mote
//
//  Created by harry on 13-12-29.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    self.title = @"关于孔雀翎";
    
    UIScrollView *sclMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, MOKA_SCREEN_HEIGHT)];
    sclMain.contentSize = CGSizeMake(320, 506);
    sclMain.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sclMain];
    
    
    UIImage *image=[UIImage imageNamed:@"about_kql.png"];
    UIImageView *bgImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,image.size.width, image.size.height)];
    bgImageview.image=image;
    [sclMain addSubview:bgImageview];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    //NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    // app build版本
    //NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    /*
    UIImage *image2=[UIImage imageNamed:@"about_txt.png"];
    UIImageView *textImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 15,image2.size.width, image2.size.height)];
    textImageview.image=image2;
    [sclMain addSubview:textImageview];
*/
    
    UILabel *numLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 15, 310, 12)];
    numLabel.font=[UIFont fontWithName:KdefaultFont size:12];
    numLabel.backgroundColor=[UIColor clearColor];
    numLabel.textAlignment = NSTextAlignmentRight;
    numLabel.text= [NSString stringWithFormat:@"软件版本：V %@",app_Version];
    [self.view addSubview:numLabel];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
