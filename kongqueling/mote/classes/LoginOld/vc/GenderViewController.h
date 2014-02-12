//
//  GenderViewController.h
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenderViewController : UIViewController{
    
    UIButton *nextbtn;
    
    NSString *genderStr;
    NSMutableArray *messArray;
    
}
-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;

@end
