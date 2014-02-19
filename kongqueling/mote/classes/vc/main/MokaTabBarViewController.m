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

@interface MokaTabBarViewController ()<CustomTabBarDelegate>

@property (nonatomic, strong)CustomTabBar *customTabBar;

@end

@implementation MokaTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        MyArtListViewController *artVC = [[MyArtListViewController alloc] init];
        MyTaskListViewController *taskVC = [[MyTaskListViewController alloc] init];
        MyFinderViewController *finderVC = [[MyFinderViewController alloc] init];
        MyHomeViewController *homeVC = [[MyHomeViewController alloc] init];
        
		
        self.viewControllers = [NSArray arrayWithObjects:
                                artVC,
                                taskVC,
                                finderVC,
								homeVC, nil];
        _customTabBar = [[CustomTabBar alloc] init];
		
        [_customTabBar setImageSelectedArray:@[
                
		 [UIImage imageNamed:@"moka_tabbar_art_selected_bg"],
		 [UIImage imageNamed:@"moka_tabbar_task_selected_bg"],
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - CustomTabBarDelegate
- (BOOL) shouldSelectViewController: (UIViewController *) viewController
{
    return YES;
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    int otheruid = [[[MainModel sharedObject].dictUserInfo valueForKey:@"otheruid"] intValue];
    
    if (otheruid>0 && ([selectedViewController isKindOfClass:[MyFinderViewController class]] || [selectedViewController isKindOfClass:[MyTaskListViewController class]])) {
        //[[ToastViewAlert defaultCenter] postAlertWithMessage:@"对不起，您没有改模块的权限"];
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
    
    if (otheruid>0 && (selectedIndex==1||selectedIndex==2)) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"对不起，您没有该模块的权限"];
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

@end
