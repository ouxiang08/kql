//
//  SendInvitationViewController.m
//  mote
//
//  Created by meikai on 13-12-26.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "PriceModel.h"
#import "SendInvitationPriceViewController.h"
#import "SendInvitationViewController.h"

@interface SendInvitationViewController ()<PriceModifiedDelegate>{
    BOOL _bModel;
    BOOL _bShe;
    BOOL _bZao;
    
    NSMutableArray *_arrPriceModel;
    NSString *_strPriceQipai;
    NSString *_strUserType;
    NSString *_strPriceType;
    NSString *_strUnittype;
    NSString *_strPrice;
    
}

@end

@implementation SendInvitationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _bModel = NO;
    _bShe = NO;
    _bZao = NO;
    _arrPriceModel = [[NSMutableArray alloc] init];
    _strPriceQipai = @"";
    _strUserType = @"";
    _strPriceType = @"";
    _strUnittype = @"";
    _strPrice = @"";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发送邀约";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"发送" selector:@selector(onSendInvitation) target:self];
    
    [self initDisplayView];
    // Do any additional setup after loading the view from its nib.
}

-(void)onSendInvitation{
    if (_arrPriceModel.count) {
        [self getAppendStr];
        NSString *strUrl = [UrlHelper stringUrlSendInvite];
        NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
        [dictParameter setObject:_strUserType forKey:@"usertype"];
        [dictParameter setObject:_strPriceType forKey:@"pricetype"];
        [dictParameter setObject:_strUnittype forKey:@"unittype"];
        [dictParameter setObject:_strPrice forKey:@"price"];
        [dictParameter setObject:_strPriceQipai forKey:@"baseprice"];
        [dictParameter setObject:self.strMid forKey:@"mid"];
        [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
            self.maskView.hidden = YES;
            [self.delegate sendSucess];
            [self.navigationController popViewControllerAnimated:YES];
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"发送邀约成功!"];
        } andFailureBlock:^(NSError *error) {
            self.maskView.hidden = YES;
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"发送邀约失败!"];
        }];
    }else{
         [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请输入价格!"];
    }
}

-(void)getAppendStr{
    for (int i= 0;i<_arrPriceModel.count-1; i++) {
        PriceModel *model = [_arrPriceModel objectAtIndex:i];
        
        _strUserType = [_strUserType stringByAppendingFormat:@"%@,",model.strUserType];
        _strPriceType = [_strPriceType stringByAppendingFormat:@"%@,",model.strPriceType];
        _strUnittype = [_strUnittype stringByAppendingFormat:@"%@,",model.strUnitType];
        _strPrice = [_strPrice stringByAppendingFormat:@"%@,",model.strPrice];
    }
    
    if (_arrPriceModel.count) {
        PriceModel *model = [_arrPriceModel lastObject];
        
        _strUserType = [_strUserType stringByAppendingFormat:@"%@",model.strUserType];
        _strPriceType = [_strPriceType stringByAppendingFormat:@"%@",model.strPriceType];
        _strUnittype = [_strUnittype stringByAppendingFormat:@"%@",model.strUnitType];
        _strPrice = [_strPrice stringByAppendingFormat:@"%@",model.strPrice];
    }
}

-(IBAction)onPriceModified:(id)sender{
    SendInvitationPriceViewController *sendVC = [[SendInvitationPriceViewController alloc] init];
    UIButton *button = (UIButton *)sender;
    if (button.tag == 1) {
        self.iType = KModelQipai;
        sendVC.iType = KQiPaiView;
        sendVC.strPriceQipai = _strPriceQipai;
    }else if (button.tag == 2) {
        self.iType = KModelPengPai;
        sendVC.iType = KOtherView;
    }else if (button.tag == 3) {
        self.iType = KModelWaiPai;
        sendVC.iType = KOtherView;
    }else if (button.tag == 4) {
        self.iType = KModelNeiyi;
        sendVC.iType = KOtherView;
    }else if (button.tag == 5) {
        self.iType = KShePengPai;
        sendVC.iType = KOtherView;
    }else if (button.tag == 6) {
        self.iType = KSheWaiPai;
        sendVC.iType = KOtherView;
    }else if (button.tag == 7) {
        self.iType = KZaoPengPai;
        sendVC.iType = KOtherView;
    }else{
        self.iType = KZaoWaiPai;
        sendVC.iType = KOtherView;
    }
    
    sendVC.delegate = self;
    [self.navigationController pushViewController:sendVC animated:YES];
}

-(void)modifyPriceByDay:(NSString *)strPriceByDay byUnit:(NSString *)strPriceByUnit{
   
    if ([strPriceByDay isNotNilOrBlankString]&&[strPriceByUnit isNotNilOrBlankString]) {
        PriceModel *model = [[PriceModel alloc] init];
        model.strUnitType = @"d";
        [self addToPriceModelArray:strPriceByDay model:model];
        
        PriceModel *modelByUnit = [[PriceModel alloc] init];
        modelByUnit.strUnitType = @"p";
        [self addToPriceModelArray:strPriceByUnit model:modelByUnit];
        
        NSString *strDisplayPrice = [NSString stringWithFormat:@"%@/天 %@/件",strPriceByDay,strPriceByUnit];
        [self displayPriceInLabel:strDisplayPrice];
    }else if([strPriceByDay isNotNilOrBlankString]){
        PriceModel *model = [[PriceModel alloc] init];
        model.strUnitType = @"d";
        [self addToPriceModelArray:strPriceByDay model:model];
        
        PriceModel *modelRemove = [[PriceModel alloc] init];
        modelRemove.strUnitType = @"p";
        [self removeModel:modelRemove];
        
        NSString *strDisplayPrice = [NSString stringWithFormat:@"%@/天",strPriceByDay];
        [self displayPriceInLabel:strDisplayPrice];

    }else{
        PriceModel *model = [[PriceModel alloc] init];
        model.strUnitType = @"p";
        [self addToPriceModelArray:strPriceByDay model:model];
        
        PriceModel *modelRemove = [[PriceModel alloc] init];
        modelRemove.strUnitType = @"d";
        [self removeModel:modelRemove];
        
        NSString *strDisplayPrice = [NSString stringWithFormat:@"%@/件",strPriceByUnit];
        [self displayPriceInLabel:strDisplayPrice];
    }
}

-(void)displayPriceInLabel:(NSString *)strPriceInLabel{
    if(self.iType == KModelPengPai){
        self.labelModelPengpai.text = strPriceInLabel;
    }else if(self.iType == KModelWaiPai){
        self.labelModelWaipai.text = strPriceInLabel;
    }else if(self.iType == KModelNeiyi){
        self.labelModelNeiyi.text = strPriceInLabel;
    }else if(self.iType == KShePengPai){
        self.labelShePengpai.text = strPriceInLabel;
    }else if(self.iType == KSheWaiPai){
        self.labelSheWaipai.text = strPriceInLabel;
    }else if(self.iType == KZaoPengPai){
        self.labelZaoPengpai.text = strPriceInLabel;
    }else{
        self.labelZaoWaipai.text = strPriceInLabel;
    }
}

-(void)addToPriceModelArray:(NSString *)strPrice model:(PriceModel *)model{
    model.strPrice = strPrice;
    
   if(self.iType == KModelPengPai){
        model.strUserType = @"m";
        model.strPriceType = @"i";
        
    }else if(self.iType == KModelWaiPai){
        model.strUserType = @"m";
        model.strPriceType = @"o";
    }else if(self.iType == KModelNeiyi){
        model.strUserType = @"m";
        model.strPriceType = @"n";
    }else if(self.iType == KShePengPai){
        model.strUserType = @"p";
        model.strPriceType = @"i";
    }else if(self.iType == KSheWaiPai){
        model.strUserType = @"p";
        model.strPriceType = @"o";
    }else if(self.iType == KZaoPengPai){
        model.strUserType = @"d";
        model.strPriceType = @"i";
    }else{
        model.strUserType = @"d";
        model.strPriceType = @"o";
    }
    
     [self addToPriceModelArray:model];
}

-(void)removeModel:(PriceModel *)model{
    if(self.iType == KModelPengPai){
        model.strUserType = @"m";
        model.strPriceType = @"i";
        
    }else if(self.iType == KModelWaiPai){
        model.strUserType = @"m";
        model.strPriceType = @"o";
    }else if(self.iType == KModelNeiyi){
        model.strUserType = @"m";
        model.strPriceType = @"n";
    }else if(self.iType == KShePengPai){
        model.strUserType = @"p";
        model.strPriceType = @"i";
    }else if(self.iType == KSheWaiPai){
        model.strUserType = @"p";
        model.strPriceType = @"o";
    }else if(self.iType == KZaoPengPai){
        model.strUserType = @"d";
        model.strPriceType = @"i";
    }else{
        model.strUserType = @"d";
        model.strPriceType = @"o";
    }
    
    for (PriceModel *modelTmp in _arrPriceModel) {
        if ([modelTmp.strUserType isEqualToString:model.strUserType]&&
            [modelTmp.strPriceType isEqualToString:model.strPriceType]&&
            [modelTmp.strUnitType isEqualToString:model.strUnitType]) {
            [_arrPriceModel removeObject:modelTmp];
            
            break;
        }
    }
}

-(void)addToPriceModelArray:(PriceModel *)model{
    BOOL isExistInPriceModelArray = NO;
    for (PriceModel *modelTmp in _arrPriceModel) {
        if ([modelTmp.strUserType isEqualToString:model.strUserType]&&
            [modelTmp.strPriceType isEqualToString:model.strPriceType]&&
            [modelTmp.strUnitType isEqualToString:model.strUnitType]) {
            modelTmp.strPrice = model.strPrice;
            isExistInPriceModelArray = YES;
            break;
        }
    }
    
    if (!isExistInPriceModelArray) {
        [_arrPriceModel addObject:model];
    }
}

-(void)modifyPriceQipai:(NSString *)strQipai{
    _strPriceQipai = strQipai;
    self.labelModelQipai.text = strQipai;
}

-(void)initDisplayView{
    NSString *strUserType = [[MainModel sharedObject] strUserType];
    CGFloat yOffset = 0;
    
    NSArray *arrUserType  = [strUserType componentsSeparatedByString:@"|"];
    for(NSString *str in arrUserType){
        if ([str isEqualToString:@"m"]) {
            _bModel = YES;
            [self.viewModel setOriginY:yOffset];
            [self.scrollViewInvitation addSubview:self.viewModel];
            yOffset += self.viewModel.frame.size.height+10;
        }else if ([str isEqualToString:@"p"]) {
            _bShe = YES;
            [self.viewShe setOriginY:yOffset];
            [self.scrollViewInvitation addSubview:self.viewShe];
            yOffset += self.viewShe.frame.size.height+10;
        }else{
            _bZao = YES;
            [self.viewZao setOriginY:yOffset];
            [self.scrollViewInvitation addSubview:self.viewZao];
            yOffset += self.viewZao.frame.size.height+10;
        }
    }
    
    if (_bModel&&_bShe&&_bZao) {
        [self.scrollViewInvitation setContentSize:CGSizeMake(320, self.scrollViewInvitation.frame.size.height+140)];
    }
    
    NSDictionary *dictUserInfo = [[MainModel sharedObject] dictUserInfo];
    NSArray *_arrPriceInfo = [[MainModel sharedObject] arrPriceInfo];
    
    _strPriceQipai = [dictUserInfo valueForKey:@"baseprice"];
    self.labelModelQipai.text = _strPriceQipai;
    
    if (_arrPriceInfo) {
        for (NSDictionary *dictPriceInfo in _arrPriceInfo) {
            NSString *strUserType = [dictPriceInfo valueForKey:@"usertype"];
            NSString *strPricetype = [dictPriceInfo valueForKey:@"pricetype"];
            NSString *strUnittype = [dictPriceInfo valueForKey:@"unittype"];
            NSString *strPrice = [dictPriceInfo valueForKey:@"price"];
            
            PriceModel *model = [[PriceModel alloc] init];
            model.strUserType = strUserType;
            model.strPriceType = strPricetype;
            model.strUnitType = strUnittype;
            model.strPrice = strPrice;
            [_arrPriceModel addObject:model];
            
            if ([strUserType isEqualToString:@"m"]) {//model
                
                if ([strPricetype isEqualToString:@"i"]) {//peng pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelModelPengpai.text = [self.labelModelPengpai.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelModelPengpai.text = [self.labelModelPengpai.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }else if ([strPricetype isEqualToString:@"o"]) {//wai pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelModelWaipai.text = [self.labelModelWaipai.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelModelWaipai.text = [self.labelModelWaipai.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }else{//nei yi
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelModelNeiyi.text = [self.labelModelNeiyi.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelModelNeiyi.text = [self.labelModelNeiyi.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }
            }else  if ([strUserType isEqualToString:@"p"]) {//she yi shi
                if ([strPricetype isEqualToString:@"i"]) {//peng pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelShePengpai.text = [self.labelShePengpai.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelShePengpai.text = [self.labelShePengpai.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }else{//wai pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelSheWaipai.text = [self.labelSheWaipai.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelSheWaipai.text = [self.labelSheWaipai.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }
            }else{//zao
                if ([strPricetype isEqualToString:@"i"]) {//peng pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelZaoPengpai.text = [self.labelZaoPengpai.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelZaoPengpai.text = [self.labelZaoPengpai.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }else{//wai pai
                    if ([strUnittype isEqualToString:@"d"]) {
                        self.labelZaoWaipai.text = [self.labelZaoWaipai.text stringByAppendingFormat:@" %@/天",strPrice];
                    }else{
                        self.labelZaoWaipai.text = [self.labelZaoWaipai.text stringByAppendingFormat:@" %@/件",strPrice];
                    }
                }
            }
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
