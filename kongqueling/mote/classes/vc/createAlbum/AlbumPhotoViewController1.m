//
//  AlbumPhotoViewController1.m
//  mote
//
//  Created by 贾程阳 on 28/2/14.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "AlbumPhotoViewController1.h"

@interface AlbumPhotoViewController1 (){
    NSString *_strUrl;
}


@end

@implementation AlbumPhotoViewController1
@synthesize arrPhoto;
@synthesize dictAlbum;
@synthesize albumModel;
@synthesize photoModel;
@synthesize bigImgScl;
@synthesize iSelectedIndex;
@synthesize currentPic;

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
    
    self.title = @"我的作品";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"moka_picture_edit" selector:@selector(onEditPicture) target:self];
    _strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,self.photoModel.imgPath];
    
    [self initPhotoBrowser];
}

-(void)initPhotoBrowser{

    int kNumberOfPages = [arrPhoto count];
    currentPic = 1;
    
    if(kNumberOfPages>0){
        bigImgScl = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        bigImgScl.pagingEnabled = YES;
        bigImgScl.contentSize = CGSizeMake(bigImgScl.frame.size.width * kNumberOfPages, bigImgScl.frame.size.height);
        bigImgScl.showsHorizontalScrollIndicator = NO;
        bigImgScl.showsVerticalScrollIndicator = NO;
        bigImgScl.alwaysBounceHorizontal = NO;
        bigImgScl.scrollsToTop = NO;
        bigImgScl.bounces = NO;
        bigImgScl.backgroundColor = [UIColor blackColor];
        //bigImgScl.minimumZoomScale = 1.0;
        //bigImgScl.maximumZoomScale = 5.0;
        bigImgScl.delegate = self;
        [self.view addSubview:bigImgScl];
        
        //txtview.hidden = YES;
        //picViewArr = [[NSMutableArray alloc] initWithObjects: nil];
        for (int i=0; i<kNumberOfPages; i++) {
            
            //生成scrollview，把uiimageview放进来
            UIScrollView *subScl = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
            subScl.pagingEnabled = NO;
            subScl.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
            subScl.showsHorizontalScrollIndicator = NO;
            subScl.showsVerticalScrollIndicator = NO;
            subScl.alwaysBounceHorizontal = NO;
            subScl.scrollsToTop = NO;
            subScl.minimumZoomScale = 1.0;
            subScl.maximumZoomScale = 5.0;
            subScl.bounces = NO;
            subScl.tag = 1000+i;
            subScl.delegate = self;
            
//            if (iSelectedIndex>0){
//                [subScl addSubview:[self getImageView:iSelectedIndex]];
//                iSelectedIndex = 0;
//            }else{
//            
//                [subScl addSubview:[self getImageView:i]];
//            }
//            
//            if (i<2) {
//                [subScl addSubview:[self getImageView:i]];
//            }
            
            if (i==iSelectedIndex) {
                [subScl addSubview:[self getImageView:i]];
                [self gotoPic:iSelectedIndex];
            }
            
            [bigImgScl addSubview:subScl];
            
            }
        }
    
}

-(void)onEditPicture{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设为封面",@"分享",@"删除",@"举报",  nil];
    [actionSheet showInView:self.view];
}

- (UIImageView *)getImageView:(int)i{
    
    //生成uiimageview
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.photoModel = [self.arrPhoto objectAtIndex:i];
    _strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,self.photoModel.imgPath];
    [imageview setImageWithURL:[NSURL URLWithString:_strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    imageview.userInteractionEnabled = TRUE;
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    
    return imageview;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.photoModel = [self.arrPhoto objectAtIndex:currentPic-1];
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

- (void)gotoPic:(int)i{
    //currentPic = i;
    [bigImgScl setContentOffset:CGPointMake(self.view.size.width*iSelectedIndex, 0) animated:NO];
}


#pragma mark - UIActionSheetDelegate

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int oldpage = currentPic;
    CGFloat pageWidth = bigImgScl.frame.size.width;
    //currentPic = floor((bigImgScl.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPic = 1;
    if (bigImgScl.contentOffset.x==0){
        currentPic=1;
    }else{
        currentPic = bigImgScl.contentOffset.x/pageWidth+1;
        NSLog(@" bigImgScl.contentOffset.x : %f",bigImgScl.contentOffset.x);
    }
    //currentPic = floor((bigImgScl.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"page:%d",currentPic);
    
    if (currentPic<1) {
        currentPic=1;
    }
    
    if (oldpage!=currentPic) {
        UIScrollView *view = nil;
        NSArray *subviews = [bigImgScl subviews];
        //NSLog(@"sub count:%d",[subviews count]);
        //判读前后是否load
        for (view in subviews)
        {
            if ([view isKindOfClass:[UIScrollView class]]) {
                //NSLog(@"tag:%d curpage:%d",view.tag,currentPic);
                //前一张
                if (currentPic>1 && view.tag-1000+2==currentPic) {
                    if ([[view subviews] count]==0) {
                        [view addSubview:[self getImageView:currentPic-2]];
                        //break;
                    }
                }
                
                //当前一张
                if (currentPic<=[arrPhoto count] && view.tag-1000+1==currentPic) {
                    if ([[view subviews] count]==0) {
                        [view addSubview:[self getImageView:currentPic-1]];
                        //break;
                    }
                }
                
                //后一张
                if (currentPic<=[arrPhoto count] && view.tag-1000==currentPic) {
                    if ([[view subviews] count]==0) {
                        [view addSubview:[self getImageView:currentPic]];
                        //break;
                    }
                }
                
                if ([[view subviews] count]>0 && (view.tag-1000<currentPic-3 || view.tag-1000>currentPic+1)) {
                    [[[view subviews] objectAtIndex:0] removeFromSuperview];
                }
                
            }
        }
    }
    
    if (oldpage!=currentPic) {
        UIScrollView *t = [bigImgScl.subviews objectAtIndex:oldpage-1];
        //if (t.zoomScale!=1.0f) {
        [t setZoomScale:1.0f];
        //}
        
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    /*
     NSLog(@"%d %d",[picViewArr count],currentPic);
     UIImageView *curimgv = [picViewArr objectAtIndex:(currentPic-1)];
     NSLog(@"image:%@",curimgv.image);
     return curimgv;
     */
    UIScrollView *view = nil;
    UIImageView *imgb = nil;
    NSArray *subviews = [bigImgScl subviews];
    for (view in subviews)
	{
        if ([view isKindOfClass:[UIScrollView class]] && view.tag-1000+1==currentPic) {
            if ([[view subviews] count]==0) {
                imgb = [self getImageView:currentPic-1];
            }else {
                imgb = [[view subviews] objectAtIndex:0];
            }
            
        }
        
	}
    return  imgb;
}

#pragma mark - Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    UIScrollView *curscroller = [bigImgScl.subviews objectAtIndex:(currentPic-1)];
    NSLog(@"My view frame: %@",NSStringFromCGRect(bigImgScl.frame));
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [curscroller frame].size.height / scale;
    zoomRect.size.width  = [curscroller frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    NSLog(@"My view frame: %@",NSStringFromCGRect(zoomRect));
    return zoomRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
