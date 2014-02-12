//
//  MyMerchantListViewController.h
//  mote
//
//  Created by sean on 12/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface MyMerchantListViewController : MokaNetworkController<UIAlertViewDelegate>

@property(nonatomic, strong) NSString *strMid;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollViewInfo;
@property (nonatomic, strong) IBOutlet UIView *viewInfo;

@property (nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UILabel *labelCity;
@property (nonatomic, strong) IBOutlet UIImageView *imageViewRate;

@property (nonatomic, strong) IBOutlet UILabel *labelWalkers;
@property (nonatomic, strong) IBOutlet UILabel *labelAddress;

@property (nonatomic, strong) IBOutlet UILabel *labelTel;
@property (nonatomic, strong) IBOutlet UILabel *labelPhone;
@property (nonatomic, strong) IBOutlet UILabel *labelEmail;
@property (nonatomic, strong) IBOutlet UILabel *labelIntro;

@property (weak, nonatomic) IBOutlet UIButton *btMemberD;
@property (weak, nonatomic) IBOutlet UIButton *btMemberM;
@property (weak, nonatomic) IBOutlet UIButton *btMemberP;
- (IBAction)clickMemberD:(id)sender;
- (IBAction)clickMemberM:(id)sender;
- (IBAction)clickMemberP:(id)sender;


@property (nonatomic, strong) IBOutlet UIButton *buttonSend;
@property (nonatomic, strong) IBOutlet UIButton *buttonSave;

- (IBAction)clickViewDetail:(id)sender;

@end
