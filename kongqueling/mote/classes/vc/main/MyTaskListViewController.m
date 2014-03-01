//
//  MyTaskListViewController.m
//  mote
//
//  Created by sean on 11/16/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "DateEditViewController.h"
#import "DateEditViewController1.h"
#import "MyTaskListViewController.h"
#import "DateViewController.h"
#import "MyTaskListTableViewCell.h"
#import "MyTaskDateTableViewCell.h"
#import "TaskDetailViewController.h"

@interface MyTaskListViewController ()<UITableViewDataSource,UITableViewDelegate,SetDateDelegate>{
    BOOL _bMyDateList;
    NSArray *_arrDateList;
    NSArray *_arrDateTask;
}

@end

@implementation MyTaskListViewController

@synthesize selectedDate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的日程";
		self.tabBarItem.image = [UIImage imageNamed:@"moka_tabbar_task_normal_bg"];
    }
    
    _arrDateList = [[NSArray alloc] init];
    _arrDateTask = [[NSArray alloc] init];
    _bMyDateList = NO;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"task_btn_list_bg.png" selector:@selector(onTaskListClick) target:self];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"moka_picture_edit" selector:@selector(onEditDate) target:self];
}

-(void)viewWillAppear:(BOOL)animated{
     [self initDateView];
}

-(void)initDateView{
    if (!self.dateVC) {
        [self.dateVC removeFromParentViewController];
    }
    self.dateVC = [[DateViewController alloc] init];
    self.dateVC.bIsBtnTaskDateClicked = YES;
    self.dateVC.delegate = self;
    
    if (self.selectedDate) {
        self.dateVC.currentDate = self.selectedDate;
    }
    
    [self.view addSubview:self.dateVC.view];
    
    
}

-(void)onEditDate{
    
    self.selectedDate = self.dateVC.currentDate;
    
    //DateEditViewController *dateVC = [[DateEditViewController alloc] init];
    DateEditViewController1 *dateVC = [[DateEditViewController1 alloc] initWithDate:self.selectedDate];
    [self.navigationController pushViewController:dateVC animated:YES];
} 


#pragma mark - date click delegate
-(void)onClickDateWithArrTaskInfo:(NSArray *)arrTaskInfo{
    _arrDateTask = arrTaskInfo;
    [self.tableViewDateTask reloadData];
}

-(void)onTaskListClick{
    if (!_bMyDateList) {
        _bMyDateList = YES;
        NSString *strUrl = [UrlHelper stringUrlGetTaskList];
        [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
            self.maskView.hidden = YES;
            
            _arrDateList = [dictResponse valueForKey:@"tasklist"];
            [self.tableViewList reloadData];
            [self.view addSubview:self.tableViewList];
        } andFailureBlock:^(NSError *error) {
            self.maskView.hidden = YES;
        }];
    }else{
        _bMyDateList = NO;
        [self.tableViewList removeFromSuperview];
    }
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewList) {
        return 75;
    }else{
        return 75;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableViewList) {
        return _arrDateList.count;
    }else{
        return _arrDateTask.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewList) {
        static NSString *cellIndenfier = @"MyTaskListTableViewCell";
        MyTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
        
        if (!cell) {
            cell = [[MyTaskListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        }
        
        NSDictionary *dictItem = [_arrDateList objectAtIndex:indexPath.row];
        [cell.imageViewLogo setImageWithURL:urlFromImageURLstr([dictItem valueForKey:@"img"]) placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.labelDate.text = [dictItem valueForKey:@"time"];
        cell.labelTitle.text = [dictItem valueForKey:@"location"];
        cell.labelDescription.text = [dictItem valueForKey:@"summary"];
        
        return cell;
    }else{
        static NSString *cellIndenfier = @"MyTaskDateTableViewCell";
        MyTaskDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
        if (!cell) {
            cell = [[MyTaskDateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
        }
        NSDictionary *dict = [_arrDateTask objectAtIndex:indexPath.row];
        cell.labelTitle.text = [dict valueForKey:@"location"];
        cell.labelDescription.text = [dict valueForKey:@"summary"];
        [cell.imageViewLogo setImageWithURL:urlFromImageURLstr([dict valueForKey:@"img"]) placeholderImage:[UIImage imageNamed:@"no_image"]];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TaskDetailViewController *taskVC = [[TaskDetailViewController alloc] init];
     if (tableView == self.tableViewList) {
         NSDictionary *dictItem = [_arrDateList objectAtIndex:indexPath.row];
         taskVC.strTaskId = [dictItem valueForKey:@"taskId"];
     }else{
         NSDictionary *dictItem = [_arrDateTask objectAtIndex:indexPath.row];
         taskVC.strTaskId = [dictItem valueForKey:@"taskId"];
     }
     [self.navigationController pushViewController:taskVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
