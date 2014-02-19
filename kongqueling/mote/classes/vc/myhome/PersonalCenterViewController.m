//
//  PersonalCenterViewController.m
//  mote
//
//  Created by sean on 12/18/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PersonalProfileModifyViewController.h"
#import "PersonalCenterViewController.h"
#import "MyInvitationListViewController.h"
#import "SanWeiInputViewController.h"
#import "UpYun.h"
#import "SDImageCache.h"

@interface PersonalCenterViewController ()<ProfileModifyDelegate,InputFinishDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSDictionary *_dictBaseInfo;
    NSArray *_arrPriceInfo;
    MokaIndicatorView *_mokaIndicator;
}

@property(nonatomic, strong) IBOutlet UILabel *labelModelTag;
@property(nonatomic, strong) IBOutlet UILabel *labelModelOrganization;

@property(nonatomic, strong) IBOutlet UILabel *labelModelQipai;

@property(nonatomic, strong) IBOutlet UILabel *labelModelPengPai;
@property(nonatomic, strong) IBOutlet UILabel *labelModelWaiPai;
@property(nonatomic, strong) IBOutlet UILabel *labelModelNeiyi;

@property(nonatomic, strong) IBOutlet UILabel *labelShePengPai;
@property(nonatomic, strong) IBOutlet UILabel *labelShelWaiPai;

@property(nonatomic, strong) IBOutlet UILabel *labelZaoPengPai;
@property(nonatomic, strong) IBOutlet UILabel *labelZaoWaiPai;
@property (weak, nonatomic) IBOutlet UILabel *labelNickName;

@property(nonatomic, strong) IBOutlet UILabel *labelQQ;
@property(nonatomic, strong) IBOutlet UILabel *labelWeiXin;
@property(nonatomic, strong) IBOutlet UILabel *labelPhone;

@property(nonatomic, strong) IBOutlet UILabel *labelGender;
@property(nonatomic, strong) IBOutlet UILabel *labelAge;
@property(nonatomic, strong) IBOutlet UILabel *labelNation;
@property(nonatomic, strong) IBOutlet UILabel *labelDistrict;

@property(nonatomic, strong) IBOutlet UILabel *labelHeight;
@property(nonatomic, strong) IBOutlet UILabel *labelWeight;
@property(nonatomic, strong) IBOutlet UILabel *labelBreast;
@property(nonatomic, strong) IBOutlet UILabel *labelXie;
@property(nonatomic, strong) IBOutlet UILabel *labelSanwei;
@property(nonatomic, strong) IBOutlet UILabel *labelJian;

@end

@implementation PersonalCenterViewController

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
    self.title = @"个人资料";
    self.view.backgroundColor= MOKA_VIEW_BG_COLOR_BLUE;
    
    [self initViewDisplay];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)onFindMerchant:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate findMerchant];
}

-(void)initViewDisplay{
    NSString *strUserType = [[MainModel sharedObject] strUserType];
    CGFloat yOffset = 0;
    
    [self.viewTop setOriginY:yOffset];
    [self.scrollViewContent addSubview:self.viewTop];
    yOffset += self.viewTop.frame.size.height+10;
    
    [self.viewTag setOriginY:yOffset];
    [self.scrollViewContent addSubview:self.viewTag];
    yOffset += self.viewTag.frame.size.height+10;
    
    NSArray *arrUserType  = [strUserType componentsSeparatedByString:@"|"];
    BOOL ismodal = NO;
    for(NSString *str in arrUserType){
        if ([str isEqualToString:@"m"]) {
            [self.viewMote setOriginY:yOffset];
            [self.scrollViewContent addSubview:self.viewMote];
            yOffset += self.viewMote.frame.size.height+10;
            ismodal = YES;
        }else if ([str isEqualToString:@"p"]) {
            [self.viewShe setOriginY:yOffset];
            [self.scrollViewContent addSubview:self.viewShe];
            yOffset += self.viewShe.frame.size.height+10;
        }else{
            [self.viewZao setOriginY:yOffset];
            [self.scrollViewContent addSubview:self.viewZao];
            yOffset += self.viewZao.frame.size.height+10;
        }
    }
    
    [self.viewContact setOriginY:yOffset];
    [self.scrollViewContent addSubview:self.viewContact];
    yOffset += self.viewContact.frame.size.height+10;
    
    [self.viewGender setOriginY:yOffset];
    [self.scrollViewContent addSubview:self.viewGender];
    yOffset += self.viewGender.frame.size.height+10;
    
    if (ismodal) {
        [self.viewHeight setOriginY:yOffset];
        [self.scrollViewContent addSubview:self.viewHeight];
        yOffset += self.viewHeight.frame.size.height+10;
    }
   
    
    [self.scrollViewContent setContentSize:CGSizeMake(320, yOffset+40)];
}

-(void)loadData{
    NSString *strUrl = [UrlHelper stringUrlGetUserinfo:[MainModel sharedObject].strUid];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        NSLog(@"success");
        
        NSDictionary *dictMsg = [dictResponse valueForKey:@"msg"];
        _dictBaseInfo = [dictMsg valueForKey:@"baseinfo"];
        _arrPriceInfo = [dictMsg valueForKey:@"priceinfo"];
        self.labelModelOrganization.text = [dictMsg valueForKey:@"lastMname"];
        [self initLabelDisplay];
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

-(void)openThePhotoAndCamera{
   
}



#pragma mark  UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1001 ) { //文字{
        switch (buttonIndex){
            case 0:
                NSLog(@"我点了 拍照上传————》");
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
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

-(IBAction)onChangeLogo:(id)sender{
    
    UIActionSheet *actiontxt = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"我要再想想" destructiveButtonTitle:nil otherButtonTitles:@"拍照上传",@"手机相册",nil];
    actiontxt.tag = 1001;
    [actiontxt setActionSheetStyle:UIActionSheetStyleDefault];
    [actiontxt showInView:self.view];
//    
//    
//    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
//        sourceType=UIImagePickerControllerSourceTypeCamera;
//    }
//    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
//    picker.delegate = self;
//    picker.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"取消" selector:@selector(imagePickerControllerDIdCancel:) target:self];
//    picker.allowsEditing=YES;
//    picker.sourceType=sourceType;
//    [self  presentViewController:picker animated:YES completion:^(void){}];
}

-(void)imagePickerControllerDIdCancel:(UIImagePickerController*)picker
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [picker dismissViewControllerAnimated:YES completion:^(void){}];
    
    if (_mokaIndicator.superview != self.view.window ) {
        [self.view.window addSubview:_mokaIndicator];
    }
    [_mokaIndicator start];
    
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}

- (void)selectPic:(UIImage*)image
{
    UIImage *resizeImg = [[image fixOrientation] scaleToFixedSize:CGSizeMake(200,200)];
    UpYun *uy = [[UpYun alloc] init];
    uy.successBlocker = ^(id data)
    {
        [self modifyProfileInfo:[data valueForKey:@"url"]];
        [_mokaIndicator stop];
    };
    uy.failBlocker = ^(NSError * error)
    {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"更新头像！"];
        [_mokaIndicator stop];
    };
    [uy uploadFile:resizeImg saveKey:[self getSaveKey]];
}

#pragma mark - modify profile request
-(void)modifyProfileInfo:(NSString *)strImageUrl{
    NSString *strUrl = [UrlHelper stringUrlUpdateProfile];
    NSMutableDictionary *dict = [NSMutableDictionaryFactory getMutableDictionary];
    [dict setObject:@"imgpath"forKey:@"key"];
    [dict setObject:strImageUrl forKey:@"value"];
    [self actionRequestWithUrl:strUrl parameters:dict successBlock:^(NSDictionary *dictResponse) {
        NSLog(@"dict:%@",dictResponse);
        self.maskView.hidden = YES;
        
        
        NSString *key = [NSString stringWithFormat:@"%@%@", KImageUrlDefault, strImageUrl];
        [[SDImageCache sharedImageCache] removeImageForKey:key];
        [self.imageViewLogo setImageWithURL:urlFromImageURLstr(strImageUrl) placeholderImage:[UIImage imageNamed:@"no_image"]];
        [self.delegate modifyLogoWithUrl:strImageUrl];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"failed");
        self.maskView.hidden = YES;
    }];
}

-(NSString * )getSaveKey {
    return [NSString stringWithFormat:@"/%@/avatar.jpg",[MainModel sharedObject].strUid];
}

-(void)initLabelDisplay{
    if (_dictBaseInfo) {
        _labelName.text = [_dictBaseInfo valueForKey:@"nickname"];
        _lblNickname.text = [_dictBaseInfo valueForKey:@"nickname"];
        NSArray *jobdetail = [[_dictBaseInfo valueForKey:@"usertype"] componentsSeparatedByString:@"|"];
        NSString *joblist = @"";
        for (int i=0; i<[jobdetail count]; i++) {
            NSString *jobname = [jobdetail objectAtIndex:i];
            if ([jobname isEqualToString:@"d"]) {
                joblist = [joblist stringByAppendingString:@" 造型师"];
            }
            if ([jobname isEqualToString:@"m"]) {
                joblist = [joblist stringByAppendingString:@" 模特"];
            }
            if ([jobname isEqualToString:@"p"]) {
                joblist = [joblist stringByAppendingString:@" 摄影师"];
            }
        }
        _lblJob.text = joblist;
        
        NSString *gender = [_dictBaseInfo valueForKey:@"gender"];
        if ([gender isEqualToString:@"M"]) {
            _imgviewGender.image = [UIImage imageNamed:@"myhome_gender_male_logo.png"];
            self.labelGender.text = @"男";
        }else{
            self.labelGender.text = @"女";
            _imgviewGender.image = [UIImage imageNamed:@"myhome_gender_women_logo.png"];
        }
        
        // 头像view、
        self.imageViewLogo.layer.cornerRadius = CGRectGetWidth(self.imageViewLogo.frame)/2;
        self.imageViewLogo.layer.masksToBounds = YES;
        self.imageViewLogo.backgroundColor = [UIColor whiteColor];

        NSString *avatarurl = [_dictBaseInfo valueForKey:@"avatarPath"];
        if (![avatarurl isEqualToString:@""]) {
            NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,avatarurl];
            [self.imageViewLogo setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
            //NSData *dt = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImageUrl]];
            //[self.imageViewLogo setImage:[UIImage imageWithData:dt]];
        }else{
            [self.imageViewLogo setImage:[UIImage imageNamed:@"no_image"]];
        }
        
        self.labelModelTag.text     =   [_dictBaseInfo valueForKey:@"tag"];
        self.labelModelQipai.text   =  [NSString stringWithFormat:@"%d",[[_dictBaseInfo valueForKey:@"baseprice"] integerValue]];
        self.labelQQ.text               =   [_dictBaseInfo valueForKey:@"qq"];
        self.labelWeiXin.text          =   [_dictBaseInfo valueForKey:@"weixin"];
        self.labelPhone.text           =  [_dictBaseInfo valueForKey:@"mobile"];
        self.labelAge.text              = [NSString stringWithFormat:@"%d", [[_dictBaseInfo valueForKey:@"age"] integerValue]];
        self.labelNation.text          = [_dictBaseInfo valueForKey:@"nation"];
        self.labelDistrict.text         = [_dictBaseInfo valueForKey:@"city"];
        self.labelHeight.text          = [NSString stringWithFormat:@"%@cm", [_dictBaseInfo valueForKey:@"height"]];
        self.labelWeight.text          = [NSString stringWithFormat:@"%@kg", [_dictBaseInfo valueForKey:@"weight"]];
        self.labelBreast.text           = [_dictBaseInfo valueForKey:@"barsize"];
        self.labelXie.text                = [NSString stringWithFormat:@"%@码", [_dictBaseInfo valueForKey:@"footsize"]];
        self.labelSanwei.text          = [_dictBaseInfo valueForKey:@"bodysize"];
        self.labelJian.text               = [NSString stringWithFormat:@"%@cm", [_dictBaseInfo valueForKey:@"shouldersize"]];
        self.labelNickName.text = [_dictBaseInfo valueForKey:@"nickname"];
    }
    
    if (_arrPriceInfo) {
        for (NSDictionary *dictPriceInfo in _arrPriceInfo) {
            NSString *strUserType = [dictPriceInfo valueForKey:@"usertype"];
            NSString *strPricetype = [dictPriceInfo valueForKey:@"pricetype"];
            NSString *strUnittype = [dictPriceInfo valueForKey:@"unittype"];
            int iPrice = [[dictPriceInfo valueForKey:@"price"] integerValue];
            //NSString *strPrice = [dictPriceInfo valueForKey:@"price"];
            
            if ([strUserType isEqualToString:@"m"]) {//model
                
                if ([strPricetype isEqualToString:@"i"]) {//peng pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelModelPengPai.text = [self.labelModelPengPai.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelModelPengPai.text = [self.labelModelPengPai.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }else if ([strPricetype isEqualToString:@"o"]) {//wai pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelModelWaiPai.text = [self.labelModelWaiPai.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelModelWaiPai.text = [self.labelModelWaiPai.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }else{//nei yi
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelModelNeiyi.text = [self.labelModelNeiyi.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelModelNeiyi.text = [self.labelModelNeiyi.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }
            }else  if ([strUserType isEqualToString:@"p"]) {//she yi shi
                if ([strPricetype isEqualToString:@"i"]) {//peng pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelShePengPai.text = [self.labelShePengPai.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelShePengPai.text = [self.labelShePengPai.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }else{//wai pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelShelWaiPai.text = [self.labelShelWaiPai.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelShelWaiPai.text = [self.labelShelWaiPai.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }
            }else{//zao
                if ([strPricetype isEqualToString:@"i"]) {//peng pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelZaoPengPai.text = [self.labelZaoPengPai.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelZaoPengPai.text = [self.labelZaoPengPai.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }else{//wai pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelZaoWaiPai.text = [self.labelZaoWaiPai.text stringByAppendingFormat:@" %d/天",iPrice];
                    }else{
                        self.labelZaoWaiPai.text = [self.labelZaoWaiPai.text stringByAppendingFormat:@" %d/件",iPrice];
                    }
                }
            }

        }
    }
}

-(IBAction)onMerchantListDisplay:(id)sender{
    MyInvitationListViewController *invitationVC = [[MyInvitationListViewController alloc] init];
    invitationVC.iStatus = 1;
    [self.navigationController pushViewController:invitationVC animated:YES];
}

-(IBAction)onModifyProfile:(id)sender{
    PersonalProfileModifyViewController *modifyVC = [[PersonalProfileModifyViewController alloc] init];
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        modifyVC.type = MOTE_QIPAI;
    }else if (button.tag == 2) {
        modifyVC.type = MOTE_PENGPAI;
    }else if (button.tag == 3) {
        modifyVC.type = MOTE_WAIPAI;
    }else if (button.tag == 4) {
        modifyVC.type = MOTE_NEIYI;
    }else if (button.tag == 5) {
        modifyVC.type = SHE_PEIPAI;
    }else if (button.tag == 6) {
        modifyVC.type = SHE_WAI;
    }else if (button.tag == 7) {
        modifyVC.type = ZAO_PENGPAI;
    }else if (button.tag == 8) {
        modifyVC.type = ZAO_WAIPAI;
    }else if (button.tag == 9) {
        modifyVC.type = QQ;
    }else if (button.tag == 10) {
        modifyVC.type = WEIXIN;
    }else if (button.tag == 11) {
        modifyVC.type = PHONE;
    }else if (button.tag == 13) {
        modifyVC.type = MOTE_AGE;
    }else if (button.tag == 14) {
        modifyVC.type = MOTE_NATION;
    }else if (button.tag == 15) {
        modifyVC.type = MOTE_DISTRICT;
    }else if (button.tag == 16) {
        modifyVC.type = MOTE_HEIGHT;
    }else if (button.tag == 17) {
        modifyVC.type = MOTE_WEIGHT;
    }else if (button.tag == 18) {
        modifyVC.type = MOTE_BREAST;
    }else if (button.tag == 19) {
        modifyVC.type = MOTE_XIE;
    }else if (button.tag == 21) {
        modifyVC.type = MOTE_JIAN;
    }else if (button.tag == 101) {
        modifyVC.type = MOTE_TAG;
    }else if (button.tag == 91) {
        modifyVC.type = NICKNAME;
    }else if (button.tag == 99) {
        modifyVC.type = MOTE_NAME;
    }
    

    modifyVC.delegate = self;
    modifyVC.baseinfo = _dictBaseInfo;
    modifyVC.priceinfo = _arrPriceInfo;
    [self.navigationController pushViewController:modifyVC animated:YES];
}

-(IBAction)onModifySanwei:(id)sender{
    SanWeiInputViewController *sanweiVC = [[SanWeiInputViewController alloc] init];
    sanweiVC.delegate = self;
    sanweiVC.baseinfo = _dictBaseInfo;
    sanweiVC.bUpload = YES;
    [self.navigationController pushViewController:sanweiVC animated:YES];
}


#pragma mark - Sanwei input delegate
-(void)inputWith:(NSString *)str{
    [self updatePrice];
    self.labelSanwei.text = str;
}

#pragma mark - ModifyProfileDelegate
-(void)modifyProfileByType:(MODIFY_TYPE)type dict:(NSMutableDictionary *)dict{
    [self updatePrice];
    
    if (type == MOTE_PENGPAI) {
        [self displayAfterModify:self.labelModelPengPai dict:dict];
    }else if (type == MOTE_WAIPAI) {
        [self displayAfterModify:self.labelModelWaiPai dict:dict];
    }else if (type == MOTE_NEIYI) {
        [self displayAfterModify:self.labelModelNeiyi dict:dict];
    }else if (type == SHE_PEIPAI) {
        [self displayAfterModify:self.labelShePengPai dict:dict];
    }else if (type == SHE_WAI) {
        [self displayAfterModify:self.labelShelWaiPai dict:dict];
    }else if (type == ZAO_PENGPAI) {
        [self displayAfterModify:self.labelZaoPengPai dict:dict];
    }else if (type == ZAO_WAIPAI) {
        [self displayAfterModify:self.labelZaoWaiPai dict:dict];
    }
}

-(void)modifyProfileByType:(MODIFY_TYPE)type str:(NSString *)strText{
    [self updatePrice];
    
    if (type == QQ) {
        [self displayAfterModify:self.labelQQ str:strText];
    }else if (type == NICKNAME) {
        [self displayAfterModify:self.labelNickName str:strText];
    }else if (type == WEIXIN) {
        [self displayAfterModify:self.labelWeiXin str:strText];
    }else if (type == PHONE) {
        [self displayAfterModify:self.labelPhone str:strText];
    }else if (type == MOTE_AGE) {
        [self displayAfterModify:self.labelAge str:strText];
    }else if (type == MOTE_NATION) {
        [self displayAfterModify:self.labelNation str:strText];
    }else if (type == MOTE_DISTRICT) {
        [self displayAfterModify:self.labelDistrict str:strText];
    }else if (type == MOTE_HEIGHT) {
        [self displayAfterModify:self.labelHeight str:strText];
    }else if (type == MOTE_WEIGHT) {
        [self displayAfterModify:self.labelWeight str:strText];
    }else if (type == MOTE_BREAST) {
        [self displayAfterModify:self.labelBreast str:strText];
    }else if (type == MOTE_XIE) {
        [self displayAfterModify:self.labelXie str:strText];
    }else if (type == MOTE_JIAN) {
        [self displayAfterModify:self.labelJian str:strText];
    }else if (type == MOTE_QIPAI) {
        [self displayAfterModify:self.labelModelQipai str:strText];
    }else if (type == MOTE_TAG) {
        [self displayAfterModify:self.labelModelTag str:strText];
    }else if (type == MOTE_NAME) {
        [self displayAfterModify:self.labelName str:strText];
         _lblNickname.text = strText;
        [[MainModel sharedObject] saveNickName:strText];
    }
}

-(void)displayAfterModify:(UILabel *)label dict:(NSMutableDictionary *)dict{
    NSString *strByDay = [dict valueForKey:KPengPaiByDay];
    NSString *strByUnit = [dict valueForKey:KPengPaiByUnit];
    
    if ([strByDay isNotNilOrBlankString]&&[strByUnit isNotNilOrBlankString]) {
        label.text = [NSString stringWithFormat:@"%@元/天    %@元/件",strByDay,strByUnit];
    }else if([strByDay isNotNilOrBlankString]){
        label.text = [NSString stringWithFormat:@"%@元/天",strByDay];
    }else{
        label.text = [NSString stringWithFormat:@"%@元/件",strByUnit];
    }
}

-(void)updatePrice{
    dispatch_queue_t aQueue = dispatch_queue_create("Update", DISPATCH_QUEUE_SERIAL);
    dispatch_async(aQueue, ^{
        
        NSError *error;
        NSString *strUrl =[NSString stringWithFormat:@"%@/dologin?mobile=%@&pass=%@",KHomeUrlDefault,[[MainModel sharedObject] strUserName] ,[[MainModel sharedObject] strPassword]];
        NSString *strResult = [NSString stringWithContentsOfURL:[NSURL URLWithString:strUrl] encoding:NSUTF8StringEncoding error:&error];
        
        NSDictionary *dictResult = [strResult JSONValue];
        _dictBaseInfo = [dictResult valueForKey:@"userinfo"];
        _arrPriceInfo = [dictResult valueForKey:@"priceinfo"];
        
        [[MainModel sharedObject] saveDictUserInfo:_dictBaseInfo];
        [[MainModel sharedObject] savePriceInfo:_arrPriceInfo];
    });
}


-(void)displayAfterModify:(UILabel *)label str:(NSString *)strText{
    label.text = strText;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
