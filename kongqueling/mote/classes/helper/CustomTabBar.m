//
//  CustomTabBar.m
//  wccqr
//
//  Created by 超 张 on 12-6-13.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar()
- (void) buttonDown: (id) sender;
@end

@implementation CustomTabBar
@synthesize delegate = _delegate;
- (id) init
{
    self = [super init];
    if ( self ) {
        m_arrayImageSelected = [[NSArray alloc] init];
        m_arrayButtons = [NSMutableArray arrayWithCapacity: 10];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(msgNumChange) name:kMessageDidChangeNofication object:nil];
    }
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (UIView*) customTabBarViewWithItems:(NSArray *) arrayViewControllers selecedIndex: (NSInteger)indexSelected andDelegate: (id<CustomTabBarDelegate>) theDelegate
{
    m_arrayBages = [[NSMutableArray alloc] initWithObjects: nil];

    
    /*----------------------------------------jiajingjing--------------------------------------------*/
    UIView *viewTabBar = [[UIView alloc] initWithFrame: CGRectMake(0, -2, 320, 51)];
    UIImage *image = [UIImage imageNamed:@"tabbar_background"];
    image = [image stretchableImageWithLeftCapWidth:image.leftCapWidth topCapHeight:image.topCapHeight];
    UIImageView *tabbarGroundImage = [[UIImageView alloc] initWithImage:image];
    tabbarGroundImage.frame = viewTabBar.bounds;
    [viewTabBar addSubview:tabbarGroundImage];
    
    self.delegate = theDelegate;
    
    int iItemCount = [arrayViewControllers count];
    CGFloat horizontalOffset = 0;

    m_arrayViewControllers = arrayViewControllers;
    
    for ( NSInteger i = 0; i < iItemCount; i++ ) {
        NSInteger width = viewTabBar.frame.size.width / iItemCount;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0.0, 0.0, width, viewTabBar.frame.size.height);
        
        UIViewController *viewController = (UIViewController *)[arrayViewControllers objectAtIndex: i];
        UIImage *imageButton = viewController.tabBarItem.image;
        UIImage *imageSelected = [m_arrayImageSelected objectAtIndex: i];
        
        [button setImage: imageButton forState: UIControlStateNormal];
        [button setImage: imageSelected forState: UIControlStateHighlighted];
        [button setImage: imageSelected forState: UIControlStateSelected];
        [button setImage: imageSelected forState: UIControlStateHighlighted | UIControlStateSelected];
        button.accessibilityLabel = viewController.tabBarItem.title ; 
        
        button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
        
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonDown:) forControlEvents: UIControlEventTouchDown];
        
        if ( i == indexSelected ) {
            button.selected = YES;
        }
        
        [viewTabBar addSubview: button];
        [m_arrayButtons addObject: button];

        horizontalOffset = horizontalOffset + width;
        
        UIImageView* badge = [[UIImageView alloc] initWithFrame:CGRectMake(horizontalOffset-35, 3, 20, 20)];
        badge.image = [UIImage imageNamed:@"badge.png"];
        badge.hidden = YES;
        [viewTabBar addSubview: badge];
        [m_arrayBages addObject: badge];
    }
    
    return viewTabBar;
}

- (void) buttonDown: (id) sender
{
    UIButton *button = (UIButton *) sender;
    int index = button.tag -1;
    
    if ( self.delegate && [self.delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)]) {
        [self.delegate touchDownAtItemAtIndex: index];
    }
        
    if ( self.delegate && [self.delegate respondsToSelector: @selector(shouldSelectViewController:)] ) {
        UIViewController *viewController;
        if ( index < [m_arrayViewControllers count] ) {
            viewController = (UIViewController *)[m_arrayViewControllers objectAtIndex: index];
        }
        
        if ( viewController ) {
            if ( [self.delegate shouldSelectViewController: viewController] ) {
                
                for (UIButton *buttonItem in m_arrayButtons) {
                    buttonItem.selected = NO;
                }
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                
                button.selected = YES;
                [UIView commitAnimations];
            }
        }
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        button.selected = YES;
        [UIView commitAnimations];
    }

}

//- (BOOL) shouldSelectViewController: (UIViewController *) viewController
//{
//    return YES;
//}

- (void) didSelectViewController: (UIViewController *) viewController
{
    NSInteger index = [m_arrayViewControllers indexOfObject: viewController];
    
    if ( index != NSNotFound ) {
        for (UIButton *buttonItem in m_arrayButtons) {
            
            if ( index == buttonItem.tag - 1 ) {
                buttonItem.selected = YES;
            } else {
                buttonItem.selected = NO;
             }
        }
    }
}

- (void) didSelectItemAtIndex:(int)index
{
    for (UIButton *buttonItem in m_arrayButtons) {
        if ( index == buttonItem.tag - 1 ) {
            buttonItem.selected = YES;
        } else {
            buttonItem.selected = NO;
        }
    }
}

- (void) selectTabBarItem: (int) index
{
    if ( m_arrayButtons.count ) {
        for (UIButton *buttonItem in m_arrayButtons) {
            buttonItem.selected = NO;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        
        UIButton *buttonBarItem = (UIButton *)[m_arrayButtons objectAtIndex: index];
        buttonBarItem.selected = YES;
        [UIView commitAnimations];
    }
    /*------------------------------------------jiajingjing--------------------------------------------------*/
    UIImageView *imgv = [m_arrayBages objectAtIndex:index];
    int totalNum = [[[MainModel sharedObject] getNumByIndex:3] integerValue];
    if (index==3&&totalNum>0) {
        imgv.hidden = NO;
    }else{
        imgv.hidden = YES;

    }
}

- (void)setImageSelectedArray:(NSArray *)imageArray
{
    m_arrayImageSelected = imageArray;
}

- (void)setBadgeNumer:(int)index number:(int)numer
{
    /*------------------------------------------jiajingjing--------------------------------------------------*/
    UIImageView *imgv = [m_arrayBages objectAtIndex:index];
    int totalNum = [[[MainModel sharedObject] getNumByIndex:3] integerValue];
    if (totalNum>0) {
        UILabel *badgeLabel = [[UILabel alloc]initWithFrame:imgv.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeLabel.text = [NSString stringWithFormat:@"%d",totalNum];
        [imgv addSubview:badgeLabel];
        imgv.hidden = NO;
    }else{
        imgv.hidden = YES;
    }
}

- (void)msgNumChange{
    
    NSLog(@"msgNmuChange");
    /*------------------------------------------jiajingjing--------------------------------------------------*/
    UIImageView *imgv = [m_arrayBages objectAtIndex:3];
    int totalNum = [[[MainModel sharedObject] getNumByIndex:3] integerValue];
    UILabel *badgeLabel = (UILabel *)[imgv subviews][0];
    if (totalNum>0) {
        badgeLabel.text = [NSString stringWithFormat:@"%d",totalNum];
        imgv.hidden = NO;
    }else{
    
        imgv.hidden = YES;
    }
}


@end
