//
//  SetHomePictureViewController.m
//  mote
//
//  Created by sean on 1/5/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "SetHomePictureTableViewCell.h"
#import "SetHomePictureViewController.h"

@interface SetHomePictureViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SetHomePictureViewController

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
    self.title = @"设置封面";
    // Do any additional setup after loading the view from its nib.
}

-(void)clickCellButton:(UIButton *)button{
    [self.delegate setHomePictureWithIndex:button.tag];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (_arrImageUrl.count+3)/4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 79;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIndenfier = @"SetHomePictureTableViewCell";
    SetHomePictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfier];
    if (!cell) {
        cell = [[SetHomePictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfier];
    }
    
    NSString *strUrl1 = [_arrImageUrl objectAtIndex:indexPath.row*4];
    [cell.imageView1 setImageWithURL:urlFromImageURLstr(strUrl1) placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.imageView1.contentMode = KimageShowMode;
    [cell.imageView1 setClipsToBounds:YES];
    cell.buttonSelected1.tag = indexPath.row*4;
    [cell.buttonSelected1 addTarget:self action:@selector(clickCellButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row*4+1<_arrImageUrl.count) {
        NSString *strUrl2 = [_arrImageUrl objectAtIndex:indexPath.row*4+1];
        [cell.imageView2 setImageWithURL:urlFromImageURLstr(strUrl2) placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView2.contentMode = KimageShowMode;
        [cell.imageView2 setClipsToBounds:YES];
        cell.buttonSelected2.tag = indexPath.row*4+1;
        [cell.buttonSelected2 addTarget:self action:@selector(clickCellButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row*4+2<_arrImageUrl.count) {
        NSString *strUrl3 = [_arrImageUrl objectAtIndex:indexPath.row*4+2];
        [cell.imageView3 setImageWithURL:urlFromImageURLstr(strUrl3) placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView3.contentMode = KimageShowMode;
        [cell.imageView3 setClipsToBounds:YES];
        cell.buttonSelected3.tag = indexPath.row*4+2;
        [cell.buttonSelected3 addTarget:self action:@selector(clickCellButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (indexPath.row*4+3<_arrImageUrl.count) {
        NSString *strUrl4 = [_arrImageUrl objectAtIndex:indexPath.row*4+3];
        [cell.imageView4 setImageWithURL:urlFromImageURLstr(strUrl4) placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.imageView4.contentMode = KimageShowMode;
        [cell.imageView4 setClipsToBounds:YES];
        cell.buttonSelected4.tag = indexPath.row*4+3;
        [cell.buttonSelected4 addTarget:self action:@selector(clickCellButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    

    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
