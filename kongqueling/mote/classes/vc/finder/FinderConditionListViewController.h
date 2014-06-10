//
//  FinderConditionListViewController.h
//  mote
//
//  Created by sean on 12/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    kByArea = 0,
    kByIndustry =1,
    kBySort =2,
    kByGender = 3,
    kByCate = 4,
    kBySort2 =2
}ConditionType;

@protocol ConditionSelectedDelegate <NSObject>

@optional

-(void)selectWithArea:(NSString *)strArea isHotCity:(BOOL)isHotCity;
-(void)selectWithArea:(NSString *)strArea andCity:(NSString *)strCity isHotCity:(BOOL)isHotCity;
-(void)selectWithIndustry:(NSString *)strIndustry;
-(void)selectWithSort:(NSString *)strSort;
-(void)selectWithCity:(NSString *)strCity;

-(void)selectWithGender:(NSDictionary *)dict;
-(void)selectWithCate:(NSString *)strCate;

@end

@interface FinderConditionListViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITableView *tableViewCondition;
@property(nonatomic, assign) ConditionType type;
@property(nonatomic, assign) id<ConditionSelectedDelegate>delegate;

@end
