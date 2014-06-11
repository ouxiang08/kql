//
//  MokaTabBarViewController.m
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaTabBarViewController.h"
#import "MyArtListViewController.h"
#import "MyTaskListViewController.h"
#import "MyFinderViewController.h"
#import "MyHomeViewController.h"
#import "SquareViewController.h"
#import "StartPageViewController.h"

@interface MokaTabBarViewController ()<CustomTabBarDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)CustomTabBar *customTabBar;

@end

@implementation MokaTabBarViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:kLoginNofication object:nil];
        // Custom initialization
        SquareViewController *piazzaVC = [[SquareViewController alloc] init];
        MyArtListViewController *artVC = [[MyArtListViewController alloc] init];
        //MyTaskListViewController *taskVC = [[MyTaskListViewController alloc] init];
        MyFinderViewController *finderVC = [[MyFinderViewController alloc] init];
        MyHomeViewController *homeVC = [[MyHomeViewController alloc] init];
        
		
        self.viewControllers = [NSArray arrayWithObjects:
                                piazzaVC,
                                artVC,
                                finderVC,
								homeVC, nil];
        _customTabBar = [[CustomTabBar alloc] init];
		
        [_customTabBar setImageSelectedArray:@[
                
		 [UIImage imageNamed:@"moka_tabbar_piazza_selected_bg"],
		 [UIImage imageNamed:@"moka_tabbar_art_selected_bg"],
		 [UIImage imageNamed:@"moka_tabbar_search_selected_bg"],
		 [UIImage imageNamed:@"moka_tabbar_home_selected_bg"]
         ]];
		
		[self setSelectedIndex:0];
		UIView *tabBarView = [_customTabBar customTabBarViewWithItems: self.viewControllers selecedIndex: self.selectedIndex andDelegate:self];
        [self.tabBar addSubview: tabBarView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的作品";
     
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:kLoginNofication];
}

#pragma mark - CustomTabBarDelegate
- (BOOL) shouldSelectViewController: (UIViewController *) viewController
{
    return YES;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    int otheruid = [[[MainModel sharedObject].dictUserInfo valueForKey:@"otheruid"] intValue];
    
    NSString *strUrl = [UrlHelper stringUrlCheckUid:[MainModel sharedObject].strUid];
    NSURL *query = [NSURL URLWithString:strUrl];
    NSString *uid = [NSString stringWithContentsOfURL:query encoding:NSUTF8StringEncoding error:nil];
    
    if (![uid isEqualToString:@"1"]&&([selectedViewController isKindOfClass:[MyHomeViewController class]] || [selectedViewController isKindOfClass:[MyArtListViewController class]])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能需要登录后才能使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.delegate = self;
        alertView.tag = 4;
        [alertView show];
        
    }else{
        self.navigationItem.title = selectedViewController.navigationItem.title;
        self.navigationItem.titleView = selectedViewController.navigationItem.titleView;
        self.navigationItem.rightBarButtonItem = selectedViewController.navigationItem.rightBarButtonItem;
        self.navigationItem.leftBarButtonItem = selectedViewController.navigationItem.leftBarButtonItem;
        [super setSelectedViewController:selectedViewController];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    int otheruid = [[[MainModel sharedObject].dictUserInfo valueForKey:@"otheruid"] intValue];
    
    if ((selectedIndex==1||selectedIndex==3)) {
        //[[ToastViewAlert defaultCenter] postAlertWithMessage:@"您的账户没有此权限"];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能需要登录后才能使用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        alertView.delegate = self;
//        alertView.tag = 4;
//        [alertView show];
    }else{
        [super setSelectedIndex:selectedIndex];
       // [self updateNavigationItem];
        [self.customTabBar selectTabBarItem: selectedIndex];
        //[self customTabBarSelectedAtIndex: selectedIndex];
    }
}

- (void)touchDownAtItemAtIndex:(NSUInteger)itemIndex
{
    UIViewController *viewController = [self.viewControllers objectAtIndex: itemIndex];
    self.selectedIndex = itemIndex;
	
    [self setSelectedViewController: viewController];
}

- (void) setBadgeNumer:(int)index number:(int)numer{
    [self.customTabBar setBadgeNumer:index number:numer];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1&&alertView.tag == 4) {
        [self login];
    }
}

- (void)login{

    StartPageViewController *rsVC = [[StartPageViewController alloc] init];
    UINavigationController *navStart = [[WCCNavigationController alloc] initWithRootViewController:rsVC];
    NSMutableDictionary *navBarTextAttributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [navBarTextAttributes setObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    navStart.navigationBar.titleTextAttributes = navBarTextAttributes;
    
    [self presentViewController:navStart animated:NO completion:^(void){}];
}

@end
