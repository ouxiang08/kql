//
//  ChoosingTemplateViewController.m
//  mote
//
//  Created by sean on 11/17/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingTemplateCell.h"
#import "ChoosingTemplateViewController.h"
#import "ChoosingMokaPictureViewController.h"
#import "ChoosingMokaAlbumViewController.h"

@interface ChoosingTemplateViewController ()<UITableViewDataSource,UITableViewDelegate,ChoosingTemplateCellDelegate>{
    NSMutableArray *_arrTemplate;
    int _iSelectedIndex;
}

@end

@implementation ChoosingTemplateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _iSelectedIndex = -1;
    _arrTemplate = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择模板";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"下一步" selector:@selector(onNextClick) target:self];
    
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    NSString *strUrl = [UrlHelper stringUrlGetCardTemplates];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _arrTemplate = (NSMutableArray *)dictResponse;
        [self.tableViewTemplate reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

-(void)onNextClick{
    if (_iSelectedIndex!=-1) {
//        ChoosingMokaPictureViewController *choosingPictureVC = [[ChoosingMokaPictureViewController alloc] init];
//        NSDictionary *dicTemplateLeft = [_arrTemplate objectAtIndex:_iSelectedIndex];
//        choosingPictureVC.strMokaBgUrl = [dicTemplateLeft valueForKey:@"thumbnailPath"];
//        choosingPictureVC.dictMoka = [_arrTemplate objectAtIndex:_iSelectedIndex];
//        [self.navigationController pushViewController:choosingPictureVC animated:YES];
        
        ChoosingMokaAlbumViewController *albumVC = [[ChoosingMokaAlbumViewController alloc] init];
        albumVC.dictMoka = [_arrTemplate objectAtIndex:_iSelectedIndex];
        [self.navigationController pushViewController:albumVC animated:YES];
    }else{
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请选择模板！"];
    }
}

#pragma mark - TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrTemplate.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 240;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"ChoosingTemplateCell";
    ChoosingTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (!cell) {
        cell = [[[UINib nibWithNibName: cellIndenfier bundle:nil] instantiateWithOwner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.templateCellDelegate = self;
    }
    
    cell.imageViewTemplateLeftSelected.hidden = YES;
    
    if (indexPath.row == _iSelectedIndex) {
        cell.imageViewTemplateLeftSelected.hidden = NO;
    }
    
    NSDictionary *dicTemplateLeft = [_arrTemplate objectAtIndex:indexPath.row];
    cell.buttonLeftImageView.tag = indexPath.row;
    [cell.imageViewTemplateLeft setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KTemplateImageUrlDefault,[dicTemplateLeft valueForKey:@"thumbnailPath"]]] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.imageViewTemplateLeft.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}

#pragma mark - ChoosingTemplateCell Delegate
-(void)selectTemplateCellWithId:(int)buttonTag{
    _iSelectedIndex = buttonTag;
    [self.tableViewTemplate reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
