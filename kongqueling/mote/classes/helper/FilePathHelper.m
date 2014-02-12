//
//  FilePathHelper.m
//  mote
//
//  Created by sean on 12/5/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "FilePathHelper.h"

@implementation FilePathHelper

+(NSString *)getDocPath{
    NSArray *arrPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *strDocPath = ([arrPaths count] > 0) ? [arrPaths objectAtIndex:0] : nil;
    
    return strDocPath;
}

@end
