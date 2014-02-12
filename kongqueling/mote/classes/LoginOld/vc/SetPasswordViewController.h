//
//  SetPasswordViewController.h
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetPasswordViewController : UIViewController{

    UIButton *nextbtn;
    
    UITextField *passText;
    UITextField *againpassText;

    NSMutableArray *messArray;

}
-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;
@end
