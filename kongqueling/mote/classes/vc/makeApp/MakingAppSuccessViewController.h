//
//  MakingAppSuccessViewController.h
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MakingAppSuccessViewController : UIViewController<UIWebViewDelegate>

- (IBAction)clickInstall:(id)sender;
- (IBAction)clickShare:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgvIcon;

@property (weak, nonatomic) IBOutlet UILabel *appname;
@property (strong, nonatomic) NSString *iosDownloadUrl;
@property (strong, nonatomic) NSString *allDownloadUrl;
@property (strong, nonatomic) NSString *imgapth;
@property (strong, nonatomic) NSString *apptitle;
@end
