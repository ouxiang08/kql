//
//  CityViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "CityViewController.h"
#import "FormViewController.h"
#import "SearchCityViewController.h"

@interface CityViewController ()

@end

@implementation CityViewController
@synthesize cityString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr{
    
    messArray=MessageArr;
    return self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    //if (![self.cityString isEqualToString:@""]) {
        cityLabel.text=[NSString stringWithFormat:@"常驻城市：%@",self.cityString];
        nextbtn.enabled=YES;
        [nextbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [nextbtn setBackgroundImage:[UIImage imageNamed:@"complete-0.png"] forState:UIControlStateNormal];
    //}
    
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
	self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    self.title = @"定位城市(6/6)";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete-0" selector:@selector(nextToFinishYourInformation) target:self];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"定位城市" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
    UIImageView *subimg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 300, 110)];
    subimg.image=[UIImage imageNamed:@"88888_03.png"];
    [self.view addSubview:subimg];
    
    cityLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 25, 130, 40)];
    cityLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    cityLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview:cityLabel];
    
    cityString=@"";
    locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    locationManager.distanceFilter=1000.0f; //启动位置更新
    [locationManager startUpdatingLocation];
    NSLog(@"latitude %f",locationManager.location.coordinate.latitude);
    NSLog(@"longitude %f",locationManager.location.coordinate.longitude);

    UIButton *selectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectbtn.frame=CGRectMake(155,32, 18, 20);
    [selectbtn setBackgroundImage:[UIImage imageNamed:@"6754321_03.png"] forState:UIControlStateNormal];
    [selectbtn addTarget:self action:@selector(selectTheCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectbtn];

    UIButton *morebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    morebtn.frame=CGRectMake(25,85, 270, 35);
    [morebtn setBackgroundImage:[UIImage imageNamed:@"6754321_07.png"] forState:UIControlStateNormal];
    [morebtn addTarget:self action:@selector(prefectTheInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:morebtn];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
//    CLLocation *current=[[CLLocation alloc] initWithLatitude:31.22001 longitude:121.48001];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error){
        
        CLPlacemark *placemark=[placemarks objectAtIndex:0];
        
        NSString *myCity = placemark.locality;
        NSString *myArea = placemark.administrativeArea;
        
        NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n",placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.subThoroughfare, placemark.subLocality, placemark.postalCode);
        if (myCity==nil) {
            cityString = [myArea stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        else{
            cityString = [myCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
        }
        NSLog(@"myCity is %@",myCity);
        NSLog(@"myArea is %@",myArea);
        
        NSLog(@"cityStr is %@",cityString);
        cityLabel.text=[NSString stringWithFormat:@"常驻城市：%@",cityString];
        
    }];



}


-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)postData{
    if (![cityString isEqualToString:@""]) {
        if ([messArray count]<6) {
            [messArray addObject:cityString];
        }
        else{
            [messArray removeObjectAtIndex:[messArray count]-1];
            [messArray addObject:cityString];
        }
    }
    else{
        cityString=@"无";
        if ([messArray count]<6) {
            [messArray addObject:cityString];
        }
        else{
            [messArray removeObjectAtIndex:[messArray count]-1];
            [messArray addObject:cityString];
        }
        
    }
    //[messArray replaceObjectAtIndex:5 withObject:cityString];
    NSLog(@"-----%d",[messArray count]);
    NSString *phoneStr=[messArray objectAtIndex:0];
    NSString *invitStr=[messArray objectAtIndex:1];
    NSString *passStr=[messArray objectAtIndex:2];
    NSString *genderStr=[messArray objectAtIndex:4];
    NSString *jobcatStr=[messArray objectAtIndex:3];
    NSString *locationStr=[messArray objectAtIndex:5];
    
    NSLog(@"phoneStr is %@",phoneStr);
    NSLog(@"invitStr is %@",invitStr);
    NSLog(@"passStr is %@",passStr);
    NSLog(@"genderStr is %@",genderStr);
    NSLog(@"jobcatStr is %@",jobcatStr);
    NSLog(@"locationStr is %@",locationStr);
    
    //第一步，创建URL
    NSString *requsturl = [NSString stringWithFormat:@"%@/reg",KHomeUrlDefault];
    NSURL *url = [NSURL URLWithString:requsturl];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"key=mobile,invit,password,gender,usertype,location&value=%@,%@,%@,%@,%@,%@",phoneStr,invitStr,passStr,genderStr,jobcatStr,locationStr];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"key=mobile,invit,password,gender,job-catid,location&value=%@,%@,%@,%@,%@,%@",phoneStr,invitStr,passStr,genderStr,jobcatStr,locationStr);
    
    NSError *error = nil;
    SBJSON *parsermsg = [[SBJSON alloc] init];
    NSDictionary *roDic = [parsermsg objectWithString:jsonStr error:&error];
    NSLog(@"roDic is %@",roDic);
    NSString *resultstr=[roDic valueForKey:@"msg"];
    NSLog(@"resultstr is %@",resultstr);
    
    [[MainModel sharedObject] saveUid:resultstr];
}

-(void)nextToFinishYourInformation{
    
    [self postData];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

-(void)selectTheCity{
    SearchCityViewController *selectformVC=[[SearchCityViewController alloc] initWithVC:self];
    [self presentViewController:selectformVC animated:YES completion:^(void){}];
    
}

-(void)prefectTheInformation{
    [messArray addObject:cityString];
    NSLog(@"-----%d",[messArray count]);
    [self postData];
    FormViewController *formVC=[[FormViewController alloc] initWithTheMessArray:messArray];
    [self.navigationController pushViewController:formVC animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
