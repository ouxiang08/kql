//
//  SanWeiInputViewController.h
//  mote
//
//  Created by sean on 1/2/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputFinishDelegate <NSObject>

-(void)inputWith:(NSString *)str;

@end

@interface SanWeiInputViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITextField *textFieldX;
@property(nonatomic, strong) IBOutlet UITextField *textFieldY;
@property(nonatomic, strong) IBOutlet UITextField *textFieldT;
@property(nonatomic, assign) BOOL bUpload;
@property(nonatomic, assign) id<InputFinishDelegate>delegate;
@property(nonatomic, strong) NSDictionary* baseinfo;
@end
