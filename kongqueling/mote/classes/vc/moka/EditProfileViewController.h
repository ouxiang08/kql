//
//  EditProfileViewController.h
//  mote
//
//  Created by sean on 11/10/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProfileViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITextField *textFieldName;
@property(nonatomic, strong) IBOutlet UITextField *textFieldHeight;
@property(nonatomic, strong) IBOutlet UITextField *textFieldWeight;
@property(nonatomic, strong) IBOutlet UILabel *labelSanwei;
@property(nonatomic, strong) IBOutlet UIButton *buttonSanwei;

@property(nonatomic, strong) IBOutlet UILabel *labelNameBg;

@property(nonatomic, strong) UIImage *imageMoka;

@end
