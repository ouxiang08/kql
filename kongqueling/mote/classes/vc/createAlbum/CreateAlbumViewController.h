//
//  CreateAlbumViewController.h
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateAlbumDelegate <NSObject>

-(void)updateAlbumDatabase;

@end

@interface CreateAlbumViewController : MokaNetworkController

@property(nonatomic, strong) IBOutlet UITextField *textFieldAlbumName;
@property(nonatomic, strong) IBOutlet UIButton *buttonChoosePrivate;
@property(nonatomic, strong) IBOutlet UILabel *labelPrivate;
@property(nonatomic, assign) BOOL bModify;
@property(nonatomic, strong) NSString *strAid;
@property(nonatomic, strong) id<CreateAlbumDelegate>createAlbumDelegate;

-(IBAction)onChoosePrivate:(id)sender;

@end
