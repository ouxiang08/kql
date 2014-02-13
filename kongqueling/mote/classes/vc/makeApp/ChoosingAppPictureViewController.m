//
//  AlbumPhotoListViewController.m
//  mote
//
//  Created by sean on 11/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PhotoModel.h"
#import "ChoosingAppPictureCell.h"
#import "ChoosingAppPictureViewController.h"
#import "AlbumPhotoViewController.h"
#import "UIBarButtonItemFactory.h"
#import "MakingMokaViewController.h"

@interface ChoosingAppPictureViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,ChoosingAppPictureCellDelegate,UINavigationBarDelegate>{
    NSMutableArray *_arrPhoto;
    NSMutableArray *_arrImageView;
    NSMutableArray *_arrImage;
    NSMutableArray *_arrIsPictureSelected;
    int _iSelectedCount;
    CGFloat _widthOffset;
}

@end

@implementation ChoosingAppPictureViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _widthOffset = 0;
    _iSelectedCount = 0;
    _arrPhoto = [[NSMutableArray alloc] init];
    _arrImageView = [[NSMutableArray alloc] init];
    _arrImage = [[NSMutableArray alloc] init];
    _arrIsPictureSelected = [[NSMutableArray alloc] init];
    self.arrImageSelectedUrl = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"作品集";
    self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/%d)",_iSelectedCount,self.iMaxPictureNumber];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"choosing_moka_picture_back_bg" selector:@selector(onBack:) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"choosing_moka_picture_cancel_bg" selector:@selector(onCancel:) target:self];
    self.scrollViewChoose.contentSize = CGSizeMake(60*7, 54);
    [self initScrollView];
}

-(void)viewWillAppear:(BOOL)animated{
    [_arrPhoto removeAllObjects];
    NSString *strUrl = [UrlHelper stringUrlGetAlbumPhotos:[NSString stringWithFormat:@"%d",self.model.aid]];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        NSArray *tempPhoto = (NSArray *)dictResponse;
        for (NSDictionary *dicPhoto in tempPhoto) {
            PhotoModel *model = [[PhotoModel alloc] initWithDictionary:dicPhoto];
            [_arrPhoto addObject:model];
        }
        [_arrIsPictureSelected removeAllObjects];
        [self.tableViewPhoto reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

-(void)initScrollView{
    _widthOffset = 0;
    for (int j=0; j<self.arrImageSelectedUrl.count; j++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_widthOffset, 0, 54, 54)];
        NSString *strUrl = [self.arrImageSelectedUrl objectAtIndex:j];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,strUrl];
         [imageView setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        
        [_arrImageView addObject:imageView];
        [_arrImage addObject:imageView.image];
        
        [self.scrollViewChoose addSubview:imageView];
        [self.scrollViewChoose scrollRectToVisible:CGRectMake(_widthOffset, 0, 54, 54) animated:NO];
        _widthOffset+=60;
        _iSelectedCount ++;
    }
    
    self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/%d)",_iSelectedCount,self.iMaxPictureNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onConfirm:(id)sender{
    
    if (_iSelectedCount ==0) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"图片数量不能为0！"];
    }else if(_iSelectedCount>self.iMaxPictureNumber){
         [[ToastViewAlert defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"图片数量不能超过%d张！",self.iMaxPictureNumber]];
    }else{
        [self.confirmDelegate selectPictureWitUrlArray:self.arrImageSelectedUrl];
        UINavigationController *nav = self.navigationController;
        [nav popViewControllerAnimated:NO];
        [nav popViewControllerAnimated:NO];
    }
}

-(void)onCancel:(id)sender{
    [self.rechooseDelegate selectAlbumWithArray:[[NSMutableArray alloc] init]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onBack:(id)sender{
    [self.rechooseDelegate selectAlbumWithArray:self.arrImageSelectedUrl];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PhotoSelected Delegate
-(void)didClickCellAtIndex:(int)index{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_widthOffset, 0, 54, 54)];
    PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
    [imageView setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    imageView.contentMode = KimageShowMode;
    [imageView setClipsToBounds:YES];
    
    [self.arrImageSelectedUrl addObject:photoModel.imgPath];
    [_arrImageView addObject:imageView];
    [_arrImage addObject:imageView.image];
    
    [self.scrollViewChoose addSubview:imageView];
    [self.scrollViewChoose scrollRectToVisible:CGRectMake(_widthOffset, 0, 54, 54) animated:YES];
    _widthOffset += 60;
    _iSelectedCount ++;
    self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/%d)",_iSelectedCount,self.iMaxPictureNumber];
}

-(void)didUnClickCellAtIndex:(int)index{
    PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
    int i =[self.arrImageSelectedUrl indexOfObject:photoModel.imgPath];
    UIImageView *imageView = [_arrImageView objectAtIndex:i];

    int k = [self findString:photoModel.imgPath];
    if (k!=-1) {
         [self.arrImageSelectedUrl removeObjectAtIndex:k];
    }
    [_arrImageView removeObjectAtIndex:i];
    [_arrImage removeObjectAtIndex:i];
    [imageView removeFromSuperview];
    
    for (int j=0; j<_arrImageView.count; j++) {
        UIImageView *imageViewT = [_arrImageView objectAtIndex:j];
        [imageViewT removeFromSuperview];
    }
    
    _widthOffset = 0;
    for (int j=0; j<_arrImageView.count; j++) {
        UIImageView *imageViewT = [_arrImageView objectAtIndex:j];
        [imageViewT setFrame:CGRectMake(_widthOffset, 0, 54, 54)];
        imageViewT.contentMode = KimageShowMode;
        [imageViewT setClipsToBounds:YES];
        [self.scrollViewChoose addSubview:imageViewT];
        _widthOffset+=60;
    }
    
    [self.scrollViewChoose scrollRectToVisible:CGRectMake(0, 0, 54, 54) animated:YES];
    _iSelectedCount --;
    self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/%d)",_iSelectedCount,self.iMaxPictureNumber] ;
}

-(void)didClickAppPictureCell:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSString *strIsPictureSelected = [_arrIsPictureSelected objectAtIndex:button.tag];
    if ([strIsPictureSelected isEqualToString:@"0"]) {
        if (_iSelectedCount!=self.iMaxPictureNumber) {
            [button setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            [self didClickCellAtIndex:button.tag];
            [_arrIsPictureSelected replaceObjectAtIndex:button.tag withObject:@"1"];
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"已选择照片数量不能超过%d张",self.iMaxPictureNumber]];
        }
    }else{
        [button setImage:nil forState:UIControlStateNormal];
        [self didUnClickCellAtIndex:button.tag];
        [_arrIsPictureSelected replaceObjectAtIndex:button.tag withObject:@"0"];
    }
}

-(int)findString:(NSString *)str{
    for (int i=0; i<self.arrImageSelectedUrl.count; i++) {
        NSString *strImageUrl = [self.arrImageSelectedUrl objectAtIndex:i];
        if ([strImageUrl isEqualToString:str]) {
            return i;
        }
    }
    return -1;
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
    return (_arrPhoto.count-1)/4+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChoosingAppPictureCell";
    ChoosingAppPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChoosingAppPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    
    int index = indexPath.row*4;
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageView1 setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView1 .contentMode = KimageShowMode;
        [cell.imageView1 setClipsToBounds:YES];
        cell.buttonSelected1.tag = index;
        [cell.buttonSelected1 addTarget:self action:@selector(didClickAppPictureCell:) forControlEvents:UIControlEventTouchUpInside];
        
        int i = [self findString:photoModel.imgPath];
        if (i!=-1) {
            [cell.buttonSelected1 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            [_arrIsPictureSelected addObject:@"1"];
        }else{
            [cell.buttonSelected1 setImage:nil forState:UIControlStateNormal];
            [_arrIsPictureSelected addObject:@"0"];
        }
        index++;
    }
    
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageView2 setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView2 .contentMode = KimageShowMode;
        [cell.imageView2 setClipsToBounds:YES];
        cell.buttonSelected2.tag = index;
        [cell.buttonSelected2 addTarget:self action:@selector(didClickAppPictureCell:) forControlEvents:UIControlEventTouchUpInside];
        
        int i = [self findString:photoModel.imgPath];
        if (i!=-1) {
            [cell.buttonSelected2 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
             [_arrIsPictureSelected addObject:@"1"];
        }else{
            [cell.buttonSelected2 setImage:nil forState:UIControlStateNormal];
             [_arrIsPictureSelected addObject:@"0"];
        }
        index++;
    }
    
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageView3 setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView3 .contentMode = KimageShowMode;
        [cell.imageView3 setClipsToBounds:YES];
        cell.buttonSelected3.tag = index;
        [cell.buttonSelected3 addTarget:self action:@selector(didClickAppPictureCell:) forControlEvents:UIControlEventTouchUpInside];
        
        int i = [self findString:photoModel.imgPath];
       if (i!=-1) {
           [cell.buttonSelected3 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            [_arrIsPictureSelected addObject:@"1"];
       }else{
           [cell.buttonSelected3 setImage:nil forState:UIControlStateNormal];
            [_arrIsPictureSelected addObject:@"0"];
       }
        index++;
    }
    
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageView4 setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView4 .contentMode = KimageShowMode;
        [cell.imageView4 setClipsToBounds:YES];
        cell.buttonSelected4.tag = index;
        [cell.buttonSelected4 addTarget:self action:@selector(didClickAppPictureCell:) forControlEvents:UIControlEventTouchUpInside];
        
        int i = [self findString:photoModel.imgPath];
        if (i!=-1) {
            [cell.buttonSelected4 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
             [_arrIsPictureSelected addObject:@"1"];
        }else{
            [cell.buttonSelected4 setImage:nil forState:UIControlStateNormal];
             [_arrIsPictureSelected addObject:@"0"];
        }
        index++;
    }
    
    index=0;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
