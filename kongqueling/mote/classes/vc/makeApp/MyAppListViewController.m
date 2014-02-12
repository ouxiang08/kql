//
//  MyAppListViewController.m
//  mote
//
//  Created by sean on 12/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MakingAppViewController.h"
#import "MyAppListTableViewCell.h"
#import "MyAppListViewController.h"

@interface MyAppListViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_arrAppList;
}

@end

@implementation MyAppListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _arrAppList = [[NSArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的APP";
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"新建APP" selector:@selector(onCreateApp) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self getAppListRequest];
    // Do any additional setup after loading the view from its nib.
}

-(void)onCreateApp{
    MakingAppViewController *makingAppVC = [[MakingAppViewController alloc] init];
    [self.navigationController pushViewController:makingAppVC animated:YES];
}

-(void)getAppListRequest{
    NSString *strUrl = [UrlHelper stringUrlGetAppList];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _arrAppList = (NSArray *)dictResponse;
        [self.tableViewAppList reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrAppList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"MyAppListTableViewCell";
    MyAppListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    
    if (!cell) {
        cell = [[MyAppListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    
    NSDictionary *dictApp = [_arrAppList objectAtIndex:indexPath.row];
    cell.labelTitle.text = [dictApp valueForKey:@"appname"];
    cell.labelDateTime.text = [NSString stringWithFormat:@"%@ 生成",[[dictApp valueForKey:@"ctime"] substringToIndex:10]];
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,[dictApp valueForKey:@"homeImg"]];
    [cell.imageViewLogo setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.imageViewLogo.contentMode = KimageShowMode;
    [cell.imageViewLogo setClipsToBounds:YES];
    
    [cell.buttonInstall addTarget:self action:@selector(clickInstallApp:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonInstall.tag = indexPath.row;
    
    [cell.buttonShare addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonShare.tag = indexPath.row;
    
    return cell;
}

- (void)clickInstallApp:(UIButton *)bt{
    [[ToastViewAlert defaultCenter] postAlertWithMessage:@"已加入下载序列，请留意下载完毕后的提示！"];

    NSDictionary *dic = [_arrAppList objectAtIndex:bt.tag];
    NSString *downurl = [dic objectForKey:@"iosDownloadPath"];
    NSURL *url=[NSURL URLWithString:downurl];
    [[UIApplication sharedApplication] openURL:url];
    

}

- (void)clickShare:(UIButton *)bt{
    NSDictionary *dic = [_arrAppList objectAtIndex:bt.tag];
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,[dic valueForKey:@"homeImg"]];
    NSString *downurl = [dic objectForKey:@"allDownloadPath"];
    NSString *strContent = [NSString stringWithFormat:@"这是我通过孔雀翎生成的%@，想要看我的作品就快去下载吧！#网拍神器孔雀翎#",downurl];
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:strImageUrl]
                                                title:@"孔雀翎"
                                                  url:downurl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    [ShareSDK showShareActionSheet:container
                         shareList:nil
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
