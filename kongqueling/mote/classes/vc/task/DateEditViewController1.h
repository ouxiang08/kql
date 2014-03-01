//
//  DateEditViewController1.h
//  mote
//
//  Created by 贾程阳 on 28/2/14.
//  Copyright (c) 2014年 zlm. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol SetDateDelegate <NSObject>

@optional
-(void)setDateSuccess;
-(void)onClickDateWithArrTaskInfo:(NSArray *)arrTaskInfo;

@end

@interface DateEditViewController1 : MokaNetworkController

@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UIButton *buttonFront;
@property(nonatomic, strong) IBOutlet UIButton *buttonNext;
@property(nonatomic, strong) IBOutlet UIButton *buttonBackToNow;
@property(nonatomic, strong) IBOutlet UIView *viewDate;
@property(nonatomic, assign) BOOL bIsBtnClicked;
@property(nonatomic, assign) BOOL bIsBtnTaskDateClicked;
@property(nonatomic, assign) id<SetDateDelegate>delegate;

@property(nonatomic, strong) NSDate *currentDate;

-(void)saveDate;
-(IBAction)onBackToNowClick:(id)sender;

- (id) initWithDate: (NSDate *)date;

@end
