//
//  MokaNetworkController.h
//  wochacha
//
//  Created by liang zou on 13-11-21.
//  Copyright (c) 2013年 zlm. All rights reserved.


#import <UIKit/UIKit.h>

//#define kHomeDefaultUrl @"http://www.zouliangming.com"
#define kTimeOutDefault 20

#if NS_BLOCKS_AVAILABLE
    typedef void (^NWSuccessBlock)(NSDictionary *dictResponse);
    typedef void (^NWFailureBlock)(NSError *error);
#endif

@interface MokaNetworkController : UIViewController

@property(copy) NWSuccessBlock successBlock;
@property(copy) NWFailureBlock failureBlock;

@property(nonatomic, strong) UIView *maskView;
@property(nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property(nonatomic, assign) CGFloat fMaskAlpha;

- (void)requestDataWithUrl:(NSString *)url;
#if NS_BLOCKS_AVAILABLE
- (void)requestDataWithUrl:(NSString *)url successBlock:(NWSuccessBlock)success andFailureBlock:(NWFailureBlock)failure;
#endif
- (void)responseReturnSuccess:(NSDictionary *)dictResponse;
- (void)responseReturnFailure:(NSError *)error;
//action request
#if NS_BLOCKS_AVAILABLE
- (void)actionRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(NWSuccessBlock)success andFailureBlock:(NWFailureBlock)failure;
#endif

- (void)cancelRequest;
- (void)showMessage:(NSString *)msg;
@end
