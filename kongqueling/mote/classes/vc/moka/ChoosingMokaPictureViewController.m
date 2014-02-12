//
//  AlbumPhotoListViewController.m
//  mote
//
//  Created by sean on 11/26/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "PhotoModel.h"
#import "ChoosingMokaPictureCell.h"
#import "ChoosingMokaPictureViewController.h"
#import "AlbumPhotoViewController.h"
#import "UIBarButtonItemFactory.h"
#import "MakingMokaViewController.h"

@interface ChoosingMokaPictureViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,ChoosingMokaPictureCellDelegate,UINavigationBarDelegate>{
    NSMutableArray *_arrPhoto;
    NSMutableArray *_arrImageView;
    NSMutableArray *_arrImage;
    int _iSelectedCount;
    CGFloat _widthOffset;
}

@end

@implementation ChoosingMokaPictureViewController


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
    self.arrImageSelectedUrl = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"作品集";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"choosing_moka_picture_back_bg" selector:@selector(onBack:) target:self];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"choosing_moka_picture_cancel_bg" selector:@selector(onCancel:) target:self];
    self.scrollViewChoose.contentSize = CGSizeMake(60*7, 54);
    [self initScrollView];
    
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

-(void)initScrollView{
    _widthOffset = 0;
    for (int j=0; j<self.arrImageSelectedUrl.count; j++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_widthOffset, 0, 54, 54)];
        imageView .contentMode = KimageShowMode;
        [imageView setClipsToBounds:YES];
        NSString *strUrl = [self.arrImageSelectedUrl objectAtIndex:j];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,strUrl];
         [imageView setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        
        [_arrImageView addObject:imageView];
        [_arrImage addObject:imageView.image];
        
        [self.scrollViewChoose addSubview:imageView];
        [self.scrollViewChoose scrollRectToVisible:CGRectMake(_widthOffset, 0, 54, 54) animated:NO];
        _widthOffset+=60;
        _iSelectedCount ++;
    }
    
    self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/7)",_iSelectedCount];
}

#pragma mark - action sheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onConfirm:(id)sender{
    
    if (_iSelectedCount !=7) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"照片数量应为7！"];
    }else{
        MakingMokaViewController *makingMokaVC = [[MakingMokaViewController alloc] init];
        makingMokaVC.dicMoka = self.dicMoka;
        makingMokaVC.arrImage = _arrImage;
        [self.navigationController pushViewController:makingMokaVC animated:YES];
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
        imageView .contentMode = KimageShowMode;
        [imageView setClipsToBounds:YES];
        
        [self.arrImageSelectedUrl addObject:photoModel.imgPath];
        [_arrImageView addObject:imageView];
        [_arrImage addObject:imageView.image];
        
        [self.scrollViewChoose addSubview:imageView];
        [self.scrollViewChoose scrollRectToVisible:CGRectMake(_widthOffset, 0, 54, 54) animated:YES];
        _widthOffset += 60;
        _iSelectedCount ++;
        self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/7)",_iSelectedCount];
   
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
        imageView .contentMode = KimageShowMode;
        [imageView setClipsToBounds:YES];
        [self.scrollViewChoose addSubview:imageViewT];
        _widthOffset+=60;
    }
    
    [self.scrollViewChoose scrollRectToVisible:CGRectMake(0, 0, 54, 54) animated:YES];
    _iSelectedCount --;
    self.labelConfirm.text =[NSString stringWithFormat:@"确认(%d/7)",_iSelectedCount] ;
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
    static NSString *CellIdentifier = @"ChoosingMokaPictureCell";
    ChoosingMokaPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ChoosingMokaPictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    
    int index = indexPath.row*4;
    if (index<_arrPhoto.count) {
        PhotoModel *photoModel = [_arrPhoto objectAtIndex:index];
        NSString *strImageUrl = [NSString stringWithFormat:@"%@%@!200",KImageUrlDefault,photoModel.imgPath];
        [cell.imageView1 setImageWithURL:[NSURL URLWithString:strImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView1.contentMode = KimageShowMode;
        [cell.imageView1 setClipsToBounds:YES];
        cell.imageView1 .contentMode = KimageShowMode;
        [cell.imageView1 setClipsToBounds:YES];
        cell.buttonSelected1.tag = index;
        
        int i = [self findString:photoModel.imgPath];
        if (i!=-1) {
            [cell.buttonSelected1 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            cell.isChecked1 = YES;
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
        
        int i = [self findString:photoModel.imgPath];
        if (i!=-1) {
            [cell.buttonSelected2 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            cell.isChecked2 = YES;
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
        
        int i = [self findString:photoModel.imgPath];
       if (i!=-1) {
           [cell.buttonSelected3 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            cell.isChecked3 = YES;
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
        
        int i = [self findString:photoModel.imgPath];
        if (i!=-1) {
            [cell.buttonSelected4 setImage:[UIImage imageNamed:@"Overlay"] forState:UIControlStateNormal];
            cell.isChecked4 = YES;
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
