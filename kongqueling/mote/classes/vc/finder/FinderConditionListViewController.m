//
//  FinderConditionListViewController.m
//  mote
//
//  Created by sean on 12/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "FinderConditionListViewController.h"
#import "AreaViewController.h"

@interface FinderConditionListViewController ()<UITableViewDataSource,UITableViewDelegate,AreaChooseDelegate>{
    NSDictionary *_dictResult;
    NSArray *_sortArray;
    int _iSelectedIndex;
    
    NSArray *_arrGenders;
    NSArray *_arrCates;
}

@end

@implementation FinderConditionListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _arrGenders = @[@{@"label_id": @"all",@"label_text": @"全部"},@{@"label_id": @"M",@"label_text": @"男"},@{@"label_id": @"F",@"label_text": @"女"}];
    _arrCates = @[@"全部",@"中模",@"日韩",@"欧美"];
    
    _sortArray = [[NSArray alloc] initWithObjects:@"评分",@"人气",@"入驻时间", nil];
    
    if (self.type == kByArea) {
        self.title = @"选择城市";
    }else if(self.type == kByIndustry){
        self.title = @"选择行业";
    }else if(self.type == kByGender){
        self.title = @"选择性别";
    } else if(self.type == kByCate){
        self.title = @"选择类别";
    }else{
        self.title = @"排序方式";
    }
    
    if (self.type!=kBySort) {
        [self getConditionData];
    }
    
    if (self.type == kBySort2) {
        _sortArray = [[NSArray alloc] initWithObjects:@"评分",@"人气",@"价格", nil];
    }
    
    // Do any additional setup after loading the view from its nib.
}

-(void)getConditionData{
    NSString *strUrl = [UrlHelper stringUrlGetMerchantQueryInfo];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _dictResult = dictResponse;
        [self.tableViewCondition reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.type == kByArea) {
        return 2;
    }else{
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.type == kByArea) {
        if (section == 0) {
            return @"热门城市";
        }else{
            return @"其它城市";
        }
    }else{
        return @"";
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == kByArea) {
        NSDictionary *dictCityes = [_dictResult valueForKey:@"citys"];
        
        NSArray *arrCity = [dictCityes valueForKey:@"citys"];
        NSArray *arrHotCity = [dictCityes valueForKey:@"hotcity"];
        
        if (section == 0) {
            return arrHotCity.count;
        }else{
            return arrCity.count;
        }
        
    }else if(self.type == kByIndustry){
        NSArray *arrIndustries = [_dictResult valueForKey:@"industries"];
        return arrIndustries.count;
    }else if (self.type == kByGender){
        return [_arrGenders count];
    }else if (self.type == kByCate){
        return [_arrCates count];
    } else{
        return 3;
    }
    
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.type==kByArea) {
        NSDictionary *dictCityes = [_dictResult valueForKey:@"citys"];
        NSArray *arrCity = [dictCityes valueForKey:@"citys"];
        NSArray *arrHotCity = [dictCityes valueForKey:@"hotcity"];
        
        if (indexPath.section == 0) {
            cell.textLabel.text = [arrHotCity objectAtIndex:indexPath.row];
        }else{
            NSDictionary *dict = [arrCity objectAtIndex:indexPath.row];
            cell.textLabel.text = [dict valueForKey:@"name"];
        }
        
//        if (indexPath.row<arrHotCity.count) {
//            cell.textLabel.text = [arrHotCity objectAtIndex:indexPath.row];
//        }else{
//            NSDictionary *dict = [arrCity objectAtIndex:indexPath.row-arrHotCity.count];
//            cell.textLabel.text = [dict valueForKey:@"name"];
//        }
   } else if(self.type == kByIndustry){
        NSArray *arrIndustries = [_dictResult valueForKey:@"industries"];
        NSDictionary *dict = [arrIndustries objectAtIndex:indexPath.row];
        cell.textLabel.text = [dict valueForKey:@"label_text"];
   }else if(self.type == kByGender){
       NSDictionary *dict = [_arrGenders objectAtIndex:indexPath.row];
       cell.textLabel.text = [dict valueForKey:@"label_text"];
   }else if(self.type == kByCate){
       cell.textLabel.text = [_arrCates objectAtIndex:indexPath.row];
   }else{
       cell.textLabel.text = [_sortArray objectAtIndex:indexPath.row];
   }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == kByArea) {
        NSDictionary *dictCityes = [_dictResult valueForKey:@"citys"];
        NSArray *arrCity = [dictCityes valueForKey:@"citys"];
        NSArray *arrHotCity = [dictCityes valueForKey:@"hotcity"];
//        
//        if (indexPath.row<arrHotCity.count) {
//            [self.delegate selectWithArea:[arrHotCity objectAtIndex:indexPath.row] isHotCity:YES];
//        }else{
//            NSDictionary *dict = [arrCity objectAtIndex:indexPath.row-arrHotCity.count];
//            [self.delegate selectWithArea:[dict valueForKey:@"name"] isHotCity:NO];
//        }
        
        if (indexPath.section==0) {
            [self.delegate selectWithArea:[arrHotCity objectAtIndex:indexPath.row] isHotCity:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSDictionary *dict = [arrCity objectAtIndex:indexPath.row];
            NSArray *arrArea = [dict valueForKey:@"area"];
            if (arrArea.count) {
                AreaViewController *area = [[AreaViewController alloc] init];
                area.arrArea = [dict valueForKey:@"area"];
                area.chooseAreaDelegate = self;
                _iSelectedIndex = indexPath.row;
                [self.navigationController pushViewController:area animated:YES];
            }else{
                //[self.delegate selectWithArea:[dict valueForKey:@"name"] isHotCity:NO];
                [self.delegate selectWithCity:[dict valueForKey:@"name"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }else if(self.type == kByIndustry){
        NSArray *arrIndustries = [_dictResult valueForKey:@"industries"];
        NSDictionary *dict = [arrIndustries objectAtIndex:indexPath.row];
        [self.delegate selectWithIndustry:[dict valueForKey:@"label_text"]];
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.type == kByGender){//性别
        NSDictionary *dict = [_arrGenders objectAtIndex:indexPath.row];
        [self.delegate selectWithGender:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }else if(self.type == kByCate){//类别
        [self.delegate selectWithCate:[_arrCates objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.delegate selectWithSort:[_sortArray objectAtIndex:indexPath.row]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)chooseAreaWithName:(NSString *)str{
    
    NSDictionary *dictCityes = [_dictResult valueForKey:@"citys"];
    NSArray *arrCity = [dictCityes valueForKey:@"citys"];
    NSDictionary *dict = [arrCity objectAtIndex:_iSelectedIndex];
    [self.delegate selectWithArea:str andCity:[dict valueForKey:@"name"] isHotCity:NO];
    //[self.delegate selectWithArea:str isHotCity:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
