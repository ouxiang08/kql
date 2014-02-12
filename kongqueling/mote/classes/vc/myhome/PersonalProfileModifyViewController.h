//
//  PersonalProfileModifyViewController.h
//  mote
//
//  Created by sean on 12/18/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    MOTE_PENGPAI = 0,
    MOTE_WAIPAI = 1,
    MOTE_NEIYI = 2,
    SHE_PEIPAI = 3,
    SHE_WAI = 4,
    ZAO_PENGPAI = 5,
    ZAO_WAIPAI = 6,
    QQ = 7,
    WEIXIN = 8,
    PHONE = 9,
    MOTE_AGE = 11,
    MOTE_NATION = 12,
    MOTE_DISTRICT = 13,
    NICKNAME = 91,
    
    MOTE_NAME = 99,
    MOTE_QIPAI = 100,
    MOTE_TAG = 101,
    
    MOTE_HEIGHT = 16,
    MOTE_WEIGHT= 17,
    MOTE_BREAST = 18,
    MOTE_XIE = 19,
    MOTE_SANWEI = 20,
    MOTE_JIAN = 21
}MODIFY_TYPE;

#define KPengPaiByDay @"PENG_PAI_BY_DAY"
#define KPengPaiByUnit @"PENG_PAI_BY_UNIT"

@protocol ProfileModifyDelegate <NSObject>


-(void)modifyProfileByType:(MODIFY_TYPE)type dict:(NSDictionary *)dict;
-(void)modifyProfileByType:(MODIFY_TYPE)type str:(NSString *)strText;

@end

@interface PersonalProfileModifyViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIView *viewMoTePengPai;
@property(nonatomic, strong) IBOutlet UITextField *textFieldPengPaiByDay;
@property(nonatomic, strong) IBOutlet UITextField *textFieldPengPaiByUnit;
@property(nonatomic, strong) IBOutlet UITextField *textFieldSingle;

@property(nonatomic, strong) IBOutlet UIView *viewSingle;
@property(nonatomic, strong) IBOutlet UILabel *labelLeft;
@property(nonatomic, strong) IBOutlet UILabel *labelUnit;

@property(nonatomic, strong) NSString *strInfo1;
@property(nonatomic, strong) NSString *strInfo3;
@property(nonatomic, strong) NSString *strInfo2;

@property(nonatomic, strong) NSDictionary *baseinfo;
@property(nonatomic, strong) NSArray *priceinfo;

@property(nonatomic, assign) MODIFY_TYPE type;
@property(nonatomic, assign) id<ProfileModifyDelegate>delegate;

@end
