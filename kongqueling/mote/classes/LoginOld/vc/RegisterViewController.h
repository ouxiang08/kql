//
//  RegisterViewController.h
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
@interface RegisterViewController : UIViewController{
    
    
    
    UITextField *userText;
    UITextField *passText;
    
     UIButton *nextbtn;

}
@property(nonatomic,retain)UITextField *userText;
@property(nonatomic,retain)UITextField *passText;
@property(nonatomic,assign)int gocounter;
@end
