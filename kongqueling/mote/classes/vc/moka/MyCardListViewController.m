//
//  MyCardListViewController.m
//  mote
//
//  Created by sean on 12/23/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MyCardListViewController.h"
#import "MyCardTableViewCell.h"
#import "ChoosingTemplateViewController.h"
#import "MyCardDetalViewController.h"

@interface MyCardListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_arrCartList;
}

@end

@implementation MyCardListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _arrCartList = [[NSArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的模卡";
    
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"新建模卡" selector:@selector(onCreateMoka) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    CGRect frame = _bgimgv.frame;
    frame.size.height = MOKA_SCREEN_HEIGHT;
    _bgimgv.frame = frame;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [self getCardListRequest];
}

-(void)onCreateMoka{
    ChoosingTemplateViewController *chooseVC = [[ChoosingTemplateViewController alloc] init];
    [self.navigationController pushViewController:chooseVC animated:YES];
}

-(void)getCardListRequest{
    NSString *strUrl = [UrlHelper stringUrlGetMyCardList];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _arrCartList = (NSArray *)dictResponse;
        [self.tableViewCardList reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 270;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrCartList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"MyCardTableViewCell";
    MyCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    
    if (!cell) {
        cell = [[MyCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    
    NSDictionary *dictMoka = [_arrCartList objectAtIndex:indexPath.row];
    cell.labelDateTime.text = [NSString stringWithFormat:@"%@ 生成",[dictMoka valueForKey:@"ctime"]];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",KImageUrlDefault,[dictMoka valueForKey:@"imgpath"]];
    [cell.imageViewMoka setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCardDetalViewController *detailViewController = [[MyCardDetalViewController alloc] initWithNibName:@"MyCardDetalViewController" bundle:nil];
    detailViewController.cardInfo = [_arrCartList objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
