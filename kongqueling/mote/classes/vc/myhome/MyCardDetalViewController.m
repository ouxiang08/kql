//
//  MyCardDetalViewController.m
//  mote
//
//  Created by harry on 14-1-23.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "MyCardDetalViewController.h"

@interface MyCardDetalViewController ()

@end

@implementation MyCardDetalViewController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"模卡";
    
    CGRect frame = _imgv.frame;
    frame.size.height = MOKA_SCREEN_HEIGHT;
    _imgv.frame = frame;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"moka_picture_edit" selector:@selector(onEditPicture) target:self];
    [self initMokaResult];
}

-(void)onEditPicture{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"删除", nil];
    [actionSheet showInView:self.view];
}


#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        [self share];
    }else if(buttonIndex == 1){
        [self deletePhoto];
    }
}

-(void)share{
     NSString *strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,[_cardInfo valueForKey:@"imgpath"]];
    NSString *strContent = [NSString stringWithFormat:@"我通过孔雀翎生成了一张模卡：%@，希望能与您合作！#网拍神器孔雀翎#",strUrl];
    id<ISSContent> publishContent = [ShareSDK content:strContent
                                       defaultContent:nil
                                                image:[ShareSDK imageWithUrl:strUrl]
                                                title:@"孔雀翎"
                                                  url:strUrl
                                          description:strContent
                                            mediaType:SSPublishContentMediaTypeNews];
    
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:self];
    
    [ShareSDK showShareActionSheet:container
                         shareList:nil
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
}

-(void)deletePhoto{
    NSString *strUrl = [UrlHelper stringUrlDeleteCard];
    NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
    NSString *cardid = [_cardInfo objectForKey:@"id"];
    [dictParameter setObject:cardid forKey:@"cardid"];
    
    [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
        
        NSLog(@"dictResponse:%@",dictResponse);
        self.maskView.hidden = YES;
        
        [self.navigationController popViewControllerAnimated:YES];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"err:%@",[error localizedDescription]);
    }];
}


-(void)initMokaResult{
    
   
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,[_cardInfo valueForKey:@"imgpath"]];
    [_imageViewMoka setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    
    
    
    //CGFloat width = _imageViewMoka.size.width;
//    CGFloat width = 233;
//    CGFloat height = 320;
//    CGFloat originX = (self.view.frame.size.width - width) /2;
//    CGFloat originY = (self.view.frame.size.height - height) /2;
//    
//    _imageViewMoka.frame = CGRectMake(originX, originY, width, height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
