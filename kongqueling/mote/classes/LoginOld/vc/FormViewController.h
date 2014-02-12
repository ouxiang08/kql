//
//  FormViewController.h
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController{


    NSString *formString;
    
    NSString *modeString;
    NSString *sheString;
    NSString *zaoString;
    
    UIButton *nextbtn;
    
    NSMutableArray *messArray;
    
    
    UIView *modeView;
    UIView *sheView;
    UIView *zaoView;
    
    NSArray *objrctArr;
    NSArray *sheObjArr;
     NSArray *zaoObjArr;
    
}
@property(nonatomic,copy)NSString *formString;
@property(nonatomic,copy)NSString *modeString;
@property(nonatomic,copy)NSString *sheString;
@property(nonatomic,copy)NSString *zaoString;
-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;

@end
