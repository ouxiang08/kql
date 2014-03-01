//
//  AlbumPhotoListViewController.m
//  mote
//
//  Created by sean on 11/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PhotoModel.h"
#import "AlbumPhotoCell.h"
#import "AlbumPhotoListViewController.h"
#import "AlbumPhotoViewController.h"
#import "AlbumPhotoViewController1.h"
#import "UIBarButtonItemFactory.h"
#import "ChoosingPicturesViewController.h"
#import "CreateAlbumViewController.h"
#import "PrepareUploadPhotoViewController.h"
#import "ChoosingAlbumViewController.h"

@interface AlbumPhotoListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,AlbumPhotoSelecedDelegate,UIActionSheetDelegate,DeletePictureDelegate,ChoosingAlbumDelegate>{
    NSMutableArray *_arrPhoto;
    NSMutableArray *_arrSelectedPicture;
    int _iSelectedIndex;
    BOOL _bEdit;
}

@end

@implementation AlbumPhotoListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _arrPhoto = [[NSMutableArray alloc] init];
    _arrSelectedPicture = [[NSMutableArray alloc] init];
    _bEdit = NO;
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"作品集";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"moka_picture_edit" selector:@selector(onEditPicture) target:self];
    self.viewEdit.hidden = YES;
    
}

#pragma mark - choose Album Delegate
-(void)choosingAlbumAtIndex:(int)iSelectedIndex{
    _iSelectedIndex = iSelectedIndex;
    AlbumModel *model = [self.arrAlbum objectAtIndex:iSelectedIndex];
    NSString *strMsg = [NSString stringWithFormat:@"确定移动到%@?",model.strAlbumName];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:strMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        AlbumModel *model = [self.arrAlbum objectAtIndex:_iSelectedIndex];
        NSString *strPids = @"";
        for (NSString *str in _arrSelectedPicture) {
            PhotoModel *model = [_arrPhoto objectAtIndex:[str integerValue]];
            if (str != [_arrSelectedPicture lastObject]) {
                strPids = [strPids stringByAppendingFormat:@"%d,",model.pid];
            }else{
                strPids = [strPids stringByAppendingFormat:@"%d",model.pid];
            }
        }
        
        NSString *strUrl = [UrlHelper stringUrlMovePhotos];
        NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
        [dictParameter setObject:[NSString stringWithFormat:@"%d",model.aid] forKey:@"aid"];
        [dictParameter setObject:strPids forKey:@"pids"];
        
        [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
            self.maskView.hidden = YES;
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            self.model.count -= _arrSelectedPicture.count;
            
            if (self.model.count == 0) {
                PrepareUploadPhotoViewController *photoVC = [[PrepareUploadPhotoViewController alloc] init];
                photoVC.arrAlbum = _arrAlbum;
                [nav pushViewController:photoVC animated:NO];
            }else{
                AlbumPhotoListViewController *albumVC = [[AlbumPhotoListViewController alloc] init];
                albumVC.model = self.model;
                [nav pushViewController:albumVC animated:NO];
            }
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"删除照片成功！"];
        } andFailureBlock:^(NSError *error) {
            self.maskView.hidden = YES;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadPicture];
}

-(void)loadPicture{
    [_arrPhoto removeAllObjects];
    NSString *strUrl = [UrlHelper stringUrlGetAlbumPhotos:[NSString stringWithFormat:@"%d",self.model.aid]];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        NSArray *tempPhoto = (NSArray *)dictResponse;
        
        for (NSDictionary *dicPhoto in tempPhoto) {
            PhotoModel *model = [[PhotoModel alloc] initWithDictionary:dicPhoto];
            [_arrPhoto addObject:model];
        }
        [self.tableViewPhoto reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - Delete Picture Delegate

-(void)deletePictureSuccess{
    [self loadPicture];
}

-(void)onEditPicture{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加作品",@"分享作品集",@"编辑作品集",@"批量管理作品", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex==0) {
        ChoosingPicturesViewController *choosingPictureVC = [[ChoosingPicturesViewController alloc] initWithNibName:@"ChoosingPicturesViewController" bundle:nil];
        choosingPictureVC.arrAlbum = _arrAlbum;
        choosingPictureVC.iDefaultAlbumSelectedIndex = _iDefaultAlbumSelectedIndex;
        [self.navigationController pushViewController:choosingPictureVC animated:YES];
    }else if(buttonIndex ==1){
        NSString *strHomePath = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,self.model.strHomeImgPath];
        NSString *strContent = [NSString stringWithFormat:@"我在孔雀翎上的最新作品集：http://kongqueling.tupai.cc/my_public/picture?id=%d，欢迎拍砖！ #网拍神器孔雀翎#",self.model.aid];
        NSString *strUrl = [NSString stringWithFormat:@"http://kongqueling.tupai.cc/my_public/picture?id=%d",self.model.aid];
        id<ISSContent> publishContent = [ShareSDK content:strContent
                                           defaultContent:nil
                                                    image:[ShareSDK imageWithUrl:strHomePath]
                                                    title:@"孔雀翎"
                                                      url:strUrl
                                              description:strContent
                                                mediaType:SSPublishContentMediaTypeNews];
        
        id<ISSContainer> container = [ShareSDK container];
        [container setIPhoneContainerWithViewController:self];
        
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:nil
                          shareOptions: nil
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(@"分享成功");
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    }
                                }];
    }else if(buttonIndex == 2){
        CreateAlbumViewController *createVC = [[CreateAlbumViewController alloc] init];
        createVC.bModify = YES;
        createVC.strAid = [NSString stringWithFormat:@"%d",self.model.aid];
        [self.navigationController pushViewController:createVC animated:YES];
    }else if(buttonIndex == 3){
        self.viewEdit.hidden = NO;
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"完成" selector:@selector(onFinish) target:self];
        _bEdit = YES;
		[self.tableViewPhoto reloadData];
    }
}

-(void)onFinish{
    [_arrSelectedPicture removeAllObjects];
    self.viewEdit.hidden = YES;
    _bEdit = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"moka_picture_edit" selector:@selector(onEditPicture) target:self];
    [self.tableViewPhoto reloadData];
}

-(IBAction)onDeleteClick:(id)sender{
    if (_arrSelectedPicture.count) {
        NSString *strPids = @"";
        for (NSString *str in _arrSelectedPicture) {
            PhotoModel *model = [_arrPhoto objectAtIndex:[str integerValue]];
            if (str != [_arrSelectedPicture lastObject]) {
                strPids = [strPids stringByAppendingFormat:@"%d,",model.pid];
            }else{
                strPids = [strPids stringByAppendingFormat:@"%d",model.pid];
            }
        }
        NSString *strUrl = [UrlHelper stringUrlDeleteAlbumPhotos:strPids];
        [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
            NSLog(@"dictResponse:%@",dictResponse);
            self.maskView.hidden = YES;
            UINavigationController *nav = self.navigationController;
            [nav popViewControllerAnimated:NO];
            self.model.count -= _arrSelectedPicture.count;
            
            if (self.model.count == 0) {
                PrepareUploadPhotoViewController *photoVC = [[PrepareUploadPhotoViewController alloc] init];
                photoVC.arrAlbum = _arrAlbum;
                [nav pushViewController:photoVC animated:NO];
            }else{
                AlbumPhotoListViewController *albumVC = [[AlbumPhotoListViewController alloc] init];
                albumVC.model = self.model;
                [nav pushViewController:albumVC animated:NO];
            }            
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"删除照片成功！"];
        } andFailureBlock:^(NSError *error) {
            NSLog(@"err:%@",[error localizedDescription]);
            self.maskView.hidden = YES;
        }];
    }else{
         [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请选择照片！"];
    }
    
}

-(IBAction)onMoveClick:(id)sender{
    if (_arrSelectedPicture) {
        ChoosingAlbumViewController *chooseVC = [[ChoosingAlbumViewController alloc] init];
        chooseVC.arrAlbum = self.arrAlbum;
        chooseVC.choosingAlbumDelegate = self;
        [self.navigationController pushViewController:chooseVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isExistInArrSelectedPicture:(int)index{
    NSString *strIndex = [NSString stringWithFormat:@"%d",index];
    for (NSString *str in _arrSelectedPicture) {
        if ([str isEqualToString:strIndex]) {
            return YES;
        }
    }
    return NO;
}

-(void)removeObjectWithIndexStr:(int)index{
    NSString *strIndex = [NSString stringWithFormat:@"%d",index];
    for (NSString *str in _arrSelectedPicture) {
        if ([str isEqualToString:strIndex]) {
            [_arrSelectedPicture removeObject:str];
            break;
        }
    }
}

#pragma mark - PhotoSelected Delegate
-(void)selectPhotoWithIndex:(int)index{
    if (index!=-1) {
        if (_bEdit) {
            if ([self isExistInArrSelectedPicture:index]) {
                [self removeObjectWithIndexStr:index];
            }else{
                [_arrSelectedPicture addObject:[NSString stringWithFormat:@"%d",index]];
            }
        }else{
            //AlbumPhotoViewController *photoVC = [[AlbumPhotoViewController alloc] init];
            AlbumPhotoViewController1 *photoVC = [[AlbumPhotoViewController1 alloc] init];
            photoVC.albumModel = self.model;
            photoVC.delegate = self;
			photoVC.arrPhoto = _arrPhoto;
			photoVC.iSelectedIndex = index;
            photoVC.photoModel = [_arrPhoto objectAtIndex:index];
            [self.navigationController pushViewController:photoVC animated:YES];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_arrPhoto.count==0) {
        return 0;
    }
    return (_arrPhoto.count-1)/3+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlbumPhotoCell";
    AlbumPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] lastObject];
    }
    
    if (_bEdit) {
        cell.type = KEditCell;
    }else{
        cell.type = KNormalCell;
    }
    
    cell.imageViewLeft.image = nil;
    cell.imageViewMiddle.image = nil;
    cell.imageViewRight.image = nil;
	cell.bButtonLeftSelected = NO;
	cell.bButtonMiddleSelected = NO;
	cell.bButtonRightSelected = NO;
    [cell.buttonLeft setBackgroundImage:nil forState:UIControlStateNormal];
    [cell.buttonMiddle setBackgroundImage:nil forState:UIControlStateNormal];
    [cell.buttonRight setBackgroundImage:nil forState:UIControlStateNormal];
	
    cell.buttonLeft.tag = -1;
    cell.buttonMiddle.tag = -1;
    cell.buttonRight.tag = -1;
    cell.delegate = self;
    
    int index = indexPath.row*3;
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageViewLeft setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageViewLeft .contentMode = KimageShowMode;
        [cell.imageViewLeft  setClipsToBounds:YES];
        cell.buttonLeft.tag = index;
        index++;
    }
    
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageViewMiddle setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageViewMiddle .contentMode = KimageShowMode;
        [cell.imageViewMiddle  setClipsToBounds:YES];
        cell.buttonMiddle.tag = index;
        index++;
    }
    
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageViewRight setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageViewRight .contentMode = KimageShowMode;
        [cell.imageViewRight  setClipsToBounds:YES];
        cell.buttonRight.tag = index;
        index++;
    }
    
    index=0;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
