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
    self.view.backgroundColor=[UIColor whiteColor];
    _catTableview.backgroundColor = [UIColor whiteColor];
    _catTableview.frame = CGRectMake(0, 0, 320, 200);
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
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UILabel *labelName = [[UILabel alloc] init];
        labelName.font = [UIFont systemFontOfSize:17];
        labelName.textColor = [UIColor blackColor];
        labelName.frame = CGRectMake(17, 12, 200, 20);
        labelName.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labelName];
    }
    
    UILabel *nameLabel = (UILabel *)[cell.contentView subviews][0];
        
            
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



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    MessageListViewController *mslvc = [[MessageListViewController alloc] initWithNibName:@"MessageListViewController" bundle:nil];
    mslvc.msgTypeId = indexPath.row+1;
    [self.navigationController pushViewController:mslvc animated:YES];
       
}


@end
