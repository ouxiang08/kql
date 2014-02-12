//
//  ChoosingMokaAlbumViewController.m
//  mote
//
//  Created by sean on 12/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "AlbumModel.h"
#import "ChoosingAppAlbumViewController.h"

@interface ChoosingAppAlbumViewController ()<UITabBarDelegate,UITableViewDataSource,ReChooseMokaAlbumDelegate>{
    NSMutableArray *_arrAlbum;
    //NSMutableArray *_arrImageSelectedUrl;
}

@end

@implementation ChoosingAppAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _arrAlbum = [[NSMutableArray alloc] init];
    _arrImageSelectedUrl = [[NSMutableArray alloc] init];
    self.chooseVC = [[ChoosingAppPictureViewController alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"作品集";
    [self loadData];
}

-(void)loadData{
    NSString *strUrl = [UrlHelper stringUrlGetAlbums];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [self initArrayAlbum:(NSArray *)dictResponse];
        
    } andFailureBlock:^(NSError *error) {
        
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
    [self.tableViewAlbum reloadData];
}


#pragma mark - Rechoose Delegate
-(void)selectAlbumWithArray:(NSMutableArray *)arrPhoto{
    _arrImageSelectedUrl = arrPhoto;
}

#pragma mark - UITableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrAlbum.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AlbumModel *model = [_arrAlbum objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"    %@（%d张）",model.strAlbumName,model.count] ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumModel *model = [_arrAlbum objectAtIndex:indexPath.row];
    self.chooseVC.model = model;
    self.chooseVC.rechooseDelegate = self;
    self.chooseVC.arrImageSelectedUrl = _arrImageSelectedUrl;
    self.chooseVC.iMaxPictureNumber = self.iMaxPictureNumber;
    [self.navigationController pushViewController:self.chooseVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
