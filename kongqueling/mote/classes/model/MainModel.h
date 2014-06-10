//
//  MainModel.h
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <CoreLocation/CLLocation.h>
#import <Foundation/Foundation.h>
#import "MokaLocation.h"

#define KUid @"uid"
#define KNickName @"nickname"
#define KUserName @"username"
#define KPassword @"password"
#define KUserType @"usertype"
#define KBDUid @"bduid"
#define KBDChannelId @"bdchannelid"
#define KDictUserInfo @"userdicttype"
#define KPriceInfo @"priceinfo"
#define KAlbumId @"aid"
#define KShareInfo @"shareinfo"
#define KMsgNum @"msgNum"
#define KLocation @"cllocation"
#define KCity @"city"
#import "AppDelegate.h"

@interface MainModel : NSObject

@property(nonatomic, strong) NSString *strUid;
@property(nonatomic, strong) NSString *strUserName;
@property(nonatomic, strong) NSString *strPassword;
@property(nonatomic, strong) NSString *strNickName;
@property(nonatomic, strong) NSString *strAlbumId;
@property(nonatomic, strong) NSString *strUserType;
@property(nonatomic, strong) NSString *strBDUid;
@property(nonatomic, strong) NSString *strBDChannelId;
@property(nonatomic, strong) NSArray *arrPriceInfo;
@property(nonatomic, strong) NSDictionary *dictUserInfo;
@property (nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) NSDictionary *dictShareInfo;


@property(nonatomic, strong) CLLocation *currentLocation;
@property(nonatomic, strong) NSString *strCity;

@property(nonatomic, strong) MokaLocation *location;

+ (MainModel *) sharedObject;

- (void) saveUid: (NSString *)strUid;
- (void) saveNickName: (NSString *)strNickName;
- (void) saveUserName: (NSString *)strUserName;
- (void) savePassword: (NSString *)strPassword;
- (void) saveUserType: (NSString *)strUserType;
- (void) saveDictUserInfo: (NSDictionary *)dictUserInfo;
- (void) savePriceInfo: (NSArray *)arrPriceInfo;
- (void) saveAlbumId: (NSString *)strAlbumId;
- (void) saveLocation: (CLLocation *)location;
- (void) saveCity: (NSString *)strCity;
- (void) saveBDUid: (NSString *)strBDUid;
- (void) saveBDChannelId: (NSString *)strBDChannelId;
- (void) saveShareInfo: (NSDictionary *)dicShareInfo;


- (void)saveMsgNum:(NSString *)firstNum secondNum:(NSString *)secondNum thirdNum:(NSString *)thirdNum;
- (NSString *)getNumByIndex:(int)index;

- (void) startPosition;

@end
