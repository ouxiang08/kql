//
//  PersonalCenterViewController.h
//  mote
//
//  Created by sean on 12/18/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ModifyLogoDelegate <NSObject>

-(void)modifyLogoWithUrl:(NSString *)strUrl;
-(void)findMerchant;

@end

@interface PersonalCenterViewController : MokaNetworkController<UIActionSheetDelegate>

@property(nonatomic, strong) IBOutlet UIScrollView *scrollViewContent;
@property (strong, nonatomic) IBOutlet UIButton *buttonLogo;
@property(nonatomic, strong) IBOutlet UIImageView *imageViewLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblNickname;
@property (weak, nonatomic) IBOutlet UIImageView *imgviewGender;
@property (weak, nonatomic) IBOutlet UILabel *lblJob;
@property(nonatomic, strong) IBOutlet UILabel *labelName;

@property(nonatomic, strong) IBOutlet UIView *viewTop;
@property(nonatomic, strong) IBOutlet UIView *viewTag;
@property(nonatomic, strong) IBOutlet UIView *viewMote;
@property(nonatomic, strong) IBOutlet UIView *viewShe;
@property(nonatomic, strong) IBOutlet UIView *viewZao;
@property(nonatomic, strong) IBOutlet UIView *viewContact;
@property(nonatomic, strong) IBOutlet UIView *viewGender;
@property(nonatomic, strong) IBOutlet UIView *viewHeight;

@property(nonatomic, assign) id<ModifyLogoDelegate>delegate;

@end
