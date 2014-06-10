//
//  MessageListViewController.m
//  mote
//
//  Created by harry on 13-12-30.
//  Copyright (c) 2013年 zlm. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageDetailViewController.h"

@interface MessageListViewController (){
    NSMutableArray *msgArr;
}

@end

@implementation MessageListViewController

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
    // Do any additional setup after loading the view from its nib.
    
    if (_msgTypeId==1) {
        self.title = @"系统消息";
    }
    if (_msgTypeId==2) {
        self.title = @"任务消息";
    }
    if (_msgTypeId==3) {
        self.title = @"邀约消息";
    }
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"delete.png" selector:@selector(onDelete) target:self];
    
    _msglistTableview.backgroundColor = MOKA_VIEW_BG_COLOR_BLUE;
    
    msgArr = [[NSMutableArray alloc] init];
    
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [msgArr removeAllObjects];
    NSString *strUrl = [UrlHelper stringUrlMessageList:_msgTypeId iPage:0];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        NSLog(@"success");
        
        [msgArr addObjectsFromArray:[dictResponse valueForKey:@"msginfo"]];
        
        float heigh = 135*[msgArr count]>MOKA_SCREEN_HEIGHT?MOKA_SCREEN_HEIGHT:135*[msgArr count];
        _msglistTableview.frame = CGRectMake(0, 0, 320, heigh);
        if (!msgArr.count) {
            [[ToastViewAlert defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"您暂时还没有%@",self.title]];
        }else{
            [_msglistTableview reloadData];
        }
        
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

- (void)onDelete{
    _msglistTableview.editing = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"complete.png" selector:@selector(onComplete) target:self];
}

- (void)onComplete{
    _msglistTableview.editing = NO;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"delete.png" selector:@selector(onDelete) target:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table view methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [msgArr count];
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
        
        UIImage *bgimg = [UIImage imageNamed:@"message_cell_bg.png"];
        UIImageView *bgimgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 104)];
        bgimgv.image = bgimg;
        [cell.contentView addSubview:bgimgv];
        
        UILabel *labelTime = [[UILabel alloc] init];
        labelTime.font = [UIFont boldSystemFontOfSize:13];
        labelTime.textColor = [UIColor blackColor];
        labelTime.frame = CGRectMake(22, 15, 120, 20);
        labelTime.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labelTime];
        
        UILabel *labelConfrimTime = [[UILabel alloc] init];
        labelConfrimTime.font = [UIFont systemFontOfSize:13];
        labelConfrimTime.textColor = [UIColor blackColor];
        labelConfrimTime.frame = CGRectMake(120, 19, 180, 20);
        labelConfrimTime.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:labelConfrimTime];
        
        UILabel *labelDetail = [[UILabel alloc] init];
        labelDetail.font = [UIFont systemFontOfSize:13];
        labelDetail.textColor = [UIColor blackColor];
        labelDetail.numberOfLines = 2;
        labelDetail.frame = CGRectMake(22, 50, 250, 40);
        labelDetail.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:labelDetail];
    }
    
    NSDictionary *dic = [msgArr objectAtIndex:indexPath.row];
    
    UILabel *labelTime = (UILabel *)[cell.contentView subviews][1];
    UILabel *labelConfrimTime = (UILabel *)[cell.contentView subviews][2];
    UILabel *labelDetail = (UILabel *)[cell.contentView subviews][3];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"]; //
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"add_time"] intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    labelTime.text = confromTimespStr;
    
    
    labelDetail.text = [dic objectForKey:@"content"];
    
	return cell;
}


- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellAccessoryDisclosureIndicator;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    MessageDetailViewController *msdvc = [[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController" bundle:nil];
    msdvc.msgTypeId = _msgTypeId;
    msdvc.msgInfo = [msgArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:msdvc animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *strAlbum = [UrlHelper stringUrlMessageDelete];
        NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
        
        [dicParameter setObject:[[msgArr objectAtIndex:indexPath.row] objectForKey:@"id"] forKey:@"msgId"];
        
        [self actionRequestWithUrl:strAlbum parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
            NSInteger errorNo = [[dictResponse valueForKey:@"code"] integerValue];
            if (errorNo == 1) {
                [msgArr removeObjectAtIndex:indexPath.row];
                
//                NSMutableArray *rindexs = [[NSMutableArray alloc] init];
//                NSIndexPath *path2 = [NSIndexPath indexPathForRow:tagid inSection:0];
//                [rindexs addObject:path2];
//                
//                [_tbGoods beginUpdates];
//                [_tbGoods deleteRowsAtIndexPaths:rindexs withRowAnimation:UITableViewRowAnimationRight];
//                [_tbGoods endUpdates];
                  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } andFailureBlock:^(NSError *error) {
            
        }];    }
}

@end
