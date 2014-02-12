//
//  CustomTabBar.h
//  wccqr
//
//  Created by 超 张 on 12-6-13.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomTabBarDelegate <NSObject>

@optional
- (BOOL) shouldSelectViewController: (UIViewController *) viewController;

@required
- (void) touchDownAtItemAtIndex: (NSUInteger) itemIndex;

@end

@interface CustomTabBar : NSObject{
    
    NSArray *m_arrayImageSelected;
    NSArray *m_arrayViewControllers;
    
@public
    NSMutableArray *m_arrayButtons;
    
}


@property(nonatomic, unsafe_unretained)id<CustomTabBarDelegate> delegate;

- (void) selectTabBarItem: (int) index;
- (void) setImageSelectedArray:(NSArray *)imageArray;

- (UIView*) customTabBarViewWithItems:(NSArray *) arrayViewControllers selecedIndex: (NSInteger)indexSelected andDelegate: (id<CustomTabBarDelegate>) theDelegate;

- (void) didSelectViewController: (UIViewController *) viewController;


@end
