//
//  MoteConfig1.m
//  mote
//
//  Created by sean on 12/31/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MoteConfig.h"

@implementation MoteConfig


@end

NSURL* urlFromImageURLstr(NSString* serverImageURLString)
{
    if ( [serverImageURLString isKindOfClass: [NSString class]] ) {
        if (!serverImageURLString || !serverImageURLString.length) {
            return nil;
        }
        
        if ([serverImageURLString hasPrefix:@"http://"]) {
            return [NSURL  URLWithString:serverImageURLString];
        }
        
		if ([serverImageURLString hasPrefix:@"/"]) {
			return [NSURL  URLWithString:[NSString stringWithFormat:@"%@%@", KImageUrlDefault, serverImageURLString]];
		}else {
			return [NSURL  URLWithString:[NSString stringWithFormat:@"%@/%@", KImageUrlDefault, serverImageURLString]];
		}
    }
    
    return nil;
}
