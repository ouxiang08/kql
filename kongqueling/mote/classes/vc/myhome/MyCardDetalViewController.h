//
//  MyCardDetalViewController.h
//  mote
//
//  Created by harry on 14-1-23.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "MokaNetworkController.h"

@interface MyCardDetalViewController : MokaNetworkController<UIActionSheetDelegate>
@property(nonatomic, strong) NSDictionary *cardInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMoka;

@end
