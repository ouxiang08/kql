//
//  MySaveListViewController.m
//  mote
//
//  Created by sean on 1/3/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "MySaveListTableViewCell.h"
#import "MySaveListViewController.h"
#import "MyMerchantListViewController.h"

@interface MySaveListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_arrSaveList;
}

@end

@implementation MySaveListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _arrSaveList = [[NSArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的收藏";
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

-(void)getData{
    NSString *strUrl = [UrlHelper stringUrlGetUserFav];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _arrSaveList = (NSArray *)dictResponse;
        [self.tableViewSaveList reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrSaveList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndenfier = @"CELL";
    MySaveListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    
    if (!cell) {
        cell = [[MySaveListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    
    NSDictionary *dictFinder = [_arrSaveList objectAtIndex:indexPath.row];
    int iScore = [[dictFinder valueForKey:@"score"] integerValue];
    NSString *strTitle = [dictFinder valueForKey:@"name"];
    NSString *strBrandLogoImageUrl = [dictFinder valueForKey:@"img"];
    NSString *strLabels = [dictFinder valueForKey:@"industry"];
    BOOL isInvited = [[dictFinder valueForKey:@"is_invite"] boolValue];
    NSString *strArea = [dictFinder valueForKey:@"district"];
    
    
    [cell.imageViewLogo setImageWithURL:urlFromImageURLstr(strBrandLogoImageUrl) placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.labelTitle.text = strTitle;
    cell.labelArea.text = strArea;
    cell.labelIndustry.text = strLabels;
    
    if (iScore == 0) {
        cell.imageViewRate.image = [UIImage imageNamed:@"finder_start_0"];
    }else if(iScore ==1){
        cell.imageViewRate.image = [UIImage imageNamed:@"finder_start_1"];
    }else if(iScore ==2){
        cell.imageViewRate.image = [UIImage imageNamed:@"finder_start_2"];
    }else if(iScore ==3){
        cell.imageViewRate.image = [UIImage imageNamed:@"finder_start_3"];
    }else if(iScore ==4){
        cell.imageViewRate.image = [UIImage imageNamed:@"finder_start_4"];
    }else{
        cell.imageViewRate.image = [UIImage imageNamed:@"finder_start_5"];
    }
    
    if (isInvited) {
        cell.buttonSend.hidden = NO;
        [cell.buttonSend setTitle:@"已发送" forState:UIControlStateNormal];
    }else{
        cell.buttonSend.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictFinder = [_arrSaveList objectAtIndex:indexPath.row];
    MyMerchantListViewController *myMerchantVC = [[MyMerchantListViewController alloc] init];
    myMerchantVC.strMid =  [dictFinder valueForKey:@"mId"];
    [self.navigationController pushViewController:myMerchantVC animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
