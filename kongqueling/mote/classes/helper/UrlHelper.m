//
//  UrlHelper.m
//  mote
//
//  Created by sean on 11/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "UrlHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation UrlHelper

+ (NSString *)getMD5String:(NSString *)key{
    NSString *filename = nil;
    
    if ( [key length] > 0 ) {
        const char *str = [key UTF8String];
        unsigned char r[CC_MD5_DIGEST_LENGTH];
        CC_MD5(str, (CC_LONG)strlen(str), r);
        filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                    r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    }
    
    return filename;
}

+(NSString *)addCommonParameter:(NSString *)strUrl{
   
    long time=(long)[[NSDate date] timeIntervalSince1970];
    NSString *strTime = [NSString stringWithFormat:@"%ld",time];
    NSString *strUid = [MainModel sharedObject].strUid;
    NSString *strValidate = [NSString stringWithFormat:@"%@%@picspai",strUid,strTime];
    strValidate = [self getMD5String:strValidate];
    NSString * strResult;
    if ([strUrl isNilOrBlankString]) {
         strResult = [NSString stringWithFormat:@"uid=%@&time=%@&validate=%@",[MainModel sharedObject].strUid,strTime,strValidate];
    }else{
        strResult = [NSString stringWithFormat:@"%@uid=%@&time=%@&validate=%@",strUrl,[MainModel sharedObject].strUid,strTime,strValidate];
    }
    
    return strResult;
}

+(NSString *)stringUrlGetCardTemplates{
    NSString *strURL = [NSString stringWithFormat:@"%@/getcardtemplates?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlDoLogin:(NSString *)strMobile password:(NSString *)strPassword bduid:(NSString *)bduid bdcid:(NSString *)bdcid{
    NSString *strURL = [NSString stringWithFormat:@"%@/dologin?mobile=%@&pass=%@&platform=ios&bduid=%@&channelid=%@",KHomeUrlDefault,strMobile,strPassword,bduid,bdcid];
    return strURL;
}

+(NSString *)stringUrlUnbind{
    NSString *strURL = [NSString stringWithFormat:@"%@/unbinduser",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlSetAlbum{
    NSString *strURL = [NSString stringWithFormat:@"%@/setalbum",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlGetAlbums{
    NSString *strURL = [NSString stringWithFormat:@"%@/getalbums?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetAlbumPhotos:(NSString *)strAid{
    NSString *strURL = [NSString stringWithFormat:@"%@/getalbumphotos?aid=%@&",KHomeUrlDefault,strAid];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlDeleteAlbumPhotos:(NSString *)strPids{
    NSString *strURL = [NSString stringWithFormat:@"%@/delalbumphotos?pids=%@&",KHomeUrlDefault,strPids];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlMovePhotos{
    NSString *strURL = [NSString stringWithFormat:@"%@/movephotos",KHomeUrlDefault];
    return strURL;
}


+(NSString *)stringUrlUploadPhotos{
    NSString *strURL = [NSString stringWithFormat:@"%@/uploadphotos",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlDeleteAlbums:(int)aid{
    NSString *strURL = [NSString stringWithFormat:@"%@/delalbums?aid=%d&",KHomeUrlDefault,aid];
    strURL = [self addCommonParameter:strURL];
    
    return strURL;
}

+(NSString *)stringUrlGetBgMudic{
    NSString *strURL = [NSString stringWithFormat:@"%@/getbgmusic",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlSaveAppSetting{
    NSString *strURL = [NSString stringWithFormat:@"%@/saveappsetting",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlGetAppList{
    NSString *strURL = [NSString stringWithFormat:@"%@/getmyapplist?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}


+(NSString *)stringUrlGetUserinfo:(NSString *)strUid{
    NSString *strURL = [NSString stringWithFormat:@"%@/getuserinfo?otheruid=%@&",KHomeUrlDefault,strUid];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlUpdatePrice{
    NSString *strURL = [NSString stringWithFormat:@"%@/updateprice",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlUpdateProfile{
    NSString *strURL = [NSString stringWithFormat:@"%@/reg",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlSaveCard{
    NSString *strURL = [NSString stringWithFormat:@"%@/savecard",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlGetMyCardList{
    NSString *strURL = [NSString stringWithFormat:@"%@/getmycardlist?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}


+(NSString *)stringUrlDeleteCard{
    NSString *strURL = [NSString stringWithFormat:@"%@/deletecard?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    
    return strURL;
}

+(NSString *)stringUrlGetMerchantQueryInfo{
    NSString *strURL = [NSString stringWithFormat:@"%@/getmerchantqueryinfo?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetMerchantList:(int)iPage city:(NSString *)strCity area:(NSString *)strArea hotCity:(NSString *)strHotCity lat:(float)fLat lng:(float)fLng industry:(NSString *)strIndustry sort:(NSString *)strSort sname:(NSString *)strSname{
    NSString *strTmpCity = [strCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strTmpArea = [strArea stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strTmpHotCity = [strHotCity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strTmpIndustry = [strIndustry stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strTmpSort= [strSort stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *strTmpSname= [strSname stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *strURL = [NSString stringWithFormat:@"%@/getmerchantlist?start=%d&city=%@&area=%@&hotcity=%@&lat=%f&lng=%f&industry=%@&sort=%@&&sname=%@&",KHomeUrlDefault,iPage,strTmpCity,strTmpArea,strTmpHotCity,fLat,fLng,strTmpIndustry,strTmpSort,strTmpSname];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetMerchantDetail:(NSString *)strMid{
    NSString *strURL = [NSString stringWithFormat:@"%@/getmerchantdetail?mid=%@&",KHomeUrlDefault,strMid];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetTaskByMonth:(int)iYear month:(int)iMonth{
    NSString *strURL = [NSString stringWithFormat:@"%@/gettaskbymonth?year=%d&month=%d&",KHomeUrlDefault,iYear,iMonth];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlSetDate{
    NSString *strURL = [NSString stringWithFormat:@"%@/setdate",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlUpdatePass{
    NSString *strURL = [NSString stringWithFormat:@"%@/updatepass",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlMessageList:(int)catid iPage:(int)page{
    NSString *strURL = [NSString stringWithFormat:@"%@/msglist?start=%d&count=50&type=%d&",KHomeUrlDefault,page,catid];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlMessageDelete{
    NSString *strURL = [NSString stringWithFormat:@"%@/deletemsg",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlSetMfav{
    NSString *strURL = [NSString stringWithFormat:@"%@/setMfav",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlSendInvite{
    NSString *strURL = [NSString stringWithFormat:@"%@/sendinvite",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlGetUserMerchant:(int)status{
    NSString *strURL = [NSString stringWithFormat:@"%@/getUserMerchant?status=%d&",KHomeUrlDefault,status];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetUserFav{
    NSString *strURL = [NSString stringWithFormat:@"%@/getUserFav?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetTaskList{
    NSString *strURL = [NSString stringWithFormat:@"%@/gettasklist?start=0&count=10&",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlGetTaskDetailWithTaskId:(NSString *)strTaskId{
    NSString *strURL = [NSString stringWithFormat:@"%@/gettaskdetail?taskid=%@&",KHomeUrlDefault,strTaskId];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlTaskRefuse{
    NSString *strURL = [NSString stringWithFormat:@"%@/taskrefuse",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlPollMerchant{
    NSString *strURL = [NSString stringWithFormat:@"%@/pollmerchant",KHomeUrlDefault];
    return strURL;
}

+(NSString *)stringUrlCheckUid:(NSString *)uid{
    NSString *strURL = [NSString stringWithFormat:@"%@/getuidinfo?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}

+(NSString *)stringUrlCheckUMsg:(NSString *)uid{
    NSString *strURL = [NSString stringWithFormat:@"%@/getusermsg?",KHomeUrlDefault];
    strURL = [self addCommonParameter:strURL];
    return strURL;
}
@end
