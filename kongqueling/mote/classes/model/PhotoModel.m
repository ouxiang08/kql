//
//  PhotoModel.m
//  mote
//
//  Created by sean on 12/8/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (id)initWithDictionary:(NSDictionary *) dict{
    self = [super init];
	_pid = [[dict valueForKey:@"id"] integerValue];
	_aid = [[dict valueForKey:@"aid"] integerValue];
	_name = [dict valueForKey:@"name"] ;
	_imgPath = [dict valueForKey:@"imgPath"] ;
	_ctime = [dict valueForKey:@"ctime"] ;
	_isChecked = [dict valueForKey:@"ischecked"] ;
	_datatime = [dict valueForKey:@"cdatatime"] ;
    
	return self;
}

@end
