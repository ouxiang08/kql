//
//  WeixinViewController.m
//  mote
//
//  Created by harry on 13-12-29.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "WeixinViewController.h"

@interface WeixinViewController ()

@end

@implementation WeixinViewController

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
    
    self.title = @"官方微信";
    
    self.view.backgroundColor= MOKA_VIEW_BG_COLOR_BLUE;
    
    UIScrollView *sclMain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, MOKA_SCREEN_HEIGHT)];
    sclMain.contentSize = CGSizeMake(320, 850);
    sclMain.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sclMain];
    
    UIImage *image=[UIImage imageNamed:@"wx_top_bg.jpg"];
    UIImageView *bgImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,image.size.width, image.size.height)];
    bgImageview.image=image;
    [sclMain addSubview:bgImageview];
    
    UILabel *wxLabel=[[UILabel alloc] initWithFrame:CGRectMake(76, 10, 130, 25)];
    wxLabel.backgroundColor=[UIColor clearColor];
    wxLabel.font = [UIFont systemFontOfSize:16];
    wxLabel.text = @"kqlapp";
    [sclMain addSubview:wxLabel];
    
    UIScrollView *sclSub = [[UIScrollView alloc] initWithFrame:CGRectMake(40, 110, 240, 360)];
    sclSub.contentSize = CGSizeMake(720, 360);
    sclSub.backgroundColor = [UIColor clearColor];
    sclSub.pagingEnabled = YES;
    [sclMain addSubview:sclSub];
    
    for (int i=1; i<4; i++) {
        NSString *filename = [NSString stringWithFormat:@"wx_menu%d.png",i];
        
        UIImage *wximage=[UIImage imageNamed:filename];
        UIImageView *wxImageview=[[UIImageView alloc] initWithFrame:CGRectMake((i-1)*240+18, 0,205, 360)];
        wxImageview.image=wximage;
        [sclSub addSubview:wxImageview];
    }
    
    
    UIImage *image2=[UIImage imageNamed:@"wx_bottom_bg.jpg"];
    UIImageView *textImageview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 500,image2.size.width, image2.size.height)];
    textImageview.image=image2;
    textImageview.userInteractionEnabled = YES;
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 1.0;
    [textImageview addGestureRecognizer:longPress];
    
    [sclMain addSubview:textImageview];
    
   
    
    UITextView *txtDesc = [[UITextView alloc] initWithFrame:CGRectMake(15,700,290,85)];
    txtDesc.backgroundColor = [UIColor clearColor];
    txtDesc.dataDetectorTypes = UIDataDetectorTypeAll;
    txtDesc.editable = NO;
    txtDesc.textColor = [UIColor blackColor];
    [txtDesc setFont:[UIFont systemFontOfSize:14]];
    
    txtDesc.text = @"微信号：kqlapp，您也可以通过长按上方的二维码保存图片 > 打开微信的“扫一扫”> 点击“相册选择”> 选中刚才保存的二维码即可关注我们了。";
    txtDesc.scrollEnabled = NO;
    [sclMain addSubview:txtDesc];
}


-  (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [actionSheet showInView:self.view];
    }
    else if (sender.state == UIGestureRecognizerStateBegan){
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
    }
}


#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
        UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"kql_code.png"], nil, nil, nil);
         [[ToastViewAlert defaultCenter] postAlertWithMessage:@"二维码保存成功！"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
