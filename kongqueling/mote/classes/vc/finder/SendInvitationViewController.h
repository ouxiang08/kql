//
//  SendInvitationViewController.h
//  mote
//
//  Created by meikai on 13-12-26.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

typedef enum {
    KModelQipai = 1,
    KModelPengPai = 2,
    KModelWaiPai = 3,
    KModelNeiyi = 4,
    KShePengPai = 5,
    KSheWaiPai = 6,
    KZaoPengPai = 7,
    KZaoWaiPai = 8
}PriceType;

@protocol SendInvitationDelegate <NSObject>

-(void)sendSucess;

@end

@interface SendInvitationViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UIView *viewModel;
@property(nonatomic, strong) IBOutlet UIView *viewShe;
@property(nonatomic, strong) IBOutlet UIView *viewZao;

@property(nonatomic, strong) IBOutlet UILabel *labelModelQipai;
@property(nonatomic, strong) IBOutlet UILabel *labelModelPengpai;
@property(nonatomic, strong) IBOutlet UILabel *labelModelWaipai;
@property(nonatomic, strong) IBOutlet UILabel *labelModelNeiyi;
@property(nonatomic, strong) IBOutlet UILabel *labelShePengpai;
@property(nonatomic, strong) IBOutlet UILabel *labelSheWaipai;
@property(nonatomic, strong) IBOutlet UILabel *labelZaoPengpai;
@property(nonatomic, strong) IBOutlet UILabel *labelZaoWaipai;

@property(nonatomic, assign) id<SendInvitationDelegate>delegate;


@property(nonatomic, strong) NSString *strMid;
@property(nonatomic, assign) PriceType iType;
@property(nonatomic, strong) IBOutlet UIScrollView *scrollViewInvitation;

@end
