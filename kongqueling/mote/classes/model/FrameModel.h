//
//  FrameModel.h
//  mote
//
//  Created by sean on 11/10/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameModel : NSObject

- (id)initWithDictionary:(NSDictionary *) dict;

@property(nonatomic,assign) CGFloat x;
@property(nonatomic,assign) CGFloat y;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;


@end
