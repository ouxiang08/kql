//
//  PhotoModel.h
//  mote
//
//  Created by sean on 12/8/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel : NSObject

@property(nonatomic, assign) int pid;
@property(nonatomic, assign) int aid;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *imgPath;
@property(nonatomic, strong) NSString *ctime;
@property(nonatomic, strong) NSString *isChecked;
@property(nonatomic, strong) NSString *datatime;

- (id)initWithDictionary:(NSDictionary *) dict;

@end
