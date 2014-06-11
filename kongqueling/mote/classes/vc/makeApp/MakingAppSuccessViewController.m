//
//  MakingAppSuccessViewController.m
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MyAppListViewController.h"
#import "MakingAppSuccessViewController.h"

@interface MakingAppSuccessViewController ()

@end

@implementation MakingAppSuccessViewController

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
    self.title = @"已生成";
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"我的APP" selector:@selector(onMyAppListClick) target:self];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    // Do any additional setup after loading the view from its nib.
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,_imgapth];
    [_imgvIcon setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    _imgvIcon.contentMode = KimageShowMode;
    _imgvIcon.layer.cornerRadius = 15;
    _imgvIcon.layer.masksToBounds = YES;
    [_imgvIcon setClipsToBounds:YES];
    
    _appname.text = _apptitle;
                       
}

-(void)onMyAppListClick{
    MyAppListViewController *appListVC = [[MyAppListViewController alloc] init];
    [self.navigationController pushViewController:appListVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickInstall:(id)sender {
    [[ToastViewAlert defaultCenter] setTime:5];
     [[ToastViewAlert defaultCenter] postAlertWithMessage:@"正在下载，请耐心等候！"];
    NSURL *url=[NSURL URLWithString:_iosDownloadUrl];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)clickShare:(id)sender {
    NSString *strContent = [NSString stringWithFormat:@"这是我通过孔雀翎生成的%@，想要看我的作品就快去下载吧！#网拍神器孔雀翎#",_allDownloadUrl];
    
     NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,_imgapth];
    
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:strImageUrl]
                                                title:@"孔雀翎"
                                                  url:_allDownloadUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    //指定要分享的平台
    NSArray *shareList = [ShareSDK getShareListWithType:
                          ShareTypeWeixiSession,
                          ShareTypeWeixiTimeline,
                          ShareTypeSinaWeibo,
                          ShareTypeTencentWeibo,
                          ShareTypeQQ,
                          ShareTypeCopy,
                          nil];
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}
@end
