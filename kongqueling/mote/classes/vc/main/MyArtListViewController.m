//
//  MyArtListViewController.m
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "AlbumModel.h"
#import "MakingAppViewController.h"
#import "DatabaseHelper.h"
#import "ChoosingPicturesViewController.h"
#import "MyArtListViewController.h"
#import "MyArtListTableViewCell.h"
#import "AlbumPhotoListViewController.h"
#import "ChoosingTemplateViewController.h"
#import "CreateAlbumViewController.h"
#import "PrepareUploadPhotoViewController.h"

@interface MyArtListViewController ()<UITableViewDataSource,UITableViewDelegate,UploadSuccessDelegate,DeleteAlbumDelegate>{
    NSMutableArray *_arrAlbum;
}

@end

@implementation MyArtListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的作品";
		self.tabBarItem.image = [UIImage imageNamed:@"moka_tabbar_art_normal_bg"];
        // Custom initialization
    }
    _arrAlbum = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([MainModel sharedObject].strUid) {
        [self getAlbumData];
    }
}

-(void)getAlbumData{
    NSString *strUrl = [UrlHelper stringUrlGetAlbums];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [self initArrayAlbum:(NSArray *)dictResponse];
    } andFailureBlock:^(NSError *error) {
        NSLog(@"err:%@",[error localizedDescription]);
    }];
}

-(void)initArrayAlbum:(NSArray *)arrAlbum{
    [_arrAlbum removeAllObjects];
    for (int i=0; i<arrAlbum.count; i++) {
        NSDictionary *dictItem = [arrAlbum objectAtIndex:i];
        AlbumModel *model = [[AlbumModel alloc] init];
        model.aid = [[dictItem valueForKey:@"id"] integerValue];
        model.strAlbumName = [dictItem valueForKey:@"name"];
        model.iPubFlag = [[dictItem valueForKey:@"pubflag"] integerValue];
        model.count = [[dictItem valueForKey:@"photocounts"] integerValue];
        model.strHomeImgPath = [dictItem valueForKey:@"homeImgPath"];
        [_arrAlbum addObject:model];
    }
    [self.tableViewArtList reloadData];
}


#pragma DeleteAlbum Delegate
-(void)deleteAlbum{
    [self getAlbumData];
}

#pragma mark - Button Event
-(IBAction)onUploadClick:(id)sender{
    ChoosingPicturesViewController *choosingPictureVC = [[ChoosingPicturesViewController alloc] init];
    choosingPictureVC.arrAlbum = _arrAlbum;
    AlbumModel *model = [_arrAlbum objectAtIndex:0];
    choosingPictureVC.labelAlbum.text = model.strAlbumName;
    choosingPictureVC.uploadDelegate = self;
    [self.navigationController pushViewController:choosingPictureVC animated:YES];
}

-(void)uploadSuccessWithModel:(AlbumModel *)model{
    [self getAlbumData];
    AlbumPhotoListViewController *photoVC = [[AlbumPhotoListViewController alloc] init];
    photoVC.model = model;
    [self.navigationController pushViewController:photoVC animated:YES];
}

-(IBAction)onCreateAlbumClick:(id)sender{
    CreateAlbumViewController *createAlbumVC = [[CreateAlbumViewController alloc] init];
    createAlbumVC.createAlbumDelegate = self;
    [self.navigationController pushViewController:createAlbumVC animated:YES];
}

-(IBAction)onMakeMokaClick:(id)sender{
    ChoosingTemplateViewController *chooseVC = [[ChoosingTemplateViewController alloc] init];
    [self.navigationController pushViewController:chooseVC animated:YES];
}

-(IBAction)onMakeAppClick:(id)sender{
    MakingAppViewController *makingAppVC = [[MakingAppViewController alloc] init];
    [self.navigationController pushViewController:makingAppVC animated:YES];
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrAlbum.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"MyArtListTableViewCell";
    
    MyArtListTableViewCell *contentCell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (contentCell == nil) {
        contentCell = [[MyArtListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    AlbumModel *model =  [_arrAlbum objectAtIndex:indexPath.row];
    if (model.iPubFlag == 1) {
        contentCell.labelOpenLevel.text = @"对所有人公开";
    }else{
        contentCell.labelOpenLevel.text = @"仅自己可见";
    }
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,model.strHomeImgPath];
    [contentCell.imageViewAlbumLogo setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    contentCell.imageViewAlbumLogo.contentMode = KimageShowMode;
    [contentCell.imageViewAlbumLogo setClipsToBounds:YES];

    contentCell.labelAlbumName.text = [NSString stringWithFormat:@"%@ ( %d )",model.strAlbumName,model.count] ;
    
    return contentCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumModel *model = [_arrAlbum objectAtIndex:indexPath.row];
    if (model.count==0) {
        PrepareUploadPhotoViewController *photoVC = [[PrepareUploadPhotoViewController alloc] init];
        photoVC.arrAlbum = _arrAlbum;
        photoVC.iDefaultAlbumSelectedIndex = indexPath.row;
        [self.navigationController pushViewController:photoVC animated:YES];
    }else{
        AlbumPhotoListViewController *photoVC = [[AlbumPhotoListViewController alloc] init];
        photoVC.model = [_arrAlbum objectAtIndex:indexPath.row];
        photoVC.iDefaultAlbumSelectedIndex = indexPath.row;
        photoVC.arrAlbum = _arrAlbum;
        photoVC.deleteAlbum = self;
        [self.navigationController pushViewController:photoVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
