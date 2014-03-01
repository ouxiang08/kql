//
//  MoteConfig.h
//  mote
//
//  Created by sean on 11/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

//#define KHomeUrlDefault @"http://prj.morework.cn/syq/api"
//#define KTemplateImageUrlDefault @"http://prj.morework.cn/syq/uploads/"

#define KHomeUrlDefault @"http://kongqueling.tupai.cc/api"
#define KTemplateImageUrlDefault @"http://kongqueling.tupai.cc/uploads/"


//#define KHomeUrlDefault @"http://192.168.1.108/syq/api"
//#define KTemplateImageUrlDefault @"http://192.168.1.108/syq/uploads/"

#define KImageUrlDefault @"http://tupai-app-image.b0.upaiyun.com"

#define KAppKey @"1058931ab9a0"

#define KMaxUploadImageCount 12

#define KRegFontSize 16

#define KHotLine @"4000022314"

#define KScreenBounds [[UIScreen mainScreen] bounds]

#define KimageShowMode UIViewContentModeScaleAspectFill
#define KdefaultFont @"Heiti SC"

#define MOKA_VIEW_BG_COLOR_BLUE [UIColor colorWithRed:227.0/255.0 green:230.0/255.0 blue:237.0/255.0 alpha:1.0]

#define MOKA_WAITTING_VIEW_BG_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]

#define MOKA_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height-20


//share App key and Secret
#define KAppKey @"1058931ab9a0"

#define KSinaAppKey @"532070633"
#define KSinaAppSecret @"ce00994af936ba00663e99b5b77739df"

#define KWeiXinAppid @"wx6e65eb68dacb0f86"

#define KRenRenAppId @"245982"
#define KRenRenAppKey @"bff030d00eac4cf7a8dabe8bb7d3a1f5"
#define KRenRenSecretKey @"6b2ad78ca3674cffa6adc870425495ad"

#define KTengXunWeiBoAppKey @"801461660"
#define KTengXunWeiBoAppSecret @"0123c048d3d0e65699f293837b839bbb"

#define KDouPanAppKey @"0ad8b641b591f0d2208a22c520b5d276"
#define KDouPanAppSecretKey @"e3a75fb65e9b3441"

#define KQQSpaceAppId @"100573882"
#define KQQSpaceAppKey @"d4324e135c8a169977b2385bef32a097"

#define KTestAccountId @"developer@tupai.cc"
#define KTestAccountPwd @"tupai2013"

#define kMessageDidChangeNofication @"kMessageDidChangeNofication"

@interface MoteConfig : NSObject 

@end

NSURL* urlFromImageURLstr(NSString* serverImageURLString);
