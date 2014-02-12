//
//  ChoosingArtPrivateViewController.h
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseArtPrivateDelegate <NSObject>

-(void)chooseArtLevelWithText:(NSString *)strText pubFlag:(int)iPubFlag;

@end

@interface ChoosingArtPrivateViewController : UIViewController

@property(nonatomic,assign) id<ChooseArtPrivateDelegate>choosePrivateDelegate;

-(IBAction)onOpenClick:(id)sender;

-(IBAction)onPrivateClick:(id)sender;

@end
