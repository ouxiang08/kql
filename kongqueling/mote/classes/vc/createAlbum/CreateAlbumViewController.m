//
//  CreateAlbumViewController.m
//  mote
//
//  Created by sean on 11/22/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "CreateAlbumViewController.h"
#import "ChoosingPicturesViewController.h"
#import "ChoosingArtPrivateViewController.h"

@interface CreateAlbumViewController ()<ChooseArtPrivateDelegate>{
    int _iPubFlag;
}

@end

@implementation CreateAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    self.bModify = NO;
    _iPubFlag = 1;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (_bModify) {
        self.title = @"修改作品集";
    }else{
         self.title = @"新建作品集";
    }
    
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"保存" selector:@selector(saveAlbum) target:self];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - ChooseArtPrivateDelegate
-(void)chooseArtLevelWithText:(NSString *)strText pubFlag:(int)iPubFlag{
    self.labelPrivate.text = strText;
    _iPubFlag = iPubFlag;
}

-(void)saveAlbum{
    if (![self.textFieldAlbumName.text isEqualToString:@""]) {
        [self.textFieldAlbumName resignFirstResponder];
        NSString *strAlbum = [UrlHelper stringUrlSetAlbum];
        
        NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
        
        [dicParameter setObject:self.textFieldAlbumName.text forKey:@"name"];
        [dicParameter setObject:[NSNumber numberWithInt:_iPubFlag ] forKey:@"pubflag"];
        if(self.bModify) {
            [dicParameter setObject:self.strAid forKey:@"aid"];
        }
        [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
            NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
            
            if (errorNo == 1) {
                AlbumModel *model = [[AlbumModel alloc] init];
                model.aid = [[dictResponse valueForKey:@"msg"] integerValue];
                model.strAlbumName = self.textFieldAlbumName.text;
                model.iPubFlag = _iPubFlag;
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } andFailureBlock:^(NSError *error) {
            
        }];
    }else{
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"作品名称不能为空!"];
    }
}

-(IBAction)onChoosePrivate:(id)sender{
    ChoosingArtPrivateViewController *choosePrivateVC = [[ChoosingArtPrivateViewController alloc] init];
    choosePrivateVC.choosePrivateDelegate = self;
    [self.navigationController pushViewController:choosePrivateVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
