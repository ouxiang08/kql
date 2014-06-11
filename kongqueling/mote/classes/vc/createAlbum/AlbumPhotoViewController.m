//
//  AlbumPhotoViewController.m
//  mote
//
//  Created by sean on 12/2/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "UIBarButtonItemFactory.h"
#import "AlbumPhotoViewController.h"
#import "AlbumPhotoListViewController.h"

@interface AlbumPhotoViewController ()<UIActionSheetDelegate>{
    NSString *_strUrl;
}

@end

@implementation AlbumPhotoViewController

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
    self.title = @"我的作品";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"moka_picture_edit" selector:@selector(onEditPicture) target:self];
    _strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,self.photoModel.imgPath];
    [self.imageViewPhoto setImageWithURL:[NSURL URLWithString:_strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    // Do any additional setup after loading the view from its nib.
}

-(void)onSwipeLeft{
    if (self.iSelectedIndex<self.arrPhoto.count-1) {
        self.iSelectedIndex++;
        self.photoModel = [self.arrPhoto objectAtIndex:self.iSelectedIndex];
        _strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,self.photoModel.imgPath];
        [self.imageViewPhoto setImageWithURL:[NSURL URLWithString:_strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    }
}

-(void)onSwipeRight{
    if (self.iSelectedIndex>0) {
        self.iSelectedIndex--;
        self.photoModel = [self.arrPhoto objectAtIndex:self.iSelectedIndex];
        _strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,self.photoModel.imgPath];
        [self.imageViewPhoto setImageWithURL:[NSURL URLWithString:_strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    }
}

-(void)onEditPicture{    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设为封面",@"分享",@"删除",@"举报",  nil];
    [actionSheet showInView:self.view];
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        [self setAlbumFirstPage];
    }else if(buttonIndex == 1){
        
        id<ISSContent> publishContent = [ShareSDK content:@"亲，我的新鲜作品出炉，欢迎拍砖哦！#网拍神器孔雀翎#"
                                           defaultContent:nil
                                                    image:[ShareSDK imageWithUrl:_strUrl]
                                                    title:@"孔雀翎"
                                                      url:_strUrl
                                              description:@"亲，我的新鲜作品出炉，欢迎拍砖哦！#网拍神器孔雀翎#"
                                                mediaType:SSPublishContentMediaTypeNews];
        
        id<ISSContainer> container = [ShareSDK container];
        [container setIPhoneContainerWithViewController:self];
        
        //指定要分享的平台
        NSArray *shareList = [ShareSDK getShareListWithType:
                              ShareTypeWeixiSession,
                              ShareTypeWeixiTimeline,
                              ShareTypeSinaWeibo,
                              ShareTypeTencentWeibo,
                              ShareTypeQQ,
                              ShareTypeCopy,
                              nil];
        
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
    }else if(buttonIndex == 2){
        [self deletePhoto];
    }else if(buttonIndex == 3){
        [self reportPhoto];
    }else{
        
    }
}

-(void)reportPhoto{
    NSString *strUrl = [UrlHelper stringUrlReportAlbumPhotos:[NSString stringWithFormat:@"%d",self.photoModel.pid]];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        NSLog(@"dictResponse:%@",dictResponse);
        
        self.maskView.hidden = YES;
        NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
        if (errorNo == 1) {
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"图片举报成功！"];
        }
    } andFailureBlock:^(NSError *error) {
        NSLog(@"err:%@",[error localizedDescription]);
    }];
}

-(void)deletePhoto{
    NSString *strUrl = [UrlHelper stringUrlDeleteAlbumPhotos:[NSString stringWithFormat:@"%d",self.photoModel.pid]];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        NSLog(@"dictResponse:%@",dictResponse);
        self.maskView.hidden = YES;
        
        [self.delegate deletePictureSuccess];
        [self.navigationController popViewControllerAnimated:YES];
//        UINavigationController *nav = self.navigationController;
//        [nav popViewControllerAnimated:YES];
//        [nav popViewControllerAnimated:NO];
//        
//        AlbumPhotoListViewController *photoVC = [[AlbumPhotoListViewController alloc] init];
//        photoVC.model = self.albumModel;
//        [nav pushViewController:photoVC animated:NO];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"err:%@",[error localizedDescription]);
    }];
}

-(void)setAlbumFirstPage{
    NSString *strAlbum = [UrlHelper stringUrlSetAlbum];
    NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
    [dicParameter setObject:[NSNumber numberWithInt:self.albumModel.aid]  forKey:@"aid"];
    [dicParameter setObject:self.photoModel.imgPath  forKey:@"homeImgPath"];
    [dicParameter setObject:self.albumModel.strAlbumName forKey:@"name"];
    [dicParameter setObject:[NSNumber numberWithInt:self.albumModel.iPubFlag] forKey:@"pubflag"];
    self.albumModel.strHomeImgPath = self.photoModel.imgPath;
    
    [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
        if (errorNo == 1) {
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"设置封面成功！"];
        }
    } andFailureBlock:^(NSError *error) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"设置封面失败！"];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
