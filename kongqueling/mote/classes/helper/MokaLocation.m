//
//  MokaLocation.m
//  mote
//
//  Created by sean on 12/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaLocation.h"

@interface MokaLocation ()<CLLocationManagerDelegate>

@end

@implementation MokaLocation


-(void)startPostion{
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init] ;
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=1000.0f; //启动位置更新
        [self.locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    [[MainModel sharedObject] saveLocation:currentLocation];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks,NSError *error){
        
        CLPlacemark *placemark=[placemarks objectAtIndex:0];
        
        NSString *myCity = placemark.locality;
        NSString *myArea = placemark.administrativeArea;
        NSString *strCity;
        
        if (myCity==nil) {
            strCity = [myArea stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        else{
            strCity = [myCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
         [[MainModel sharedObject] saveCity:strCity];
        
    }];

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
}


@end
