//
//  NSMutableDictionaryFactory.m
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "NSMutableDictionaryFactory.h"

@implementation NSMutableDictionaryFactory

+(NSMutableDictionary *)getMutableDictionary{
    long time=(long)[[NSDate date] timeIntervalSince1970];
    NSString *strTime = [NSString stringWithFormat:@"%ld",time];
    NSString *strUid = [MainModel sharedObject].strUid;
    NSString *strValidate = [NSString stringWithFormat:@"%@%@picspai",strUid,strTime];
    strValidate = [UrlHelper getMD5String:strValidate];
    
    NSMutableDictionary *dicParameter = [[NSMutableDictionary alloc] init];
    [dicParameter setObject:strTime forKey:@"time"];
    [dicParameter setObject:[MainModel sharedObject].strUid forKey:@"uid"];
    [dicParameter setObject:strValidate forKey:@"validate"];

    return dicParameter;
}

@end
