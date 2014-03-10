//
//  WaitingMakingAppViewController.m
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "UpYun.h"
#import "WaitingMakingAppViewController.h"
#import "MakingAppSuccessViewController.h"

@interface WaitingMakingAppViewController (){
    int _iCountUploadSuccess;
    NSString *_strImagePath;
}

@end

@implementation WaitingMakingAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _strImagePath = @"";
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"正在生成APP...";
    
//    CABasicAnimation* rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotationAnimation.delegate = self;
//    rotationAnimation.toValue = [NSNumber numberWithFloat: 2 * M_PI ];
//    rotationAnimation.duration = 0.5;
//    rotationAnimation.repeatCount = 20;
//    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [rotationAnimation setValue:@"rotationAnimation" forKey:@"MyAnimationType"];
//    [_imgvCycle.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self rotate360DegreeWithImageView:self.imgvCycle];
    //[self makingApp];
    
    //临时方案
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    [nav popViewControllerAnimated:NO];
    
    MakingAppSuccessViewController *makingSucccessViewController = [[MakingAppSuccessViewController alloc] init];
    makingSucccessViewController.imgapth = self.strHomePath;
    makingSucccessViewController.apptitle = self.strAppName;
    [nav pushViewController:makingSucccessViewController animated:YES];
    
    /*
    CABasicAnimation* spinAnimation = [CABasicAnimation
                                       animationWithKeyPath:@"transform.rotation"];
    spinAnimation.toValue = [NSNumber numberWithFloat:5*2*M_PI];
    [_imgvCycle.layer addAnimation:spinAnimation forKey:@"spinAnimation"];
     */
}

- (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [CABasicAnimation
                                   animationWithKeyPath: @"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 0.5;
    animation.cumulative = YES;
    animation.repeatCount = 1000;
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}




-(void)makingApp{
    for (int i=0; i<self.arrImage.count; i++) {
        NSString *str = [self.arrImage objectAtIndex:i];
        
        if (i!=self.arrImage.count-1) {
             _strImagePath = [_strImagePath stringByAppendingFormat:@"%@,",str];
        }else{
             _strImagePath = [_strImagePath stringByAppendingFormat:@"%@",str];
        }
    }
    
    dispatch_queue_t aQueue = dispatch_queue_create("MAKEAPP", nil);
    dispatch_async(aQueue, ^{
        NSString *strUrl = [UrlHelper stringUrlSaveAppSetting];
        NSURL *URL = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:100];
        [request setHTTPMethod:@"POST"];
        
        NSString *strRequest = [UrlHelper addCommonParameter:@""];
        strRequest = [NSString stringWithFormat:@"%@&imgs=%@&bgmusicid=%@&appname=%@&homeImg=%@",strRequest,_strImagePath,[self.dictMusic valueForKey:@"id"],self.strAppName,self.strHomePath];
        NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        NSError *error;
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        NSString *strResult = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        
        NSLog(@"err:%@ results:%@",[error localizedDescription],strRequest);
        
        
        if(!error){
            NSDictionary *dictResult = [strResult JSONValue];
            NSInteger errorNo = [[dictResult valueForKey:@"code"] integerValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imgvCycle.layer removeAllAnimations];
                if (errorNo == 1) {
                    UINavigationController *nav = self.navigationController;
                    [nav popViewControllerAnimated:NO];
                    [nav popViewControllerAnimated:NO];
                    [nav popViewControllerAnimated:NO];
                    
                    NSDictionary *appinfo = [dictResult valueForKey:@"appinfo"];
                    
                    MakingAppSuccessViewController *makingSucccessViewController = [[MakingAppSuccessViewController alloc] init];
                    makingSucccessViewController.iosDownloadUrl = [appinfo objectForKey:@"iosDownloadPath"];
                    makingSucccessViewController.allDownloadUrl = [appinfo objectForKey:@"allDownloadPath"];;
                    makingSucccessViewController.imgapth = self.strHomePath;
                    makingSucccessViewController.apptitle = [appinfo objectForKey:@"appname"];;
                    [nav pushViewController:makingSucccessViewController animated:YES];
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[ToastViewAlert defaultCenter] postAlertWithMessage:[dictResult valueForKey:@"msg"]];
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.imgvCycle.layer removeAllAnimations];
                [self.navigationController popViewControllerAnimated:YES];
                [[ToastViewAlert defaultCenter] postAlertWithMessage:@"生成APP失败！"];
            });
        }
    });
    
    
    
    
//    NSMutableDictionary *dictParameters = [NSMutableDictionaryFactory getMutableDictionary];
//    [dictParameters setObject:_strImagePath forKey:@"imgs"];
//    [dictParameters setObject:[self.dictMusic valueForKey:@"id"] forKey:@"bgmusicid"];
//    [dictParameters setObject:self.strAppName forKey:@"appname"];
//    [dictParameters setObject:self.strHomePath forKey:@"homeImg"];
//    
//    [self actionRequestWithUrl:strUrl parameters:dictParameters successBlock:^(NSDictionary *dictResponse) {
//        self.maskView.hidden = YES;
//        NSLog(@"dictResponse:%@",dictResponse);
//        NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
//        
//        if (errorNo == 1) {
//            UINavigationController *nav = self.navigationController;
//            [nav popViewControllerAnimated:NO];
//            [nav popViewControllerAnimated:NO];
//            [nav popViewControllerAnimated:NO];
//            
//            NSDictionary *appinfo = [dictResponse valueForKey:@"appinfo"];
//            
//            MakingAppSuccessViewController *makingSucccessViewController = [[MakingAppSuccessViewController alloc] init];
//            makingSucccessViewController.iosDownloadUrl = [appinfo objectForKey:@"iosDownloadPath"];
//            makingSucccessViewController.allDownloadUrl = [appinfo objectForKey:@"allDownloadPath"];;
//            makingSucccessViewController.imgapth = self.strHomePath;
//            [nav pushViewController:makingSucccessViewController animated:YES];
//        }else{
//             [[ToastViewAlert defaultCenter] postAlertWithMessage:[dictResponse valueForKey:@"msg"]];
//        }
//       
//        
//        NSLog(@"success");
//    } andFailureBlock:^(NSError *error) {
//        self.maskView.hidden = YES;
//        NSLog(@"failed:%@",[error localizedDescription]);
//    }];
//    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
