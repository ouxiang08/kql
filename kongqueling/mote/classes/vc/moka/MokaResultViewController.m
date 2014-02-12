//
//  MokaResultViewController.m
//  mote
//
//  Created by sean on 11/11/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "UpYun.h"
#import "MokaResultViewController.h"
#import "SavingAndSharingViewController.h"

@interface MokaResultViewController (){
     MokaIndicatorView *_mokaIndicator;
}

@end

@implementation MokaResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
     _mokaIndicator = [[MokaIndicatorView alloc] initWithFrame:KScreenBounds];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"生成模卡";
   
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"保存/分享" selector:@selector(onSaveShare) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self initMokaResult];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)initMokaResult{
    
    CGFloat width = self.imageMoka.size.width;
    CGFloat height = self.imageMoka.size.height;
    CGFloat originX = (self.view.frame.size.width - width) /2;
    CGFloat originY = (self.view.frame.size.height - height) /2;
    
    _container = [[UIView alloc] initWithFrame:CGRectMake(originX, originY, width, height)];
    
    UIImageView *mokav = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    mokav.image = self.imageMoka;
    [_container addSubview:mokav];
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, height-20, width, 21)];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = [UIFont systemFontOfSize:12];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.text = self.strNameAndHeight;
    [_container addSubview:lbl];
    
    [self.view addSubview:_container];
}

-(void)onSaveShare{
    
    
    UIGraphicsBeginImageContextWithOptions(_container.frame.size,NO,0);
    [_container.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
//    
//    //UIGraphicsBeginImageContext(self.view.frame.size);
//    UIGraphicsBeginImageContextWithOptions(self.view.frame.size,NO,0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage*parentImage=UIGraphicsGetImageFromCurrentImageContext();
//    
//    CGImageRef imageRef = parentImage.CGImage;
//    CGRect myImageRect=self.imageViewMokaResult.frame;
//    NSLog(@"%@",NSStringFromCGRect(myImageRect));
//    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
//    
//    CGSize size=self.imageViewMokaResult.frame.size;
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, myImageRect, subImageRef);
//    
//    UIImage* image = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
//    
//    
//    CGImageRelease(imageRef);
//    UIGraphicsEndImageContext();
    
    
    
    /*
    UIGraphicsBeginImageContext(self.imageViewMokaResult.frame.size);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*parentImage=UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef = parentImage.CGImage;
    CGRect myImageRect=CGRectMake(0, self.imageViewMokaResult.frame.origin.y, self.imageViewMokaResult.frame.size.width, self.imageViewMokaResult.frame.size.height);
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    
    CGSize size=self.imageViewMokaResult.frame.size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    
    UIImage* image = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    
    CGImageRelease(imageRef);
    UIGraphicsEndImageContext();
    */
    UIImageWriteToSavedPhotosAlbum(viewImage, self, NULL, NULL);
    [self uploadMokaImageToUpYun:viewImage];
}

-(void)uploadMokaImageToUpYun:(UIImage *)image{
    UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(id data)
    {
        _mokaIndicator.labelHint.text =@"";
        [self saveMokaRequest:[data valueForKey:@"url"]];
    };
    uy.failBlocker = ^(NSError * error)
    {
        [_mokaIndicator stop];
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"上传照片失败，请重新上传！"];
    };
    
    [uy uploadFile:image saveKey:[self getSaveKey]];

}

-(NSString * )getSaveKey {
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%@/%d%d%d/%.0f.jpg",[MainModel sharedObject].strUid,[self getYear:d],[self getMonth:d],[self getDay:d],[[NSDate date] timeIntervalSince1970]];
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year];
    return year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    return month;
}

- (int)getDay:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps day];
    return month;
}

-(void)saveMokaRequest:(NSString *)strImageUrl{
    NSString *strUrl = [UrlHelper stringUrlSaveCard];
    NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
    [dictParameter setObject:strImageUrl forKey:@"imgpath"];
    
    [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
        [_mokaIndicator stop];
        UINavigationController *nav = self.navigationController;
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
        
        SavingAndSharingViewController *saveShareViewController = [[SavingAndSharingViewController alloc] init];
        [nav pushViewController:saveShareViewController animated:YES];
    } andFailureBlock:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
