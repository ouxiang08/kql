//
//  PrepareUploadPhotoViewController.m
//  mote
//
//  Created by harry on 13-12-27.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "AlbumPhotoListViewController.h"
#import "PrepareUploadPhotoViewController.h"

@interface PrepareUploadPhotoViewController ()<UploadSuccessDelegate>

@end

@implementation PrepareUploadPhotoViewController

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
    self.title = @"作品上传";
    self.view.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;
    // Do any additional setup after loading the view from its nib.
    
    UIImage *imgTop=[UIImage imageNamed:@"add_photo_samplephoto"];
    UIImageView *imageViewTop = [[UIImageView alloc] initWithFrame:CGRectMake((320-imgTop.size.width)/2, 50, imgTop.size.width, imgTop.size.height)];
    imageViewTop.image=imgTop;
    [self.view addSubview:imageViewTop];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)uploadSuccessWithModel:(AlbumModel *)model{
    UINavigationController *nav = self.navigationController;
    [nav popViewControllerAnimated:NO];
    
    AlbumPhotoListViewController *photoVC = [[AlbumPhotoListViewController alloc] init];
    photoVC.model = model;
    [nav pushViewController:photoVC animated:YES];
    
}

- (IBAction)clickAddPhoto:(id)sender {
    
    ChoosingPicturesViewController *choosingPictureVC = [[ChoosingPicturesViewController alloc] initWithNibName:@"ChoosingPicturesViewController" bundle:nil];
    choosingPictureVC.arrAlbum = _arrAlbum;
    choosingPictureVC.uploadDelegate = self;
    //AlbumModel *model = [_arrAlbum objectAtIndex:_iDefaultAlbumSelectedIndex];
    choosingPictureVC.iDefaultAlbumSelectedIndex = _iDefaultAlbumSelectedIndex;
    //choosingPictureVC.uploadDelegate = self;
    [self.navigationController pushViewController:choosingPictureVC animated:YES];
}
@end
