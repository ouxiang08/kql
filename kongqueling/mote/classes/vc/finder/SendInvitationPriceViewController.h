//
//  SendInvitationPriceViewController.h
//  mote
//
//  Created by sean on 12/30/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

typedef enum{
    KQiPaiView = 0,
    KOtherView = 1
}DisplayType;


@protocol PriceModifiedDelegate <NSObject>

-(void)modifyPriceByDay:(NSString *)strPriceByDay byUnit:(NSString *)strPriceByUnit;
-(void)modifyPriceQipai:(NSString *)strQipai;

@end

@interface SendInvitationPriceViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIView *viewPriceUnit;
@property(nonatomic, strong) IBOutlet UIView *viewPriceQipai;

@property(nonatomic, strong) IBOutlet UITextField *textFieldQipai;
@property(nonatomic, strong) IBOutlet UITextField *textFieldByDay;
@property(nonatomic, strong) IBOutlet UITextField *textFieldByUnit;

@property(nonatomic, assign) id<PriceModifiedDelegate>delegate;
@property(nonatomic, assign) DisplayType iType;

@property(nonatomic, strong) NSString* strPriceQipai;
@property(nonatomic, strong) NSString* pPrice;
@property(nonatomic, strong) NSString* dPrice;
@end
