//
//  ChoosingPicturesViewController.m
//  mote
//
//  Created by sean on 11/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingPicturesViewController.h"
#import "WCCAlbumPickerController.h"
#import "WCCImagePickerController.h"
#import "ChoosingAlbumViewController.h"
#import "UpYun.h"
#import "AlbumModel.h"
#import "UIImage+Additions.h"

@interface ChoosingPicturesViewController ()<UIImagePickerControllerDelegate,
WCCImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate,ChoosingAlbumDelegate>{
    BOOL _bChecked;
    
    int _iSelectedCount;
    int _iCountUploadSuccess;
   
    NSString *_strImagePath;
    NSString *_dirPath;
    NSMutableArray *_arrImage;
    NSMutableArray *_arrImagePath;
    NSMutableArray *_arrDocumentImagePath;
    
    UIView *_viewTop;
    MokaIndicatorView *_mokaIndicator;
}

@end

@implementation ChoosingPicturesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _bChecked = NO;
    _iDefaultAlbumSelectedIndex = 0;
     _iSelectedCount = 0;
    _iCountUploadSuccess = 0;
    _strImagePath = @"";
    _dirPath = [[FilePathHelper getDocPath] stringByAppendingPathComponent:[MainModel sharedObject].strUid];
    _arrImagePath = [[NSMutableArray alloc] init];
    _arrImage = [[NSMutableArray alloc] init];
    _arrDocumentImagePath = [[NSMutableArray alloc] init];
    _mokaIndicator = [[MokaIndicatorView alloc] initWithFrame:KScreenBounds];
    
    return self;
}

-(void)configureTopView{
    if (_iSelectedCount ==0) {
        _viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 98)];
        UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 78)];
        imageViewBg.image = [UIImage imageNamed:@"choosing_picutre_top_cell_bg"];
        [_viewTop addSubview:imageViewBg];
        
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
        CGFloat heightTopView = 0;
        
        if (_iSelectedCount!=KMaxUploadImageCount) {
            heightTopView = 98+_iSelectedCount/4*74;
        }else{
            heightTopView = 93+148;
        }
       
        _viewTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, heightTopView)];
        UIImageView *imageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, heightTopView-20)];
        imageViewBg.image = [UIImage imageNamed:@"choosing_picutre_top_cell_bg"];
        [_viewTop addSubview:imageViewBg];
        
        for (int i=0; i<_arrImage.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(widthOffset, heightOffset, 70, 70)];
             imageView.image = [_arrImage objectAtIndex:i];
            //imageView.image = [dictImage objectForKey:UIImagePickerControllerOriginalImage];
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
    self.title = @"上传作品";
   
    self.navigationItem.rightBarButtonItem =  [UIBarButtonItemFactory getBarButtonWithTitle:@"上传" selector:@selector(onUploadClick) target:self];
    
    AlbumModel *model = [self.arrAlbum objectAtIndex:_iDefaultAlbumSelectedIndex];
    self.labelAlbum.text = model.strAlbumName;
}

#pragma mark - on Button Click
-(void)onAddClick{
    WCCAlbumPickerController *albumController = [[WCCAlbumPickerController alloc] initWithNibName: nil bundle: nil];
    albumController.iMaxSelected = KMaxUploadImageCount -_iSelectedCount;
    albumController.iMinSelected = 0;
    
    WCCImagePickerController *elcPicker = [[WCCImagePickerController alloc] initWithRootViewController:albumController];
    [albumController setParent:elcPicker];
    [elcPicker setDelegate:self];
    [self presentViewController:elcPicker animated:YES completion:^(void){}];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    UIImage *newimg = [[image fixOrientation] scaleToFixedSize:CGSizeMake(1200, 1200)];
    NSData *data = [self formatWithImage:newimg];
    if (data) {
        
    }else{
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"图片格式无效\n请选择格式为JPG或PNG的图片!"];
    }
}

#pragma mark - Common Methods
- (NSData*)formatWithImage:(UIImage*)image
{
    CGFloat fQuality = 0.6;
    NSData *data = UIImageJPEGRepresentation(image, fQuality);
    return data;
}

- (void)elcImagePickerController:(WCCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    
    if (_mokaIndicator.superview != self.view.window ) {
        [self.view.window addSubview:_mokaIndicator];
    }
    [_mokaIndicator start];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<info.count; i++) {
            NSDictionary *dict = [info objectAtIndex:i];
            UIImage *image = [[[dict objectForKey:UIImagePickerControllerOriginalImage] fixOrientation] scaleToFixedSize:CGSizeMake(1200, 1200)];
            NSData *data = [self formatWithImage:image];
            UIImage *imageTemp = [UIImage imageWithData:data];
            if (data) {
                [_arrImage addObject:imageTemp];
            }
            [self saveHighQualityImageWithData: UIImageJPEGRepresentation(image, 0) atIndex:i];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _iSelectedCount = _arrImage.count;
            [self.tableViewPicture reloadData];
             [_mokaIndicator stop];
        });
    });
}

- (void)elcImagePickerControllerDidCancel:(WCCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

-(void)addToImagePath:(NSString *)strPath{
    if (_iCountUploadSuccess!=_iSelectedCount) {
        _strImagePath = [_strImagePath stringByAppendingFormat:@"%@,",strPath];
    }else{
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"上传成功！"];
        [_mokaIndicator stop];
        
        [[NSFileManager defaultManager] removeItemAtPath:_dirPath error:nil];
        
        _strImagePath = [_strImagePath stringByAppendingFormat:@"%@",strPath];
        NSString *strUrl = [UrlHelper stringUrlUploadPhotos];
        NSMutableDictionary *dictParameters = [NSMutableDictionaryFactory getMutableDictionary];
        AlbumModel *model = [self.arrAlbum objectAtIndex:_iDefaultAlbumSelectedIndex];
        [dictParameters setObject:[NSString stringWithFormat:@"%d",model.aid] forKey:@"aid"];
        [dictParameters setObject:_strImagePath forKey:@"imgs"];
        
        [self actionRequestWithUrl:strUrl parameters:dictParameters successBlock:^(NSDictionary *dictResponse) {
            self.maskView.hidden = YES;
            [self.navigationController popViewControllerAnimated:NO];
            [self.uploadDelegate uploadSuccessWithModel:[self.arrAlbum objectAtIndex:_iDefaultAlbumSelectedIndex]];
        } andFailureBlock:^(NSError *error) {
            NSLog(@"failed");
        }];
    }
}

-(void)saveHighQualityImageWithData:(NSData *)data atIndex:(int)index{
    NSString *strDate = [NSString stringWithFormat:@"%d.jpg",index];
    NSString *strPath = [_dirPath stringByAppendingPathComponent:strDate];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL isDir = YES;
    if (![fileMgr fileExistsAtPath:_dirPath isDirectory:&isDir]) {
         [fileMgr createDirectoryAtPath: _dirPath withIntermediateDirectories: YES attributes: nil error: nil];
    }
    
    [fileMgr createFileAtPath:strPath contents:data attributes:nil];
    [_arrDocumentImagePath addObject:strPath];
}


#pragma mark - on Button click
-(void)onUploadClick{
    if (_arrImage.count==0) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"上传图片不能为空"];
    }else{
        UpYun *uy = [[UpYun alloc] init];
        uy.successBlocker = ^(id data)
        {
            _iCountUploadSuccess++;
            _mokaIndicator.labelHint.text =[NSString stringWithFormat:@"正在上传第%d张",_iCountUploadSuccess];
            [_arrImagePath addObject:[data valueForKey:@"url"]];
            [self addToImagePath:[data valueForKey:@"url"]];
            
            [NSThread sleepForTimeInterval:1.0f];
            if (_iCountUploadSuccess<_iSelectedCount) {
                //NSDictionary *dictImage = [_arrImage objectAtIndex:_iCountUploadSuccess];
                
                if (_bChecked) {
                    NSData *imageDataTemp = [[NSFileManager defaultManager] contentsAtPath:[_arrDocumentImagePath objectAtIndex:_iCountUploadSuccess]];
                    [uy uploadImageData:imageDataTemp savekey:[self getSaveKey]];
                }else{
                    UIImage *tempImage =  [_arrImage objectAtIndex:_iCountUploadSuccess];
                    [uy uploadFile:tempImage saveKey:[self getSaveKey]];
                }
            }
            
            NSLog(@"%@",data);
        };
        uy.failBlocker = ^(NSError * error)
        {
            [_mokaIndicator stop];
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"上传照片失败，请重新上传！"];
            NSLog(@"%@",error);
        };
        
       // NSDictionary *dictImage = [_arrImage objectAtIndex:0];
        UIImage *image =  [_arrImage objectAtIndex:_iCountUploadSuccess];
        _mokaIndicator.labelHint.text =[NSString stringWithFormat:@"正在上传第%d张",_iCountUploadSuccess+1];
        [self.view.window addSubview:_mokaIndicator];
        [_mokaIndicator start];
        
        if (_bChecked) {
            NSData *imageDataTemp = [[NSFileManager defaultManager] contentsAtPath:[_arrDocumentImagePath objectAtIndex:_iCountUploadSuccess]];
            [uy uploadImageData:imageDataTemp savekey:[self getSaveKey]];
            
            long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:[_arrDocumentImagePath objectAtIndex:_iCountUploadSuccess] error:nil] fileSize];
            NSLog(@"%f",fileSize/(1024.0));
            // [uy uploadImagePath:[_arrDocumentImagePath objectAtIndex:0] savekey:[self getSaveKey]];
        }else{
            [uy uploadFile:image saveKey:[self getSaveKey]];
        }
    }
    
}

-(NSString * )getSaveKey {
    NSDate *d = [NSDate date];
    return [NSString stringWithFormat:@"/%@/%d%d%d/%.0f.jpg",[MainModel sharedObject].strUid,[self getYear:d],[self getMonth:d],[self getDay:d],[[NSDate date] timeIntervalSince1970]];
}

- (int)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int year=[comps year];
    return year;
}

- (int)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps month];
    return month;
}

- (int)getDay:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    int month = [comps day];
    return month;
}


#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (_iSelectedCount == 0) {
            return 98;
        }else{
            if (_iSelectedCount!=KMaxUploadImageCount) {
                return 98+_iSelectedCount/4*74;
            }else{
                return 98+148;
            }
        }
    }else{
        return 48;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        
    if (indexPath.row == 0) {
        static NSString *cellIndenfier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        }

        [self configureTopView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:_viewTop];
        return cell;
    }else if(indexPath.row == 1){
        self.tableViewCellBottom.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.tableViewCellBottom;
    }else{
        self.tableViewCellHighQualityPicture.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.tableViewCellHighQualityPicture;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==1) {
        ChoosingAlbumViewController *choosingVC = [[ChoosingAlbumViewController alloc] init];
        choosingVC.choosingAlbumDelegate = self;
        choosingVC.arrAlbum = self.arrAlbum;
        [self.navigationController pushViewController:choosingVC animated:YES];
    }else if(indexPath.row == 2){
        if (_bChecked) {
            self.imageViewCheck.image = [UIImage imageNamed:@"choosing_photo_checkbox_unchecked.png"];
            _bChecked = NO;
        }else{
           self.imageViewCheck.image = [UIImage imageNamed:@"choosing_photo_checkbox_checked.png"];
            _bChecked = YES;
        }
    }
}

#pragma mark - DhoosingAlbumDelegate
-(void)choosingAlbumAtIndex:(int)iSelectedIndex{
    _iDefaultAlbumSelectedIndex = iSelectedIndex;
    AlbumModel *model = [self.arrAlbum objectAtIndex:iSelectedIndex];
    self.labelAlbum.text = model.strAlbumName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
