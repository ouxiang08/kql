//
//  MakingAppViewController.m
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//
#import "MakingAppViewController.h"
#import "WCCAlbumPickerController.h"
#import "WCCImagePickerController.h"
#import "ChoosingBgMusicViewController.h"
#import "ChoosingAppAlbumViewController.h"
#import "WaitingMakingAppViewController.h"
#import "SetHomePictureViewController.h"
#import "UpYun.h"

@interface MakingAppViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ChoosingBgMusicDelegate,ConfirmAppPictureDelegate,SetHomePictureDelegate>{
    int _iSelectedCount;
    int _iCountUploadSuccess;
    NSString *_strImagePath;
    NSMutableArray *_arrImage;
    UIView *_viewTop;
    NSDictionary *_dictMusic;
    NSString *_strHomePath;
    int _iSelectType;
}

@end

@implementation MakingAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _iSelectedCount = 0;
    _iCountUploadSuccess = 0;
    _strImagePath = @"";
    _strHomePath = @"";
    _arrImage = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)configureTopView{
    if (_iSelectedCount ==0) {
        _viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 98)];
        
        UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonAdd setBackgroundImage:[UIImage imageNamed:@"choosing_picture_add_bg"] forState:UIControlStateNormal];
        [buttonAdd setFrame:CGRectMake(14, 14, 70, 70)];
        [buttonAdd addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_viewTop addSubview:buttonAdd];
        
    }else{
        for (UIView *subView in _viewTop.subviews) {
            [subView removeFromSuperview];
        }
        
        CGFloat widthOffset = 14;
        CGFloat heightOffset = 14;
        CGFloat heightTopView = 98+_iSelectedCount/4*74;
        _viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, heightTopView)];
        
        for (int i=0; i<_arrImage.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, 70, 70)];
            NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,[_arrImage objectAtIndex:i]];
            [imageView setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
            imageView.contentMode = KimageShowMode;
            [imageView setClipsToBounds:YES];
            [_viewTop addSubview:imageView];
            
            widthOffset += 74;
            if (widthOffset>300) {
                widthOffset = 14;
                heightOffset += 74;
            }
        }
        
        if (_iSelectedCount!=KMaxUploadImageCount) {
            UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
            [buttonAdd setBackgroundImage:[UIImage imageNamed:@"choosing_picture_add_bg"] forState:UIControlStateNormal];
            [buttonAdd setFrame:CGRectMake(widthOffset, heightOffset, 70, 70)];
            [buttonAdd addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
            [_viewTop addSubview:buttonAdd];
            
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"生成APP";
    UIBarButtonItem *rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"生成" selector:@selector(onMakeAppClick) target:self];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Set home picture delegate
-(void)setHomePictureWithIndex:(int)index{
    _strHomePath = [_arrImage objectAtIndex:index];
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,_strHomePath];
    [self.imageViewHomePicture setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    self.imageViewHomePicture .contentMode = KimageShowMode;
    [self.imageViewHomePicture  setClipsToBounds:YES];
}

#pragma mark - on Button Click
-(void)onAddClick{
    _iSelectType = 0;
    ChoosingAppAlbumViewController *chooseAppVC = [[ChoosingAppAlbumViewController alloc] init];
    chooseAppVC.chooseVC.confirmDelegate = self;
    chooseAppVC.iMaxPictureNumber = KMaxUploadImageCount;
    chooseAppVC.arrImageSelectedUrl = _arrImage;
    [self.navigationController pushViewController:chooseAppVC animated:YES];
}

#pragma mark - ChoosingPicture Delegate
-(void)selectPictureWitUrlArray:(NSMutableArray *)arrPhotoImageUrl{
    if (_iSelectType ==0) {
        _arrImage = arrPhotoImageUrl;
        _iSelectedCount = _arrImage.count;
        [self.tableViewPicture reloadData];
    }else{
        _strHomePath = [arrPhotoImageUrl objectAtIndex:0];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,_strHomePath];
        [self.imageViewHomePicture setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    }
}

#pragma mark - TextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textFieldAppName resignFirstResponder];
    return YES;
}

#pragma mark - on Button click
-(void)onMakeAppClick{
    
    if (_arrImage.count ==0) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"至少选择一张图片！"];
    }else if (_dictMusic==nil) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请选择背景音乐！"];
    }else if([_strHomePath isEqualToString:@""]){
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请设置封面！"];
    }else if(self.textFieldAppName.text==nil||[self.textFieldAppName.text isEqualToString:@""]){
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"APP命名不能为空！"];
    }else{
        WaitingMakingAppViewController *waitingVC = [[WaitingMakingAppViewController alloc] init];
        waitingVC.arrImage = _arrImage;
        waitingVC.dictMusic = _dictMusic;
        waitingVC.strHomePath = _strHomePath;
        waitingVC.strAppName = self.textFieldAppName.text;
        [self.navigationController pushViewController:waitingVC animated:YES];
    }
}

#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 38;
        }else{
            if (_iSelectedCount == 0) {
                return 98;
            }else{
                return 98+_iSelectedCount/4*74;
            }
        }
    }else{
        return 38;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            static NSString *cellIndenfier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"已选择作品";
            
            
            return cell;
        }else{
            static NSString *cellIndenfier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
            }
            [self configureTopView];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell addSubview:_viewTop];
            return cell;
        }
        
    }else{
        if(indexPath.row == 0){
            return self.tableViewCellBgMusic;
        }else if(indexPath.row ==1){
            return self.tableViewHomePicture;
        }else{
            return self.tableViewCellAppName;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            ChoosingBgMusicViewController *chooseVC = [[ChoosingBgMusicViewController alloc] init];
            chooseVC.musicDelegate = self;
            [self.navigationController pushViewController:chooseVC animated:YES];
        }else if(indexPath.row == 1){
            if (_arrImage.count) {
                SetHomePictureViewController *setHomePictureVC = [[SetHomePictureViewController alloc] init];
                setHomePictureVC.arrImageUrl = _arrImage;
                setHomePictureVC.delegate = self;
                [self.navigationController pushViewController:setHomePictureVC animated:YES];
            }else{
                [[ToastViewAlert defaultCenter] postAlertWithMessage:@"至少选择一张作品！"];
            }
        }
    }
}

#pragma mark - ChoosingBgMusicDelegate
-(void)selectBgMusicWithDict:(NSDictionary *)dictMusic{
    _dictMusic = dictMusic;
    self.labelBgMusic.text = [dictMusic valueForKey:@"name"];
    [self.tableViewPicture reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

