//
//  MainModel.m
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MainModel.h"

@implementation MainModel

#pragma mark instance
static MainModel *sharedListInstance = nil;

+ (MainModel*)sharedObject {
    // double check will improve performance
    if (nil == sharedListInstance) {
        @synchronized(self) {
            if (sharedListInstance == nil) {
                sharedListInstance = [[self alloc] init]; //assignment not done here
            }
        }
    }
    
	return sharedListInstance;
}

- (void) startPosition{
    if (!self.location) {
        self.location = [[MokaLocation alloc] init];
    }
    [self.location startPostion];
}

- (void) saveLocation: (CLLocation *)location{
    self.currentLocation = location;
    
//    [[NSUserDefaults standardUserDefaults] setObject: self.currentLocation  forKey:KLocation];
//	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) saveCity: (NSString *)strCity{
    NSString *strCityShi = [NSString stringWithFormat:@"%@市",strCity];
    self.strCity = strCityShi;
    [[NSUserDefaults standardUserDefaults] setObject: self.strCity  forKey:KCity];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strCity{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KCity];
}

- (void) saveUid: (NSString *)strUid{
    self.strUid = strUid;
    
    [[NSUserDefaults standardUserDefaults] setObject: strUid  forKey:KUid];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KUid];
}

- (void) saveNickName: (NSString *)strNickName{
    self.strNickName = strNickName;
    
    [[NSUserDefaults standardUserDefaults] setObject: strNickName  forKey:KNickName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strNickName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KNickName];
}

- (void) saveBDUid: (NSString *)strBDUid{
    self.strBDUid = strBDUid;
    
    [[NSUserDefaults standardUserDefaults] setObject: strBDUid  forKey:KBDUid];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strBDUid{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KBDUid];
}

- (void) saveBDChannelId: (NSString *)strBDChannelId{
    self.strBDChannelId = strBDChannelId;
    
    [[NSUserDefaults standardUserDefaults] setObject: strBDChannelId  forKey:KBDChannelId];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strBDChannelId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KBDChannelId];
}


- (void) saveUserName: (NSString *)strUserName{
    self.strUserName = strUserName;
    
    [[NSUserDefaults standardUserDefaults] setObject: strUserName  forKey:KUserName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
}

- (void) savePassword: (NSString *)strPassword{
    self.strPassword = strPassword;
    
    [[NSUserDefaults standardUserDefaults] setObject: strPassword  forKey:KPassword];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strPassword{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KPassword];
}

- (void) saveUserType: (NSString *)strUserType{
    self.strUserType = strUserType;
    
    [[NSUserDefaults standardUserDefaults] setObject: strUserType  forKey:KUserType];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)strUserType{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KUserType];
}


- (void) saveDictUserInfo: (NSDictionary *)dictUserInfo{
    self.dictUserInfo = dictUserInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject: dictUserInfo  forKey:KDictUserInfo];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)dictUserInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KDictUserInfo];
}


- (void) savePriceInfo: (NSArray *)arrPriceInfo{
    self.arrPriceInfo = arrPriceInfo;
    
    [[NSUserDefaults standardUserDefaults] setObject: arrPriceInfo  forKey:KPriceInfo];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)arrPriceInfo{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KPriceInfo];
}

- (void) saveAlbumId: (NSString *)strAlbumId{
    self.strAlbumId = strAlbumId;
    [[NSUserDefaults standardUserDefaults] setObject: strAlbumId  forKey:KAlbumId];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


@end
