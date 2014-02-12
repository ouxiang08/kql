//
//  HeadViewController.m
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "HeadViewController.h"
#import "UIImage+Additions.h"

@interface HeadViewController (){
    MokaIndicatorView *_mokaIndicator;
}

@end

@implementation HeadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _mokaIndicator = [[MokaIndicatorView alloc] initWithFrame:KScreenBounds];
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
     //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    if (isfinish==YES) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete-0.png" selector:@selector(finishInformation) target:self];
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
}

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr{
    messArray=MessageArr;
    return self;
    
}



- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"上传头像(3/3)";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete-0.png" selector:@selector(finishInformation) target:self];
    self.navigationItem.rightBarButtonItem.enabled = NO;
	self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    imagStr = @"";
    
    UIImageView *headbackImage=[[UIImageView alloc] initWithFrame:CGRectMake(80, 70, 160, 160)];
    headbackImage.image=[UIImage imageNamed:@"7777777_10.png"];
    headbackImage.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:headbackImage];
    headImage=[[UIImageView alloc] initWithFrame:CGRectMake(80, 70, 160, 160)];
    //headImage.image=[UIImage imageNamed:@"people.png"];
    headImage.contentMode = KimageShowMode;
    [headImage setClipsToBounds:YES];
    [self.view addSubview:headImage];
    
    UIButton *headbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    headbtn.frame=CGRectMake(80, 70, 160, 160);
    [headbtn addTarget:self action:@selector(openThePhotoAndCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headbtn];
    
    UIButton *upyunbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    upyunbtn.frame=CGRectMake(45,240, 230, 38);
    [upyunbtn setBackgroundImage:[UIImage imageNamed:@"7777777_13.png"] forState:UIControlStateNormal];
    [upyunbtn addTarget:self action:@selector(updateTheHeadImageToUpYun) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upyunbtn];


    isfinish=NO;

}


-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)finishInformation{
    //if ([imagStr isEqualToString:@""]){
   // imagStr=@"无";
    [messArray addObject:imagStr];
//    }
//    if ([messArray count]<9) {
//      [messArray addObject:imgdata];
//    }
//    else{
//        [messArray removeObjectAtIndex:[messArray count]-1];
//        [messArray addObject:imgdata];
//    }
    NSLog(@"-----%d",[messArray count]);
    NSString *phoneStr=[messArray objectAtIndex:0];
    NSString *invitStr=[messArray objectAtIndex:1];

    NSString *nickStr=[messArray objectAtIndex:7];
    NSString *imgidStr=[messArray objectAtIndex:8];
    NSString *passStr=[messArray objectAtIndex:2];
    NSString *genderStr=[messArray objectAtIndex:4];
    NSString *jobcatStr=[messArray objectAtIndex:3];
    NSString *subjobStr=[messArray objectAtIndex:6];
    NSString *locationStr=[messArray objectAtIndex:5];
    
    NSLog(@"phoneStr is %@",phoneStr);
    NSLog(@"invitStr is %@",invitStr);
    NSLog(@"passStr is %@",passStr);
    NSLog(@"genderStr is %@",genderStr);
    NSLog(@"jobcatStr is %@",jobcatStr);
    NSLog(@"locationStr is %@",locationStr);
    NSLog(@"subjobStr is %@",subjobStr);
    NSLog(@"nickStr is %@",nickStr);
    NSLog(@"imgidStr is %@",imgidStr);
    
    //第一步，创建URL
    NSString *requsturl = [NSString stringWithFormat:@"%@/reg",KHomeUrlDefault];
    NSURL *url = [NSURL URLWithString:requsturl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"key=usersubtype,nickname,imgpath&value=%@,%@,%@&uid=%@",subjobStr,nickStr,imgidStr,[MainModel sharedObject].strUid];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    SBJSON *parsermsg = [[SBJSON alloc] init];
    NSDictionary *roDic = [parsermsg objectWithString:jsonStr error:&error];
    NSLog(@"roDic is %@",roDic);
    NSString *resultstr=[roDic valueForKey:@"msg"];
    NSLog(@"resultstr is %@",resultstr);
    NSString *code=[roDic valueForKey:@"code"];
    //if ([code isEqualToString:@"1"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"恭喜你，注册成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    //}
    
}

-(void)openThePhotoAndCamera{
    UIActionSheet *actiontxt = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"我要再想想" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"手机相册",nil];
    actiontxt.tag = 1001;
    [actiontxt setActionSheetStyle:UIActionSheetStyleDefault];
    [actiontxt showInView:self.view];
    

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)updateTheHeadImageToUpYun{
   
    if (headImage.image==nil) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"你未选择图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    else{
        UpYun *uy = [[UpYun alloc] init];
         [_mokaIndicator start];
        /**
         *	@brief	根据 UIImage 上传
         */
        imagStr = [self getSaveKey];
        [uy uploadFile:headImage.image saveKey:imagStr];
        uy.successBlocker = ^(id data){
            [_mokaIndicator stop];
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            NSLog(@"%@",data);
        };
        uy.failBlocker = ^(NSError * error){
            [_mokaIndicator stop];
            imagStr = @"";
            //NSString *message = [error.userInfo objectForKey:@"message"];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            NSLog(@"%@",error);
        };
    
    /**
     *	@brief	根据 文件路径 上传
     */
    //    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    //    NSString* filePath = [resourcePath stringByAppendingPathComponent:@"fileTest.file"];
    //    [uy uploadFile:filePath saveKey:[self getSaveKey]];
    
    /**
     *	@brief	根据 NSDate  上传
     */
    //    NSData * fileData = [NSData dataWithContentsOfFile:filePath];
    //    [uy uploadFile:fileData saveKey:[self getSaveKey]];

    }

}


#pragma mark  UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1001 ) { //文字{
        switch (buttonIndex){
            case 0:
                NSLog(@"我点了 拍照上传————》");
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker =
                    [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing=YES;
                    // 摄像头
                   [[UIApplication sharedApplication] setStatusBarHidden:YES];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:^(void){}];
                }else {
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:@"你没有摄像头"
                                          delegate:nil
                                          cancelButtonTitle:@"Drat!"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                break;
                
            case 1:
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                    UIImagePickerController *picker =[[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing=YES;
                    // 图片库
                    [[UIApplication sharedApplication] setStatusBarHidden:YES];
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                     [self presentViewController:picker animated:YES completion:^(void){}];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc]
                                          initWithTitle:@"Error"
                                          message:@"无法打开相册"
                                          delegate:nil
                                          cancelButtonTitle:@"Drat!"
                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                break;
            case 2:
            {
                
            }
                break;
                
        }
        
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 得到图片
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [NSThread detachNewThreadSelector:@selector(ProssImg:) toTarget:self withObject:image];
    isfinish=YES;
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    isfinish=YES;
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)ProssImg:(UIImage *)images{
    float imgpicwidth =images.size.width;
    float imgpicheight =images.size.height;
    NSLog(@"相片宽度——----》%f",imgpicwidth);
    NSLog(@"相片高度——----》%f",imgpicheight);
//    imgdata=UIImagePNGRepresentation(images);
//    imagStr=[[NSString alloc] initWithData:imgdata  encoding:NSUTF8StringEncoding];
    
    UIImage *resizeImg = [[images fixOrientation] scaleToFixedSize:CGSizeMake(300,300)];
    headImage.image=resizeImg;
    isfinish=YES;
    
}



-(NSString * )getSaveKey {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@/avatar/%.0f.jpg",[MainModel sharedObject].strUid,[[NSDate date] timeIntervalSince1970]];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://wiki.upyun.com/index.php?title=Policy_%E5%86%85%E5%AE%B9%E8%AF%A6%E8%A7%A3
     */
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
