//
//  GirlModel.h
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GirlModel : NSObject

@property(nonatomic, assign) int uid;
@property(nonatomic, strong) NSString *nickName;
@property(nonatomic, strong) NSString *gender;
@property(nonatomic, strong) NSString *city;
@property(nonatomic, strong) NSString *subtype;
@property(nonatomic, strong) NSString *height;
@property(nonatomic, strong) NSString *weight;
@property(nonatomic, strong) NSString *cate;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, assign) int age;
@property(nonatomic, strong) NSString *avatarPath;
@property(nonatomic, assign) int isVip;



- (id)initWithDictionary:(NSDictionary *) dict;

@end
