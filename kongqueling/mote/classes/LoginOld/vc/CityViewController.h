//
//  CityViewController.h
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import <CoreLocation/CoreLocation.h>
#import "SBJSON.h"
@interface CityViewController : UIViewController<CLLocationManagerDelegate>{
    
    NSString *cityString;
    UIButton *nextbtn;
    UILabel *cityLabel;
    
    CLGeocoder * geoCoder;
    CLLocationManager *locationManager;
    
    NSMutableArray *messArray;
    
}

@property(nonatomic,copy)NSString *cityString;

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;

@end
