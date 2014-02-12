//
//  ChoosingBgMusicViewController.m
//  mote
//
//  Created by sean on 11/25/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "ChoosingBgMusicViewController.h"

@interface ChoosingBgMusicViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_arrMusic;
}

@end

@implementation ChoosingBgMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    _arrMusic = [[NSArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择背景音乐";
    
    NSString *strUrl = [UrlHelper stringUrlGetBgMudic];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _arrMusic = (NSArray *)dictResponse;
        [self.tableViewMusicList reloadData];
    } andFailureBlock:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrMusic.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
    NSDictionary *dictMusic = [_arrMusic objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictMusic valueForKey:@"name"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictMusic = [_arrMusic objectAtIndex:indexPath.row];
    [self.musicDelegate selectBgMusicWithDict:dictMusic];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
