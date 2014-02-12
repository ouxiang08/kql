//
//  SettingViewController.m
//  mote
//
//  Created by harry on 13-12-29.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutViewController.h"
#import "WeixinViewController.h"
#import "UpdatePasswordViewController.h"
#import "MokaTabBarViewController.h"
#import "StartPageViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    self.title = @"设置";
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    _formTableView.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;
    
    
    UIButton *logoutbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    logoutbtn.frame=CGRectMake(5,255, 310, 40);
    [logoutbtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
    [logoutbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutbtn setBackgroundImage:[UIImage imageNamed:@"546555_072.png"] forState:UIControlStateNormal];
    [logoutbtn addTarget:self action:@selector(clickLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutbtn];
     

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)clickLogout
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"确定要退出登录吗？"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确认"
                                  otherButtonTitles:nil,nil];
    [actionSheet showInView:self.view];
   
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0){
        
        NSString *strAlbum = [UrlHelper stringUrlUnbind];
        NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
        
        [dicParameter setObject:@"" forKey:@"channelid"];
        [dicParameter setObject:@"" forKey:@"bduid"];
        
        [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
            NSLog(@"dictResponse:%@",dictResponse);
            NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
            if (errorNo == 1) {
                [[MainModel sharedObject] saveUid:nil];
                StartPageViewController *rsVC = [[StartPageViewController alloc] init];
                //LoginViewController *loginVC = [[LoginViewController alloc] init];
                UINavigationController *navStart = [[WCCNavigationController alloc] initWithRootViewController:rsVC];
                UINavigationController *navSelf = self.navigationController;
                [navSelf popViewControllerAnimated:NO];
                [navSelf presentViewController:navStart animated:NO completion:^(void){}];
                
                //MokaTabBarViewController *tabarVC = (MokaTabBarViewController *)self.parentViewController;
                //[tabarVC dismissViewControllerAnimated:YES completion:^(void){}];
            }
        } andFailureBlock:^(NSError *error) {
            NSLog(@"error:%@",[error localizedDescription]);
        }];
    }
}

#pragma mark Table view methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else if (section==1) {
        return 3;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        
        cell.textLabel.text = @"修改密码";
        
    }
    
    
    
    if (indexPath.section==1) {
//        UILabel *labelName3 = [Util getLabel:15 bold:NO color:DARK_GRAY_COLOR];
//        labelName3.frame = CGRectMake(detailX, detailY, detailW+50, detailH);
//        labelName3.textAlignment = NSTextAlignmentLeft;
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"官方微信";
                break;
            case 1:
                cell.textLabel.text = @"客服电话";
                break;
            case 2:
                cell.textLabel.text = @"关于孔雀翎";
                break;
            default:
                break;
        }
        //[cell addSubview:labelName3];
    }
    
        
    
	return cell;
}

#pragma mark - UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",KHotLine]]];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section==1 || section==2) {
//        return SETTING_FOOT_HEIGH;
//    }
//    return 0;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 50)];
//    view.backgroundColor = BGCOLOR;
//    
//    UILabel *labelIDTxt = [Util getLabel:15 bold:NO color:MIDDLE_GRAY_COLOR];
//    labelIDTxt.frame = CGRectMake(0, 15, CGRectGetWidth(tableView.frame), 20);
//    if (section==0) {
//        labelIDTxt.text = @"当前帐号";
//    }
//    if (section==1) {
//        labelIDTxt.text = @"分享绑定";
//    }
//    if (section==2) {
//        labelIDTxt.text = @"消息通知";
//    }
//    if (section==3) {
//        labelIDTxt.text = @"关于我们";
//    }
//    labelIDTxt.backgroundColor = [UIColor clearColor];
//    labelIDTxt.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:labelIDTxt];
//    return view;
//}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellAccessoryDisclosureIndicator;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        UpdatePasswordViewController *abv = [[UpdatePasswordViewController alloc] init];
        [self.navigationController pushViewController:abv animated:YES];
        
    }
    
    if (indexPath.section==1) {
        
        switch (indexPath.row) {
            case 0:
            {
                WeixinViewController *wxbv = [[WeixinViewController alloc] init];
                [self.navigationController pushViewController:wxbv animated:YES];
                break;
            }
                
            case 1:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"呼叫客服 %@?",KHotLine] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
                
                break;
            }
            case 2:
            {
                AboutViewController *abv = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:abv animated:YES];
                break;
                
            }
            case 3:
            {
               
                break;
                
            }
                
            default:
                break;
        }
    }

}

@end
