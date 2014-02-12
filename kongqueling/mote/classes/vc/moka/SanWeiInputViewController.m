//
//  SanWeiInputViewController.m
//  mote
//
//  Created by sean on 1/2/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "SanWeiInputViewController.h"

@interface SanWeiInputViewController ()

@end

@implementation SanWeiInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.bUpload = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;
    self.title = @"输入三围";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"完成" selector:@selector(onFinish) target:self];
    
    NSString *sw = [[MainModel sharedObject].dictUserInfo valueForKey:@"bodysize"];
    NSArray *t = [sw componentsSeparatedByString:@"-"];
    if ([t count]>0) {
        self.textFieldX.text = [t objectAtIndex:0];
    }
    if ([t count]>1) {
        self.textFieldY.text = [t objectAtIndex:1];
    }
    if ([t count]>2) {
        self.textFieldT.text = [t objectAtIndex:2];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)onFinish{
    if ([self.textFieldX.text isNotNilOrBlankString]&&[self.textFieldY.text isNotNilOrBlankString]&&[self.textFieldT.text isNotNilOrBlankString]) {
        NSString *strResult = [NSString stringWithFormat:@"%@-%@-%@",self.textFieldX.text,self.textFieldY.text,self.textFieldT.text];
        
        if (self.bUpload) {
            NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
            [dictParameter setObject:strResult forKey:@"value"];
            [dictParameter setObject:@"bodysize" forKey:@"key"];
			
		    NSString *strUrl = [UrlHelper stringUrlUpdateProfile];
            [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
                self.maskView.hidden = YES;
                [self.delegate inputWith:strResult];
                [self.navigationController popViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } andFailureBlock:^(NSError *error) {
                NSLog(@"failed");
                self.maskView.hidden = YES;
            }];
        }else{
            [self.delegate inputWith:strResult];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
