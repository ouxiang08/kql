//
//  SelectFormViewController.h
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormViewController.h"
@interface SelectFormViewController : UIViewController{

 
    UIButton *finishbtn;
    NSArray *objrctArr;
    
    FormViewController *formVC;
}
- (id)initWithVC:(FormViewController *)formviewcontroller;
@end
