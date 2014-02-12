//
//  MokaResultViewController.h
//  mote
//
//  Created by sean on 11/11/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MokaResultViewController : MokaNetworkController

@property(nonatomic, strong) UIView *container;
@property(nonatomic, strong) UIImageView *imageViewMokaResult;
@property(nonatomic, strong) UILabel *labelFirst;
@property(nonatomic, strong) UIImage *imageMoka;

@property(nonatomic, strong) NSString *strNameAndHeight;
@property(nonatomic, strong) NSString *strSanwei;


@end
