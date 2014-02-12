//
//  TaskDetailViewController.h
//  mote
//
//  Created by sean on 1/23/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIScrollView *scrollviewInfo;
@property(nonatomic, strong) IBOutlet UIView *viewInfo;
@property(nonatomic, strong) NSString *strTaskId;

@property(nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property(nonatomic, strong) IBOutlet UILabel *labelTitle;
@property(nonatomic, strong) IBOutlet UILabel *labelDesc1;
@property(nonatomic, strong) IBOutlet UILabel *labelDesc2;

@property(nonatomic, strong) IBOutlet UILabel *labelNumber;
@property(nonatomic, strong) IBOutlet UILabel *labelPrice;

@property(nonatomic, strong) IBOutlet UILabel *labelTaskDetail;

@property(nonatomic, strong) IBOutlet UILabel *labelDate;

@property(nonatomic, strong) IBOutlet UILabel *labelLocation;

@property(nonatomic, strong) IBOutlet UIButton *buttonAddToCal;
@property(nonatomic, strong) IBOutlet UIButton *buttonRefuse;

@property(nonatomic, strong) IBOutlet UIButton *buttonZan;
@property(nonatomic, strong) IBOutlet UIButton *buttonCai;


@end
