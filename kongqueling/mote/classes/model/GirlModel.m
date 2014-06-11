//
//  GirlModel.m
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "GirlModel.h"

@implementation GirlModel

- (id)initWithDictionary:(NSDictionary *) dict{
    self = [super init];
	_uid = [[dict valueForKey:@"id"] integerValue];
	_nickName = [dict valueForKey:@"nickname"] ;
	_gender = [dict valueForKey:@"gender"] ;
	_city = [dict valueForKey:@"city"] ;
	_subtype = [dict valueForKey:@"subtype"] ;
	_height = [dict valueForKey:@"height"] ;
    _weight = [dict valueForKey:@"weight"] ;
    _cate = [dict valueForKey:@"cate"] ;
    _price = [dict valueForKey:@"price"] ;
    _age = [[dict valueForKey:@"age"] integerValue] ;
    _avatarPath = [dict valueForKey:@"avatar"] ;
    _isVip = [[dict valueForKey:@"isvip"] integerValue];
    
	return self;
}

@end
