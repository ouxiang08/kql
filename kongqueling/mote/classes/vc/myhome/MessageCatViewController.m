//
//  MessageCatViewController.m
//  mote
//
//  Created by harry on 13-12-30.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MessageCatViewController.h"
#import "MessageListViewController.h"

@interface MessageCatViewController ()
@end

@implementation MessageCatViewController

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
    
    self.title = @"我的消息";
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    _catTableview.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;

    //_catTableview.backgroundColor = [UIColor whiteColor];
//    CGRect tbrect = _catTableview.frame;
//    tbrect.size.height = 44*3;
//    _catTableview.frame = tbrect;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table view methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *areasCellIdentifier = @"catCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:areasCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:areasCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *labelName = [[UILabel alloc] init];
        labelName.font = [UIFont systemFontOfSize:17];
        labelName.textColor = [UIColor blackColor];
        labelName.frame = CGRectMake(17, 12, 200, 20);
        labelName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labelName];

        /*----------------------------------------jiajingjing--------------------------------------------*/
        UIImageView* badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(320-80, 12, 20, 20)];
        badgeView.image = [UIImage imageNamed:@"badge.png"];
        UILabel *badgeLabel = [[UILabel alloc]initWithFrame:badgeView.bounds];
        badgeLabel.textAlignment = NSTextAlignmentCenter;
        badgeLabel.backgroundColor = [UIColor clearColor];
        badgeLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLabel.textColor = [UIColor whiteColor];
        badgeView.tag = 2001;
        badgeView.hidden = YES;
        [badgeView addSubview:badgeLabel];
        [cell.contentView addSubview:badgeView];
    }

    UILabel *nameLabel = (UILabel *)[cell.contentView subviews][0];
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:2001];
    UILabel *msgLabel = (UILabel *)[imageView subviews][0];
    
    int num = [[[MainModel sharedObject] getNumByIndex:indexPath.row] intValue];
    if (num>0) {
        msgLabel.text = [NSString stringWithFormat:@"%d",num];
        imageView.hidden = NO;
    }else{
        imageView.hidden = YES;
    }
    
    switch (indexPath.row) {
        case 0:
            nameLabel.text = @"系统消息";
            break;
        case 1:
            nameLabel.text = @"任务消息";
            break;
        case 2:
            nameLabel.text = @"邀约消息";
            break;
        default:
            break;
    }
    
    
	return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    MessageListViewController *mslvc = [[MessageListViewController alloc] initWithNibName:@"MessageListViewController" bundle:nil];
    mslvc.msgTypeId = indexPath.row+1;
    [self.navigationController pushViewController:mslvc animated:YES];
    
    
    /*----------------------------------------jiajingjing--------------------------------------------*/
    NSString *firstNum = [[MainModel sharedObject] getNumByIndex:0];
    NSString *secondNum = [[MainModel sharedObject] getNumByIndex:1];
    NSString *thirdNum =  [[MainModel sharedObject] getNumByIndex:2];
    switch (indexPath.row) {
        case 0:
            [[MainModel sharedObject] saveMsgNum:@"0" secondNum:secondNum thirdNum:thirdNum];
            break;
        case 1:
            [[MainModel sharedObject] saveMsgNum:firstNum secondNum:@"0" thirdNum:thirdNum];
            break;
        case 2:
            [[MainModel sharedObject] saveMsgNum:firstNum secondNum:secondNum thirdNum:@"0"];
            break;
            
        default:
            break;
    }
    
    [tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kMessageDidChangeNofication object:nil];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
    // If you are not using ARC:
    // return [[UIView new] autorelease];
}


@end
