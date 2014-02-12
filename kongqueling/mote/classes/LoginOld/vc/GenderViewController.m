//
//  GenderViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "GenderViewController.h"
#import "CityViewController.h"
@interface GenderViewController ()

@end

@implementation GenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr{
    
    messArray=MessageArr;
    return self;
    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
	self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    
    self.title = @"选择性别(5/6)";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"选择性别" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
     NSArray *objrctArr=[[NSArray alloc] initWithObjects:@"xb_03.png",@"xb_05.png", nil];
    for (int i=0; i<2; i++) {
        UIButton *selectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectbtn.tag=20+i;
        selectbtn.frame=CGRectMake(10+151*i,35, 150, 45);
        [selectbtn setBackgroundImage:[UIImage imageNamed:[objrctArr objectAtIndex:i]] forState:UIControlStateNormal];
        [selectbtn addTarget:self action:@selector(selectTheProfession:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectbtn];
    }
    
    UILabel *inforLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 85, 300, 40)];
    inforLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
    inforLabel.backgroundColor=[UIColor clearColor];
    inforLabel.text=@"确认提交后性别将不能修改";
    inforLabel.textColor=[UIColor grayColor];
    [self.view addSubview:inforLabel];

    genderStr=@"";

}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)nextToFinishYourInformation{
    if ([genderStr isEqualToString:@""]) {
        genderStr=@"N";
    }
     if ([messArray count]<5) {
    [messArray addObject:genderStr];
     }
     else{
         [messArray removeObjectAtIndex:[messArray count]-1];
         [messArray addObject:genderStr];
     }

    NSLog(@"-----%@",messArray);
    CityViewController *cityVC=[[CityViewController alloc] initWithTheMessArray:messArray];
    [self.navigationController pushViewController:cityVC animated:YES];
}

-(void)selectTheProfession:(id)sender{
    nextbtn.enabled=YES;
    [nextbtn setBackgroundImage:[UIImage imageNamed:@"next_step_0.png"] forState:UIControlStateNormal];
    UIButton *nanbtn=(UIButton *)[self.view viewWithTag:20];
    UIButton *nvbtn=(UIButton *)[self.view viewWithTag:21];
    [nanbtn setBackgroundImage:[UIImage imageNamed:@"xb_03.png"] forState:UIControlStateNormal];
    [nvbtn setBackgroundImage:[UIImage imageNamed:@"xb_05.png"] forState:UIControlStateNormal];
    
    UIButton *senbtn=(UIButton *)sender;
    switch (senbtn.tag) {
        case 20:{
            genderStr=@"M";
            [nanbtn setBackgroundImage:[UIImage imageNamed:@"876543_03.png"] forState:UIControlStateNormal];
        }
            break;
        case 21:{
            genderStr=@"F";
            [nvbtn setBackgroundImage:[UIImage imageNamed:@"876543_05.png"] forState:UIControlStateNormal];
        }
            break;
      
        default:
            break;
    }
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_0.png" selector:@selector(nextToFinishYourInformation) target:self];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
