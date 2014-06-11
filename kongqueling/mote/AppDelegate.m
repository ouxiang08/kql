//
//  AppDelegate.m
//  mote
//
//  Created by sean on 11/5/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "StartPageViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "BaiduMobStat.h"
#import "MokaTabBarViewController.h"
#import "UrlHelper.h"

@implementation AppDelegate

static UIView* viewShare;


+(UIView*)getShareView
{
    return viewShare;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self shareSdkConfig];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; // 是否允许截获并发送崩溃信息，请设置YES或者NO
    statTracker.channelId = @"normal";//设置您的app的发布渠道
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;//根据开发者设定的时间间隔接口发送 也可以使用启动时发送策略
    statTracker.logSendInterval = 1;  //为1时表示发送日志的时间间隔为1小时
    statTracker.logSendWifiOnly = YES; //是否仅在WIfi情况下发送日志数据
    statTracker.sessionResumeInterval = 35;//设置应用进入后台再回到前台为同一次session的间隔时间[0~600s],超过600s则设为600s，默认为30s,测试时使用1S可以用来测试日志的发送。
    //statTracker.enableDebugOn = YES; //打开sdk调试接口，会有log打印
    [statTracker startWithAppId:@"94f53bb104"];//设置您在mtj网站上添加的app的appkey
    
    [BPush setupChannel:launchOptions];
    // 必须。参数对象必须实现(void)onMethod:(NSString*)method response:(NSDictionary*)data 方法,本示例中为 self
    [BPush setDelegate:self];
    
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    
    [application setApplicationIconBadgeNumber:0];

    self.mokaTabBar = [[MokaTabBarViewController alloc] init];
    self.nav = [[WCCNavigationController alloc] initWithRootViewController:self.mokaTabBar];
    self.window.rootViewController = self.nav;
    
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.nav.navigationBar.titleTextAttributes = navBarTextAttributes;
    
    NSString *strUrl = [UrlHelper stringUrlCheckUid:[MainModel sharedObject].strUid];
    NSURL *query = [NSURL URLWithString:strUrl];
    NSString *uid = [NSString stringWithContentsOfURL:query encoding:NSUTF8StringEncoding error:nil];
    if ([uid isEqualToString:@"1"]) {
        //[self.mokaTabBar touchDownAtItemAtIndex:1];
        [self.mokaTabBar touchDownAtItemAtIndex:0];
        
        if ([[MainModel sharedObject].strUid length]>0) {
            NSString *strUrl2 = [UrlHelper stringUrlCheckUMsg:[MainModel sharedObject].strUid];
            NSURL *query2 = [NSURL URLWithString:strUrl2];
            NSString *umsg = [NSString stringWithContentsOfURL:query2 encoding:NSUTF8StringEncoding error:nil];
            NSArray *msgarr = [umsg componentsSeparatedByString:@"-"];
            //NSArray *msgarr = [NSArray arrayWithObjects:@"3",@"2",@"1", nil];
            /*------------------------------------------jiajingjing--------------------------------------------------*/
            [[MainModel sharedObject] saveMsgNum:[msgarr objectAtIndex:0] secondNum:[msgarr objectAtIndex:1] thirdNum:[msgarr objectAtIndex:2]];
            int totalNum = [[[MainModel sharedObject] getNumByIndex:3] intValue];
            if (totalNum>0) {
                [self.mokaTabBar setBadgeNumer:3 number:totalNum];
            }
        }
    }
    
//    else{
//        StartPageViewController *rsVC = [[StartPageViewController alloc] init];
//        //LoginViewController *loginVC = [[LoginViewController alloc] init];
//        UINavigationController *navStart = [[WCCNavigationController alloc] initWithRootViewController:rsVC];
//        NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
//        [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//        navStart.navigationBar.titleTextAttributes = navBarTextAttributes;
//        
//        [self.nav presentViewController:navStart animated:NO completion:^(void){}];
//    }
    
//    if (![MainModel sharedObject].strUid) {
//        StartPageViewController *rsVC = [[StartPageViewController alloc] init];
//        //LoginViewController *loginVC = [[LoginViewController alloc] init];
//        UINavigationController *navStart = [[WCCNavigationController alloc] initWithRootViewController:rsVC];
//        
//        NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
//        [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//        navStart.navigationBar.titleTextAttributes = navBarTextAttributes;
//        //App第一次启动的时候，初始化badge's number
//        [[MainModel sharedObject] saveMsgNum:@"0" secondNum:@"0" thirdNum:@"0"];
//        
//        [self.nav presentViewController:navStart animated:NO completion:^(void){}];
//    }else{
//        
//        NSString *strUrl = [UrlHelper stringUrlCheckUid:[MainModel sharedObject].strUid];
//        NSURL *query = [NSURL URLWithString:strUrl];
//        NSString *uid = [NSString stringWithContentsOfURL:query encoding:NSUTF8StringEncoding error:nil];
//        if ([uid isEqualToString:@"1"]) {
//            [self.mokaTabBar touchDownAtItemAtIndex:1];
//            [self.mokaTabBar touchDownAtItemAtIndex:0];
//            
//            if ([[MainModel sharedObject].strUid length]>0) {
//                NSString *strUrl2 = [UrlHelper stringUrlCheckUMsg:[MainModel sharedObject].strUid];
//                NSURL *query2 = [NSURL URLWithString:strUrl2];
//                NSString *umsg = [NSString stringWithContentsOfURL:query2 encoding:NSUTF8StringEncoding error:nil];
//                NSArray *msgarr = [umsg componentsSeparatedByString:@"-"];
//                //NSArray *msgarr = [NSArray arrayWithObjects:@"3",@"2",@"1", nil];
//                /*------------------------------------------jiajingjing--------------------------------------------------*/
//                [[MainModel sharedObject] saveMsgNum:[msgarr objectAtIndex:0] secondNum:[msgarr objectAtIndex:1] thirdNum:[msgarr objectAtIndex:2]];
//                int totalNum = [[[MainModel sharedObject] getNumByIndex:3] intValue];
//                if (totalNum>0) {
//                    [self.mokaTabBar setBadgeNumer:3 number:totalNum];
//                }
//            }
//        }else{
//            StartPageViewController *rsVC = [[StartPageViewController alloc] init];
//            //LoginViewController *loginVC = [[LoginViewController alloc] init];
//            UINavigationController *navStart = [[WCCNavigationController alloc] initWithRootViewController:rsVC];
//            NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
//            [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
//            navStart.navigationBar.titleTextAttributes = navBarTextAttributes;
//            
//            [self.nav presentViewController:navStart animated:NO completion:^(void){}];
//        }
//    }
    
     [self.mokaTabBar touchDownAtItemAtIndex:0];
    
    if (![[MainModel sharedObject] location]) {
        [[MainModel sharedObject] startPosition];
    }
    
    viewShare = [[UIView alloc]initWithFrame:CGRectMake(200, 200, 10, 10)];
    [self.window addSubview:viewShare];
    
    [MainModel sharedObject].appDelegate = self;
    
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
     NSLog(@"test:%@",deviceToken);
    [BPush registerDeviceToken: deviceToken];
    [BPush bindChannel];
//    self.viewController.textView.text = [self.viewController.textView.text stringByAppendingFormat: @"Register device token: %@\n", deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void) onMethod:(NSString*)method response:(NSDictionary*)data {
    NSLog(@"On method:%@", method);
    NSLog(@"data:%@", [data description]);
    NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        if (returnCode == BPushErrorCode_Success) {
            [[MainModel sharedObject] saveBDUid:userid];
            [[MainModel sharedObject] saveBDChannelId:channelid];
//            self.viewController.appidText.text = appid;
//            self.viewController.useridText.text = userid;
//            self.viewController.channelidText.text = channelid;
//            
//            // 在内存中备份，以便短时间内进入可以看到这些值，而不需要重新bind
//            self.appId = appid;
//            self.channelId = channelid;
//            self.userId = userid;
        }
    } else if ([BPushRequestMethod_Unbind isEqualToString:method]) {
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        if (returnCode == BPushErrorCode_Success) {
//            self.viewController.appidText.text = nil;
//            self.viewController.useridText.text = nil;
//            self.viewController.channelidText.text = nil;
            [[MainModel sharedObject] saveBDUid:@""];
            [[MainModel sharedObject] saveBDChannelId:@""];
        }
    }
//    self.viewController.textView.text = [[NSString alloc] initWithFormat: @"%@ return: \n%@", method, [data description]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"Receive Notify: %@", [userInfo JSONString]);
//    NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
//    if (application.applicationState == UIApplicationStateActive) {
//        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a Remote Notification"
//                                                            message:[NSString stringWithFormat:@"The application received this remote notification while it was running:\n%@", alert]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//    }
    
    if ([[MainModel sharedObject].strUid length]>0) {
        NSString *strUrl2 = [UrlHelper stringUrlCheckUMsg:[MainModel sharedObject].strUid];
        NSURL *query2 = [NSURL URLWithString:strUrl2];
        NSString *umsg = [NSString stringWithContentsOfURL:query2 encoding:NSUTF8StringEncoding error:nil];
        NSArray *msgarr = [umsg componentsSeparatedByString:@"-"];
        //NSArray *msgarr = [NSArray arrayWithObjects:@"3",@"2",@"1", nil];
        /*------------------------------------------jiajingjing--------------------------------------------------*/
        [[MainModel sharedObject] saveMsgNum:[msgarr objectAtIndex:0] secondNum:[msgarr objectAtIndex:1] thirdNum:[msgarr objectAtIndex:2]];
        int totalNum = [[[MainModel sharedObject] getNumByIndex:3] intValue];
        if (totalNum>0) {
            [self.mokaTabBar setBadgeNumer:3 number:totalNum];
        }
    }
    
    [application setApplicationIconBadgeNumber:0];
    
    [BPush handleNotification:userInfo];
    
//    self.viewController.textView.text = [self.viewController.textView.text stringByAppendingFormat:@"Receive notification:\n%@", [userInfo JSONString]];
}

-(void)shareSdkConfig{
    [ShareSDK registerApp:KAppKey];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:KSinaAppKey
                               appSecret:KSinaAppSecret
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:KTengXunWeiBoAppKey
                                  appSecret:KTengXunWeiBoAppSecret
                                redirectUri:@"http://kql.tupai.cc"];
    
    //添加微信分享
    [ShareSDK connectWeChatWithAppId:KWeiXinAppid wechatCls:[WXApi class]];
    
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:KQQSpaceAppId
                           appSecret:KQQSpaceAppId];
    
    [ShareSDK connectQQWithQZoneAppKey:KQQSpaceAppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //添加豆瓣应用
    [ShareSDK connectDoubanWithAppKey:KDouPanAppKey
                            appSecret:KDouPanAppSecretKey
                          redirectUri:@"http://prj.morework.cn/syq/"];
    
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:KRenRenAppKey
                            appSecret:KRenRenSecretKey];
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    NSString *strUrl = [UrlHelper stringUrlGetVersion];
    NSString *umsg = [NSString stringWithContentsOfURL:[NSURL URLWithString:strUrl] encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *nowversion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *msgarr = [umsg JSONValue];
    NSString *newversion = [msgarr objectForKey:@"ver"];
    if (![nowversion isEqualToString:newversion]) {
        _downloadurl = [msgarr objectForKey:@"downloadurl"];
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:[msgarr objectForKey:@"title"]
                                                      message:[msgarr objectForKey:@"message"]
                                                     delegate:self
                                            cancelButtonTitle:@"稍后提醒"
                                            otherButtonTitles:@"现在更新",nil];
        [alert show];
    }
    
    
    if ([[MainModel sharedObject].strUid length]>0) {
        NSString *strUrl2 = [UrlHelper stringUrlCheckUMsg:[MainModel sharedObject].strUid];
        NSURL *query2 = [NSURL URLWithString:strUrl2];
        NSString *umsg = [NSString stringWithContentsOfURL:query2 encoding:NSUTF8StringEncoding error:nil];
        NSArray *msgarr = [umsg componentsSeparatedByString:@"-"];
        //NSArray *msgarr = [NSArray arrayWithObjects:@"3",@"2",@"1", nil];
        /*------------------------------------------jiajingjing--------------------------------------------------*/
        [[MainModel sharedObject] saveMsgNum:[msgarr objectAtIndex:0] secondNum:[msgarr objectAtIndex:1] thirdNum:[msgarr objectAtIndex:2]];
        int totalNum = [[[MainModel sharedObject] getNumByIndex:3] intValue];
        if (totalNum>0) {
            [self.mokaTabBar setBadgeNumer:3 number:totalNum];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadurl]];
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





@end
