//
//  PersonalProfileModifyViewController.m
//  mote
//
//  Created by sean on 12/18/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PersonalProfileModifyViewController.h"

@interface PersonalProfileModifyViewController (){
    NSMutableDictionary *_dictResult;
    NSMutableDictionary *_dictParameter;
}

@end

@implementation PersonalProfileModifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _dictResult = [[NSMutableDictionary alloc] init];
    _dictParameter = [NSMutableDictionaryFactory getMutableDictionary];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;

    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"确定" selector:@selector(saveProfile) target:self];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self initViewByType];
    
    // Do any additional setup after loading the view from its nib.
}

- (NSString *)filterData:(NSString *)usertype pricetype:(NSString *)pricetype unittype:(NSString *)unittype{
    for (int i=0; i<[_priceinfo count]; i++) {
        NSDictionary *dict = [_priceinfo objectAtIndex:i];
        if ([[dict objectForKey:@"usertype"] isEqualToString:usertype] &&
            [[dict objectForKey:@"pricetype"] isEqualToString:pricetype] &&
            [[dict objectForKey:@"unittype"] isEqualToString:unittype]) {
            int iPrice = [[dict valueForKey:@"price"] integerValue];
            
            return [NSString stringWithFormat:@"%d",iPrice];
        }
    }
    return @"";
}

-(void)initViewByType{
    if (self.type == MOTE_PENGPAI) {
        self.title = @"棚拍价格";
        [_dictParameter setObject:@"i" forKey:@"pricetype"];
        [_dictParameter setObject:@"m" forKey:@"usertype"];
        
        _textFieldPengPaiByDay.text = [self filterData:@"m" pricetype:@"i" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"m" pricetype:@"i" unittype:@"p"];
        [self.view addSubview:self.viewMoTePengPai];
    }else  if (self.type == MOTE_WAIPAI) {
        [_dictParameter setObject:@"o" forKey:@"pricetype"];
        [_dictParameter setObject:@"m" forKey:@"usertype"];
        
        self.title = @"外拍价格";
        [self.view addSubview:self.viewMoTePengPai];
        
        _textFieldPengPaiByDay.text = [self filterData:@"m" pricetype:@"o" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"m" pricetype:@"o" unittype:@"p"];
        
    }else  if (self.type == MOTE_NEIYI) {
        [_dictParameter setObject:@"n" forKey:@"pricetype"];
        [_dictParameter setObject:@"m" forKey:@"usertype"];
        
        _textFieldPengPaiByDay.text = [self filterData:@"m" pricetype:@"n" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"m" pricetype:@"n" unittype:@"p"];
        
        self.title = @"内衣";
        [self.view addSubview:self.viewMoTePengPai];
    }else  if (self.type == SHE_PEIPAI) {
        [_dictParameter setObject:@"i" forKey:@"pricetype"];
        [_dictParameter setObject:@"p" forKey:@"usertype"];
        
        self.title = @"棚拍价格";
        [self.view addSubview:self.viewMoTePengPai];
        
        _textFieldPengPaiByDay.text = [self filterData:@"p" pricetype:@"i" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"p" pricetype:@"i" unittype:@"p"];
    }else  if (self.type == SHE_WAI) {
        [_dictParameter setObject:@"o" forKey:@"pricetype"];
        [_dictParameter setObject:@"p" forKey:@"usertype"];
        
        self.title = @"外拍价格";
        [self.view addSubview:self.viewMoTePengPai];
        
        _textFieldPengPaiByDay.text = [self filterData:@"p" pricetype:@"o" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"p" pricetype:@"o" unittype:@"p"];
    }else  if (self.type == ZAO_PENGPAI) {
        [_dictParameter setObject:@"i" forKey:@"pricetype"];
        [_dictParameter setObject:@"d" forKey:@"usertype"];
        
        
        _textFieldPengPaiByDay.text = [self filterData:@"d" pricetype:@"i" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"d" pricetype:@"i" unittype:@"p"];
        
        self.title = @"棚拍价格";
        [self.view addSubview:self.viewMoTePengPai];
    }else  if (self.type == ZAO_WAIPAI) {
        [_dictParameter setObject:@"o" forKey:@"pricetype"];
        [_dictParameter setObject:@"d" forKey:@"usertype"];
        
        _textFieldPengPaiByDay.text = [self filterData:@"d" pricetype:@"o" unittype:@"d"];
        _textFieldPengPaiByUnit.text = [self filterData:@"d" pricetype:@"o" unittype:@"p"];
        
        self.title = @"外拍价格";
        [self.view addSubview:self.viewMoTePengPai];
    }else  if (self.type == QQ) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"QQ:";
        self.title = @"修改QQ";
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
        self.textFieldSingle.text = [_baseinfo objectForKey:@"qq"];
    }else  if (self.type == NICKNAME) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"昵称:";
        self.title = @"修改昵称";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"nickname"];
    }else  if (self.type == WEIXIN) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"微信:";
        self.title = @"修改微信";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"weixin"];
    }else  if (self.type == PHONE) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"手机:";
        self.title = @"修改手机";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"mobile"];
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
    }else  if (self.type == MOTE_AGE) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"年龄:";
        self.title = @"修改年龄";
        self.textFieldSingle.text = [NSString stringWithFormat:@"%d", [[_baseinfo valueForKey:@"age"] integerValue]];
        self.labelUnit.text = @"岁";
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
    }else  if (self.type == MOTE_NATION) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"国家:";
        self.title = @"修改国家";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"nation"];
    }else  if (self.type == MOTE_DISTRICT) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"地区:";
        self.title = @"修改地区";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"city"];
    }else  if (self.type == MOTE_HEIGHT) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"身高:";
        self.title = @"修改身高";
        self.labelUnit.text = @"cm";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"height"];
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
    }else  if (self.type == MOTE_WEIGHT) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"体重:";
        self.title = @"体重";
        self.labelUnit.text = @"kg";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"weight"];
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
    }else  if (self.type == MOTE_BREAST) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"罩杯:";
        self.title = @"修改罩杯";
        //self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
        self.textFieldSingle.text = [_baseinfo objectForKey:@"barsize"];
    }else  if (self.type == MOTE_XIE) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"鞋码:";
        self.title = @"修改鞋码";
        self.labelUnit.text = @"码";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"footsize"];
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
    }else  if (self.type == MOTE_SANWEI) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"三围:";
        self.title = @"修改三围";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"bodysize"];
    }else  if (self.type == MOTE_JIAN) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"肩宽:";
        self.title = @"修改肩宽";
        self.labelUnit.text = @"cm";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"shouldersize"];
        self.textFieldSingle.keyboardType = UIKeyboardTypeNumberPad;
    }else  if (self.type == MOTE_QIPAI) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"价格:";
        self.title = @"修改起拍价格";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"baseprice"];
        self.labelUnit.text = @"元";
    }else  if (self.type == MOTE_TAG) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"标签:";
        self.title = @"修改标签";
        self.textFieldSingle.placeholder = @"如有多个标签请用空格隔开";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"tag"];
    }else  if (self.type == MOTE_NAME) {
        [self.view addSubview:self.viewSingle];
        self.labelLeft.text = @"昵称:";
        self.title = @"修改昵称";
        self.textFieldSingle.text = [_baseinfo objectForKey:@"nickname"];
    }
}

-(void)saveProfile{
    if (self.type == MOTE_PENGPAI||
        self.type == MOTE_WAIPAI||
        self.type == MOTE_NEIYI||
        self.type == SHE_PEIPAI||
        self.type == SHE_WAI||
        self.type == ZAO_PENGPAI||
        self.type == ZAO_WAIPAI) {
        
        [_dictResult setObject:self.textFieldPengPaiByDay.text forKey:KPengPaiByDay];
        [_dictResult setObject:self.textFieldPengPaiByUnit.text forKey:KPengPaiByUnit];
        
        if ([self.textFieldPengPaiByDay.text isNotNilOrBlankString]&&[self.textFieldPengPaiByUnit.text isNotNilOrBlankString]) {
            NSString *strPrice = [NSString stringWithFormat:@"%@,%@",self.textFieldPengPaiByDay.text,self.textFieldPengPaiByUnit.text];
            [_dictParameter setObject:strPrice forKey:@"price"];
            [_dictParameter setObject:@"p,d" forKey:@"unittype"];
            
            [self requestDataCommon:_dictParameter];
        }else if([self.textFieldPengPaiByDay.text isNotNilOrBlankString]){
            [_dictParameter setObject:self.textFieldPengPaiByDay.text forKey:@"price"];
            [_dictParameter setObject:@"d" forKey:@"unittype"];
            
            [self requestDataCommon:_dictParameter];
        }else if([self.textFieldPengPaiByUnit.text isNotNilOrBlankString]){
            [_dictParameter setObject:self.textFieldPengPaiByUnit.text forKey:@"price"];
            [_dictParameter setObject:@"p" forKey:@"unittype"];
            
            [self requestDataCommon:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == QQ){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"qq" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == NICKNAME){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"nickname" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == WEIXIN){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"weixin" forKey:@"key"];
            
             [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == PHONE){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"mobile" forKey:@"key"];
            
             [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_AGE){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"age" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_NATION){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"nation" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_DISTRICT){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"location" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_HEIGHT){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"height" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_WEIGHT){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"weight" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_BREAST){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"barsize" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_XIE){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"footsize" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_SANWEI){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"bodysize" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_JIAN){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"shouldersize" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_QIPAI){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"baseprice" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_TAG){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"tag" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }else if( self.type == MOTE_NAME){
        if ([self.textFieldSingle.text isNotNilOrBlankString]) {
            [_dictParameter setObject:self.textFieldSingle.text forKey:@"value"];
            [_dictParameter setObject:@"nickname" forKey:@"key"];
            
            [self modifyProfileInfo:_dictParameter];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"输入不能为空！"];
        }
    }
}

#pragma mark - modify price request
-(void)requestDataCommon:(NSMutableDictionary *)dict{
    NSString *strUrl = [UrlHelper stringUrlUpdatePrice];
    [self actionRequestWithUrl:strUrl parameters:dict successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [self.delegate modifyProfileByType:self.type dict:_dictResult];
        [self.navigationController popViewControllerAnimated:YES];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"failed");
        self.maskView.hidden = YES;
    }];
}


#pragma mark - modify profile request
-(void)modifyProfileInfo:(NSMutableDictionary *)dict{
    NSString *strUrl = [UrlHelper stringUrlUpdateProfile];
    [self actionRequestWithUrl:strUrl parameters:dict successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [self.delegate modifyProfileByType:self.type str:self.textFieldSingle.text];
        [self.navigationController popViewControllerAnimated:YES];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"failed");
        self.maskView.hidden = YES;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

@end
