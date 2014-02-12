//
//  MyFinderViewController.m
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "FinderConditionListViewController.h"
#import "MyFinderTableViewCell.h"
#import "MyFinderViewController.h"
#import "MyMerchantListViewController.h"

@interface MyFinderViewController ()<UITableViewDataSource,UITableViewDelegate,ConditionSelectedDelegate>{
    NSMutableArray *_arrFinderList;
    int _iPage;
    int _iMaxPage;
    NSString* _condCity;
    NSString* _condArea;
    NSString* _condIndustry;
    NSString* _condSort;
    BOOL _isHot;
}

@end

@implementation MyFinderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"查找";
		self.tabBarItem.image = [UIImage imageNamed:@"moka_tabbar_search_normal_bg"];
    }
    
    _iPage = 1;
    _arrFinderList = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     _condCity = @"";
     _condArea = @"";
     _condIndustry = @"";
     _condSort = @"";
     _isHot = NO;
    //[self getMerchantQueryInfo];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getMerchantQueryInfo{
    _condCity = [[MainModel sharedObject] strCity];
    if (!_condCity) {
        _condCity = @"";
    }
    NSString *strUrl = [UrlHelper stringUrlGetMerchantList:_iPage city:_condCity area:@"" hotCity:@"" lat:[[MainModel sharedObject] currentLocation].coordinate.latitude lng:[[MainModel sharedObject] currentLocation].coordinate.latitude industry:_condIndustry sort:_condSort];
    
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [_arrFinderList addObjectsFromArray:[dictResponse valueForKey:@"mlist"]];
        _iMaxPage = [[dictResponse valueForKey:@"total"] integerValue]/10+1;
        [self.tableViewFinderList reloadData];
        
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

#pragma mark - IBAction

-(IBAction)onAreaClick:(id)sender{
    FinderConditionListViewController *conditionVC = [[FinderConditionListViewController alloc] init];
    conditionVC.type = kByArea;
    conditionVC.delegate = self;
    [self.navigationController pushViewController:conditionVC animated:YES];
}

-(IBAction)onIndustryClick:(id)sender{
    FinderConditionListViewController *conditionVC = [[FinderConditionListViewController alloc] init];
    conditionVC.type = kByIndustry;
    conditionVC.delegate = self;
    [self.navigationController pushViewController:conditionVC animated:YES];
}

-(IBAction)onDefaultClick:(id)sender{
    FinderConditionListViewController *conditionVC = [[FinderConditionListViewController alloc] init];
    conditionVC.type = kBySort;
    conditionVC.delegate = self;
    [self.navigationController pushViewController:conditionVC animated:YES];
}

#pragma mark - Condition Selected Condition
-(void)selectWithArea:(NSString *)strArea andCity:(NSString *)strCity isHotCity:(BOOL)isHotCity{
    _condArea = strArea;
    _condCity = strCity;
    _isHot = isHotCity;
    
    [self.buttonArea setTitle:strArea forState:UIControlStateNormal];
    [self toLoad];
}

-(void)selectWithArea:(NSString *)strArea isHotCity:(BOOL)isHotCity{
    _condArea = strArea;
    _isHot = isHotCity;
    
    [self.buttonArea setTitle:strArea forState:UIControlStateNormal];
    [self toLoad];
}

-(void)selectWithCity:(NSString *)strCity{
    _condCity = strCity;
    _isHot = NO;
    
    [self.buttonArea setTitle:strCity forState:UIControlStateNormal];
    [self toLoad];
}

-(void)selectWithIndustry:(NSString *)strIndustry{
    _condIndustry = strIndustry;
    
    [self.buttonIndustry setTitle:strIndustry forState:UIControlStateNormal];
    [self toLoad];
}


-(void)selectWithSort:(NSString *)strSort{
    _condSort = strSort;
   
    [self.buttonDefault setTitle:strSort forState:UIControlStateNormal];
    [self toLoad];
}

- (void)toLoad{
    NSString *strURL;
    if (!_isHot) {
        strURL = [UrlHelper stringUrlGetMerchantList:_iPage city:_condCity area:_condArea hotCity:@"" lat:[[MainModel sharedObject] currentLocation].coordinate.latitude lng:[[MainModel sharedObject] currentLocation].coordinate.longitude industry:_condIndustry sort:_condSort];
        
    }else{
        strURL = [UrlHelper stringUrlGetMerchantList:_iPage city:@"" area:@"" hotCity:_condArea lat:[[MainModel sharedObject] currentLocation].coordinate.latitude lng:[[MainModel sharedObject] currentLocation].coordinate.longitude industry:_condIndustry sort:_condSort];
    }
    
    [self updateData:strURL];
}

-(void)updateData:(NSString *)strUrl{
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _iPage = 1;
        [_arrFinderList removeAllObjects];
        _iMaxPage = [[dictResponse valueForKey:@"total"] integerValue]/10+1;
        [_arrFinderList addObjectsFromArray:[dictResponse valueForKey:@"mlist"]];
        [self.tableViewFinderList reloadData];
        
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];

}

-(UITableViewCell *)loadMoreCell{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MORECELL"];
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorView.center = cell.center;
    [indicatorView startAnimating];
    [cell addSubview:indicatorView];
    _iPage++;
    [self getMerchantQueryInfo];
    return cell;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_iPage==_iMaxPage) {
        return _arrFinderList.count;
    }else{
        return _arrFinderList.count+1;

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _arrFinderList.count) {
        return [self loadMoreCell];
    }
    
    static NSString *cellIndenfier = @"CELL";
    MyFinderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    
    if (!cell) {
        cell = [[MyFinderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    
    NSDictionary *dictFinder = [_arrFinderList objectAtIndex:indexPath.row];
    int iScore = [[dictFinder valueForKey:@"score"] integerValue];
    NSString *strTitle = [dictFinder valueForKey:@"name"];
    NSString *strBrandLogoImageUrl = [dictFinder valueForKey:@"brand_logo"];
    NSString *strLabels = [dictFinder valueForKey:@"labels"];
    BOOL isInvited = [[dictFinder valueForKey:@"is_invite"] boolValue];
    NSString *strArea = [dictFinder valueForKey:@"area"];
    NSString *strCity = [dictFinder valueForKey:@"city"];
    
     [cell.imageViewLogo setImageWithURL:[NSURL URLWithString:strBrandLogoImageUrl] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.labelTitle.text = strTitle;
    cell.labelArea.text = [NSString stringWithFormat:@"%@ %@",strCity,strArea];
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
    NSDictionary *dictFinder = [_arrFinderList objectAtIndex:indexPath.row];
    MyMerchantListViewController *myMerchantVC = [[MyMerchantListViewController alloc] init];
    myMerchantVC.strMid =  [dictFinder valueForKey:@"sid"];
    [self.navigationController pushViewController:myMerchantVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
