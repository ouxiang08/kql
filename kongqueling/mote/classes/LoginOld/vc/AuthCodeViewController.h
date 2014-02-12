//
//  AuthCodeViewController.h
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
@interface AuthCodeViewController : UIViewController{

    UIButton *nextbtn;
    NSString *phoneStr;
    
    UITextField *codeText;
    
    UIButton *againbtn;
    NSMutableArray *messArray;
}
@property (nonatomic,assign) int needCounter;
@property (nonatomic,strong) NSString* invitecode;
-(id)initWithThePhoneNumber:(NSString *)PhoneNumber;
@end
