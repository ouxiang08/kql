//
//  MakingMokaViewController.h
//  mote
//
//  Created by sean on 11/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakingMokaViewController : UIViewController

@property(nonatomic, strong) IBOutlet UIView *viewMokaCenter;

@property(nonatomic, strong) NSMutableArray *arrImageView;
@property(nonatomic, strong) NSArray *arrImage;
@property(nonatomic, strong) NSDictionary *dicMoka;
@property(nonatomic,strong) UIImageView *imageViewStart;
@property(nonatomic,strong) UIImageView *imageViewEnd;
@property(nonatomic, strong) NSString *strMokaBgUrl;

@end
