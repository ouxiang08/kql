//
//  MokaLocation.h
//  mote
//
//  Created by sean on 12/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface MokaLocation : NSObject

@property(nonatomic, strong) CLLocationManager *locationManager;

-(void)startPostion;

@end
