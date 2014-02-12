//
//  ProfessionViewController.m
//  Login
//
//  Created by ruisheng on 13-11-4.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "ProfessionViewController.h"
#import "GenderViewController.h"
@interface ProfessionViewController ()

@end

@implementation ProfessionViewController

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
    
    self.title = @"选择职业(4/6)";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"选择职业" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
    UIImageView *subimg=[[UIImageView alloc] initWithFrame:CGRectMake(10, 27, 300, 120)];
    subimg.image=[UIImage imageNamed:@"9876543_03.png"];
    [self.view addSubview:subimg];

    NSArray *objrctArr=[[NSArray alloc] initWithObjects:@"摄影师",@"模特",@"造型师", nil];
    for (int i=0; i<3; i++) {
        UILabel *subLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 30+39*i, 200, 40)];
        subLabel.font=[UIFont fontWithName:KdefaultFont size:KRegFontSize];
        subLabel.backgroundColor=[UIColor clearColor];
        subLabel.text=[objrctArr objectAtIndex:i];
        [self.view addSubview:subLabel];
        
        UIButton *selectbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        selectbtn.tag=10+i;
        selectbtn.frame=CGRectMake(260,39+38*i, 20, 20);
        
        [selectbtn setImage:[UIImage imageNamed:@"8965432_06.png"] forState:UIControlStateNormal];
        [selectbtn addTarget:self action:@selector(selectTheProfession:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectbtn];

    }
    shoot=NO;
    model=NO;
    style=NO;
    professStr=@"";

    
}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)nextToFinishYourInformation{
    if([sheStr length]>0){
        professStr = [professStr stringByAppendingFormat:@"%@|",sheStr];
    }
    if([moteStr length]>0){
        professStr = [professStr stringByAppendingFormat:@"%@|",moteStr];
    }
    if([zaoStr length]>0){
        professStr = [professStr stringByAppendingFormat:@"%@|",zaoStr];
    }
    professStr = [professStr substringToIndex:[professStr length]-1];
    
    if ([professStr isEqualToString:@""]) {
        professStr=@"";
    }
    
    if ([messArray count]<4) {
        [messArray addObject:professStr];
    }
    else{
        [messArray removeObjectAtIndex:[messArray count]-1];
        [messArray addObject:professStr];
    }
    NSLog(@"-----%@",messArray);

    GenderViewController *genderVC=[[GenderViewController alloc] initWithTheMessArray:messArray];
    [self.navigationController pushViewController:genderVC animated:YES];
}

- (void)clickButton:(int)tagid{
    
    nextbtn.enabled=YES;
    [nextbtn setBackgroundImage:[UIImage imageNamed:@"next_step_0.png"] forState:UIControlStateNormal];
    UIButton *subbtn1=(UIButton *)[self.view viewWithTag:10];
    UIButton *subbtn2=(UIButton *)[self.view viewWithTag:11];
    UIButton *subbtn3=(UIButton *)[self.view viewWithTag:12];
    
    switch (tagid) {
        case 10:{
            if (shoot==NO) {
                sheStr=@"p";
                [subbtn1 setImage:[UIImage imageNamed:@"8965432_09.png"] forState:UIControlStateNormal];
                shoot=YES;
            }
            else{
                sheStr=@"";
                [subbtn1 setImage:[UIImage imageNamed:@"8965432_06.png"] forState:UIControlStateNormal];
                shoot=NO;
                
            }
            
        }
            break;
        case 11:{
            if (model==NO) {
                moteStr=@"m";
                [subbtn2 setImage:[UIImage imageNamed:@"8965432_09.png"] forState:UIControlStateNormal];
                model=YES;
            }
            else{
                moteStr=@"";
                [subbtn2 setImage:[UIImage imageNamed:@"8965432_06.png"] forState:UIControlStateNormal];
                model=NO;
            }
        }
            break;
        case 12:{
            if (style==NO) {
                zaoStr=@"d";
                [subbtn3 setImage:[UIImage imageNamed:@"8965432_09.png"] forState:UIControlStateNormal];
                style=YES;
            }
            
            else{
                zaoStr=@"";
                [subbtn3 setImage:[UIImage imageNamed:@"8965432_06.png"] forState:UIControlStateNormal];
                style=NO;
                
            }
        }
            break;
        default:
            break;
    }
    
    if (style || model || shoot) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_0.png" selector:@selector(nextToFinishYourInformation) target:self];
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    }
}

-(void)selectTheProfession:(id)sender{
    
    UIButton *senbtn=(UIButton *)sender;
    [self clickButton:senbtn.tag];

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *start = [[event allTouches] anyObject];
    CGPoint StartPoint = [start locationInView:self.view];
    NSLog(@"start points x : %f y : %f", StartPoint.x, StartPoint.y);
    
    CGRect rect1 = CGRectMake(20, 30+39*0, 300, 40);
    CGRect rect2 = CGRectMake(20, 30+39*1, 300, 40);
    CGRect rect3 = CGRectMake(20, 30+39*2, 300, 40);
    
    if (CGRectContainsPoint(rect1, StartPoint)) {
        [self clickButton:10];
    }
    if (CGRectContainsPoint(rect2, StartPoint)) {
        [self clickButton:11];
    }
    if (CGRectContainsPoint(rect3, StartPoint)) {
        [self clickButton:12];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
