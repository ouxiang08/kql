//
//  SearchCityViewController.h
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AIMTableViewIndexBar.h"
#import "CityViewController.h"
@interface SearchCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AIMTableViewIndexBarDelegate>{

    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplay;
    
    UITableView * mytable;
    
    AIMTableViewIndexBar *indexBar;
    NSArray *sections;
    NSArray *rows;
    
    CityViewController *cityVC;

}
- (id)initWithVC:(CityViewController *)city;
@end
