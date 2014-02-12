//
//  FrameModel.m
//  mote
//
//  Created by sean on 11/10/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "FrameModel.h"

@implementation FrameModel

- (id)initWithDictionary:(NSDictionary *)dict
{
	
    self = [super init];
	self.x = [[dict objectForKey:@"x"] floatValue];
    self.y = [[dict objectForKey:@"y"] floatValue];
    self.width = [[dict objectForKey:@"width"] floatValue];
    self.height = [[dict objectForKey:@"height"] floatValue];
	return self;
}

@end
