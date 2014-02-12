//
//  MokaNetworkController.m
//  wochacha
//
//  Created by liang zou on 13-11-21
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"
#import "AFNetworking.h"
#import "NSObject+SBJson.h"


@interface MokaNetworkController ()

@property(nonatomic, strong)AFHTTPRequestOperation *requestOperation;
@property(nonatomic, assign)BOOL bActionRequst;

- (void)getDataWithURL:(NSString *)strURL parameters:(NSDictionary *)parameters;
- (void)dealWithSuccessRequest:(NSURLRequest *)request withResponse:(NSHTTPURLResponse *)response andResult:(id) json;
- (void)dealWithFailurRequest:(NSURLRequest *)request withResponse:(NSHTTPURLResponse *)response andError:(NSError *)error;

@end

@implementation MokaNetworkController
@synthesize requestOperation = _requestOperation;
@synthesize bActionRequst = _bActionRequst;
@synthesize maskView = _maskView;
@synthesize fMaskAlpha = _fMaskAlpha;

#pragma mark - inside method

- (void)getDataWithURL:(NSString *)strURL parameters:(NSDictionary *)parameters
{
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:KHomeUrlDefault]];
    NSMutableURLRequest *request = nil;
    if (parameters) {
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        request = [httpClient requestWithMethod:@"POST" path:strURL parameters:parameters];
    }else{
        request = [httpClient requestWithMethod:@"GET" path:strURL parameters:nil];
    }
    [request setTimeoutInterval:kTimeOutDefault];
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        //request success,shouldn't use weak self
        [self dealWithSuccessRequest:request withResponse:response andResult:JSON];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        //request failure
        [self dealWithFailurRequest:request withResponse:response andError:error];
    }];
    self.requestOperation = operation;
    [operation start];
}
- (void)dealWithSuccessRequest:(NSURLRequest *)request withResponse:(NSHTTPURLResponse *)response andResult:(id)json
{
    //TODO:deal with the commen success information here
    if (response.statusCode <400) {
#if NS_BLOCKS_AVAILABLE
        if (self.successBlock) {
            self.successBlock(json);
            self.successBlock = nil;//break retain cycle
            self.failureBlock = nil;//break retain cycle
        }
#endif
        [_indicatorView stopAnimating];
        if (!self.bActionRequst) {
            [self responseReturnSuccess:json];
        }
    }else{
#if NS_BLOCKS_AVAILABLE
        if (self.failureBlock) {
            self.failureBlock(nil);
            self.failureBlock = nil;//break retain cycle
            self.successBlock = nil;//break retain cycle
        }
#endif
        [_indicatorView stopAnimating];
        [self showMessage:NSLocalizedString(@"服务器响应失败\n请稍后重试", nil)];
        if (!self.bActionRequst) {
            [self responseReturnFailure:nil];
        }
    }
}

- (void)dealWithFailurRequest:(NSURLRequest *)request withResponse:(NSHTTPURLResponse *)response andError:(NSError *)error
{
    //TODO:deal with the commen failure information here
#if NS_BLOCKS_AVAILABLE
    if (self.failureBlock) {
        self.failureBlock(error);
        self.failureBlock = nil;
        self.successBlock = nil;
    }
#endif
    [_indicatorView stopAnimating];
    [self showMessage:NSLocalizedString(@"网络请求失败\n请稍后重试", nil)];
    if (!self.bActionRequst) {
        [self responseReturnFailure:error];
    }
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_maskView setBackgroundColor:[UIColor whiteColor]];
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = _maskView.center;
        [_maskView addSubview:_indicatorView];
    }
    return _maskView;
}

- (void)setFMaskAlpha:(CGFloat)fMaskAlpha
{
    _fMaskAlpha = fMaskAlpha;
    [self.maskView setAlpha:_fMaskAlpha];
}



#pragma mark - life cycle
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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self cancelRequest];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
    UIViewController *presentedViewController;
    
    presentedViewController = self.presentedViewController;
    
    if (!presentedViewController) {//dismiss by self
        [self cancelRequest];
    }else if ( [presentedViewController isKindOfClass:[MokaNetworkController class]]) {//dismiss by presenting View controller without navigation controller
        [(MokaNetworkController *)presentedViewController cancelRequest];
    }
    else if ( [presentedViewController isKindOfClass:[UINavigationController class]]){//present with navigation controller
        UIViewController *topVC =[(UINavigationController *)presentedViewController topViewController];
        if ([topVC isKindOfClass:[MokaNetworkController class]]) {
            [(MokaNetworkController *)topVC cancelRequest];
        }
    }
}
#pragma mark - public methods
- (void)requestDataWithUrl:(NSString *)url
{
    if (self.maskView.superview != self.view) {
        [self.view addSubview:self.maskView];
    }
    [self.view bringSubviewToFront:self.maskView];
    [self.indicatorView startAnimating];
    self.bActionRequst = NO;
    
    [self getDataWithURL:url parameters:nil];
}

#if NS_BLOCKS_AVAILABLE
- (void)requestDataWithUrl:(NSString *)url successBlock:(NWSuccessBlock)success andFailureBlock:(NWFailureBlock)failure
{
    if (self.maskView.superview != self.view) {
        [self.view addSubview:self.maskView];
    }
    [self.view bringSubviewToFront:self.maskView];
    [self.indicatorView startAnimating];
    
    self.bActionRequst = NO;
    
    self.successBlock = success;
    self.failureBlock = failure;
    [self getDataWithURL:url parameters:nil];
}
#endif

- (void)responseReturnSuccess:(NSDictionary *)dictResponse
{
    
}

- (void)responseReturnFailure:(NSError *)error
{
    
}

#if NS_BLOCKS_AVAILABLE
- (void)actionRequestWithUrl:(NSString *)url parameters:(NSDictionary *)parameters successBlock:(NWSuccessBlock)success andFailureBlock:(NWFailureBlock)failure
{
    self.bActionRequst = YES;
    
    if (self.maskView.superview != self.view) {
        [self.view addSubview:self.maskView];
    }
    [self.view bringSubviewToFront:self.maskView];
    [self.indicatorView startAnimating];
   
    self.successBlock = success;
    self.failureBlock = failure;
    [self getDataWithURL:url parameters:parameters];
}
#endif


- (void)cancelRequest
{
    self.successBlock = nil;//break retain cycle
    self.failureBlock = nil;//break retain cycle
    [self.requestOperation cancel];
}

- (void)showMessage:(NSString *)msg
{
    //[ToastViewAlert defaultCenter] postAlertWithMessage:msg];
}
@end
