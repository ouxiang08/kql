//
//  WCCNavigationController.m
//  wochacha
//
//  Created by dream liu on 12-7-19.
//  Copyright (c) 2012年 wochacha. All rights reserved.
//

#import "WCCNavigationController.h"
#import <mach/mach_time.h>
#import "UIImage+Additions.h"
#import "UIColor+Additions.h"

static inline uint64_t timer_now ()
{
    return(mach_absolute_time());
}

static inline double timer_elapsed (uint64_t start, uint64_t end)
{
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    return((double)(end - start) * info.numer / (info.denom * 1000000000.));
}

@interface WCCNavigationController ()
{
    id<UINavigationControllerDelegate> _selfDelegate;
}

@property(nonatomic, strong) NSMutableArray *stack;
@property(nonatomic, assign) BOOL bAnimating;
@property(nonatomic, assign) uint64_t iLastTime;

- (void) runNextBlock;

@end

@implementation WCCNavigationController
@synthesize stack = _stack;
@synthesize bAnimating = _bAnimating;
@synthesize iLastTime = _iLastTime;

#pragma mark - setter
- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    if (delegate == self) {
        [super setDelegate:self];
    }else{
        _selfDelegate = delegate;
    }
}


#pragma mark - inside methods

- (void)runNextBlock
{
    if (self.stack.count == 0) {
        return;
    }
    void (^codeBlock)(void) = [self.stack objectAtIndex:0];
    codeBlock();
    [self.stack removeObjectAtIndex:0];
}

#pragma mark - life cycle
- (NSMutableArray *)stack
{
    if (!_stack) {
        _stack = [[NSMutableArray alloc] init];
    }
    return _stack;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
        self.iLastTime = 0;
    }
    return self;
}

- (void)dealloc
{
#if WCC_MEM_CHECK
    NSLog(@"[%@ dealloc]",[self class]);
#endif
    [self.stack removeAllObjects];
    self.stack = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customAppearance];
}

- (void)customAppearance
{
    // TODO-Alen move to somewhere better
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ([UINavigationBar respondsToSelector:@selector(appearance)]) {
            [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"home_navigation_bar_bg.png"] forBarMetrics:UIBarMetricsDefault];
        }
        if ([UIBarButtonItem respondsToSelector:@selector(appearance)]) {
            id appearance = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//            UIImage* normalImage = [[UIImage imageNamed:@"nav_bar_button_bg_normal.png"] resizableImageWithOffsetTop:6.0f left:6.0f bottom:6.0f right:6.0f];
//            [appearance setBackgroundImage:normalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//            
//            UIImage* highlightedImage = [[UIImage imageNamed:@"nav_bar_button_bg_normal.png"] resizableImageWithOffsetTop:6.0f left:6.0f bottom:6.0f right:6.0f];
//            [appearance setBackgroundImage:highlightedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
            
//            UIImage* backNormalImage = [[UIImage imageNamed:@"nav_bar_button_back_bg_normal.png"] resizableImageWithOffsetTop:5.0f left:15.0f bottom:5.0f right:5.0f];
//            //UIImage* backHighlightedImage = [[UIImage imageNamed:@"nav_bar_button_back_bg_highlighted.png"] resizableImageWithOffsetTop:5.0f left:15.0f bottom:5.0f right:5.0f];
//            UIImage* backHighlightedImage = [[UIImage imageNamed:@"nav_bar_button_back_bg_normal.png"] resizableImageWithOffsetTop:5.0f left:15.0f bottom:5.0f right:5.0f];
//            [appearance setBackButtonBackgroundImage:backNormalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//            [appearance setBackButtonBackgroundImage:backHighlightedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        }
    });
    
    // iOS 4.x, NOT support customizing appearance
    self.navigationBar.tintColor = [UIColor colorWithIntRed:32 intGreen:141 intBlue:188 alpha:1.0];
}

//override push & pop method with synchronization
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    @synchronized(self.stack){
        if (self.bAnimating) {
            void (^codeBlock)(void) = ^{
                [super popViewControllerAnimated:animated];
            };
            [self.stack addObject:codeBlock];
            return nil;
        }
        else {
           // UIViewController *topVC = self.topViewController;
//            if ([topVC isKindOfClass:[WCCNetworkController class]]) {
//                [(WCCNetworkController *)topVC cancelRequest];
//            }
            return [super popViewControllerAnimated:animated];
        }
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @synchronized(self.stack){
        uint64_t timeNow = timer_now();
        double timeElapsed = timer_elapsed(self.iLastTime, timeNow);
        self.iLastTime = timeNow;
        UIViewController *topVC = self.topViewController;
        if (timeElapsed < 0.25f && [viewController isKindOfClass:[topVC class]]) {//fixed bug 3498
            return;
        }else{
            if (self.bAnimating) {
                void (^codeBlock)(void) = ^{
                    [super pushViewController:viewController animated:animated];
                };
                [self.stack addObject:[codeBlock copy]];//Important: To put a Block into a Collection, it must first be copied
            }else {
                [super pushViewController:viewController animated:animated];
            }
        }
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_1
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#endif

#pragma mark - UINavigationDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @synchronized(self.stack){
        if (_selfDelegate && [_selfDelegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
            [_selfDelegate navigationController:navigationController willShowViewController:viewController animated:YES];
        }
        self.bAnimating = TRUE;
        //fix bug 3481
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){//set the bAnimating property to False after 0.5 seconds because didShowViewController wouldn't be called in some case
            self.bAnimating = FALSE;
        });
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    @synchronized(self.stack){
        if (_selfDelegate && [_selfDelegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
            [_selfDelegate navigationController:navigationController didShowViewController:viewController animated:YES];
        }
        self.bAnimating = false;
        [self runNextBlock];
    }
}

@end
