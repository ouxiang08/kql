//
//  UtilityHelper.m
//  mote
//
//  Created by sean on 12/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "UtilityHelper.h"

@implementation UtilityHelper

+(BOOL)isValidateEmail:(NSString *)strEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:strEmail];
}

@end
