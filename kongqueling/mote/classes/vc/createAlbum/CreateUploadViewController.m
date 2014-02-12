//
//  CreateUploadViewController.m
//  mote
//
//  Created by sean on 11/21/13.
//  Copyright (c) 2013 zlm. All rights reserved.

#import "CreateUploadViewController.h"
#import "MokaTabBarViewController.h"

@interface CreateUploadViewController ()

@end

@implementation CreateUploadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Button Click
-(IBAction)onCreateAlbum:(id)sender{

    NSString *strAlbum = [UrlHelper stringUrlSetAlbum];
    NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
    
    [dicParameter setObject:@"myAlbum" forKey:@"name"];
    [dicParameter setObject:@"pubflag" forKey:@"1"];
    
    [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
        NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
        if (errorNo == 1) {
            MokaTabBarViewController *mokaTabBarVC = [[MokaTabBarViewController alloc] init];
            [self.navigationController pushViewController:mokaTabBarVC animated:YES];
           
        }
    } andFailureBlock:^(NSError *error) {
        
    }];
}

-(IBAction)onUploadPicture:(id)sender{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
