//
//  NickNameViewController.h
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NickNameViewController : UIViewController{

      UITextField *nameText;
      UIButton *nextbtn;
    
    NSMutableArray *messArray;
    
}
-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;

@end
