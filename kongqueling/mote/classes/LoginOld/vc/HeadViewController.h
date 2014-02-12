//
//  HeadViewController.h
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJSON.h"
#import "UpYun.h"
@interface HeadViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>{

    UIImageView *headImage;
    
    BOOL isfinish;
    NSString *imagStr;
    //NSData * imgdata;
    
    NSMutableArray *messArray;
    
}
-(id)initWithTheMessArray:(NSMutableArray *)MessageArr;
@end
