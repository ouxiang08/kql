//
//  DateViewController.h
//  mote
//
//  Created by sean on 12/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetDateDelegate <NSObject>

@optional
-(void)setDateSuccess;
-(void)onClickDateWithArrTaskInfo:(NSArray *)arrTaskInfo;

@end

@interface DateViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UIButton *buttonFront;
@property(nonatomic, strong) IBOutlet UIButton *buttonNext;
@property(nonatomic, strong) IBOutlet UIButton *buttonBackToNow;
@property(nonatomic, strong) IBOutlet UIView *viewDate;
@property(nonatomic, assign) BOOL bIsBtnClicked;
@property(nonatomic, assign) BOOL bIsBtnTaskDateClicked;
@property(nonatomic, assign) id<SetDateDelegate>delegate;

-(void)saveDate;
-(IBAction)onBackToNowClick:(id)sender;

@end
