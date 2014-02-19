//
//  UrlHelper.h
//  mote
//
//  Created by sean on 11/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#define kDefaultMobile @"15618989616"
#define kDefaultPassword @"111111"

//#define kDefaultMobile @"18221145161"
//#define kDefaultPassword @"123456"

#define __MainScreenFrame      [[UIScreen mainScreen] bounds]
#define __MainScreen_Width     __MainScreenFrame.size.width
#define __MainScreen_Height    __MainScreenFrame.size.height


#import <Foundation/Foundation.h>

@interface UrlHelper : NSObject

+(NSString *)addCommonParameter:(NSString *)strUrl;

+ (NSString *)getMD5String:(NSString *)key;

+(NSString *)stringUrlGetCardTemplates;

+(NSString *)stringUrlDoLogin:(NSString *)strMobile password:(NSString *)strPassword bduid:(NSString *)bduid bdcid:(NSString *)bdcid;

+(NSString *)stringUrlSetAlbum;

+(NSString *)stringUrlGetAlbums;

+(NSString *)stringUrlGetAlbumPhotos:(NSString *)strAid;

+(NSString *)stringUrlDeleteAlbumPhotos:(NSString *)strPids;

+(NSString *)stringUrlMovePhotos;

+(NSString *)stringUrlUploadPhotos;

+(NSString *)stringUrlDeleteAlbums:(int)aid;

+(NSString *)stringUrlGetBgMudic;

+(NSString *)stringUrlSaveAppSetting;

+(NSString *)stringUrlGetAppList;

+(NSString *)stringUrlGetUserinfo:(NSString *)strUid;

+(NSString *)stringUrlUpdatePrice;

+(NSString *)stringUrlUpdateProfile;

+(NSString *)stringUrlSaveCard;

+(NSString *)stringUrlGetMyCardList;

+(NSString *)stringUrlDeleteCard;

+(NSString *)stringUrlGetMerchantQueryInfo;

+(NSString *)stringUrlGetMerchantList:(int)iPage city:(NSString *)strCity area:(NSString *)strArea hotCity:(NSString *)strHotCity lat:(float)fLat lng:(float)fLng industry:(NSString *)strIndustry sort:(NSString *)strSort sname:(NSString *)strSname;

+(NSString *)stringUrlGetMerchantDetail:(NSString *)strMid;

+(NSString *)stringUrlGetTaskByMonth:(int)iYear month:(int)iMonth;

+(NSString *)stringUrlSetDate;

+(NSString *)stringUrlUpdatePass;

+(NSString *)stringUrlSetMfav;

+(NSString *)stringUrlMessageList:(int)catid iPage:(int)page;

+(NSString *)stringUrlMessageDelete;

+(NSString *)stringUrlSendInvite;

+(NSString *)stringUrlGetUserMerchant:(int)status;

+(NSString *)stringUrlGetUserFav;

+(NSString *)stringUrlGetTaskList;

+(NSString *)stringUrlUnbind;

+(NSString *)stringUrlGetTaskDetailWithTaskId:(NSString *)strTaskId;

+(NSString *)stringUrlTaskRefuse;

+(NSString *)stringUrlPollMerchant;

+(NSString *)stringUrlCheckUid:(NSString *)uid;

+(NSString *)stringUrlCheckUMsg:(NSString *)uid;

@end
