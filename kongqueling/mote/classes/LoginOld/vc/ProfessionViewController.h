//
//  ProfessionViewController.h
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfessionViewController : UIViewController{


    UIButton *nextbtn;
    
    NSString *professStr;
    
    NSMutableArray *messArray;
    
    BOOL shoot;
    BOOL model;
    BOOL style;
    
    NSString *sheStr;
    NSString *moteStr;
    NSString *zaoStr;

    
}
-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;

@end
