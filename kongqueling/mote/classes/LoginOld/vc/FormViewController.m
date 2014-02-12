//
//  FormViewController.m
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "FormViewController.h"
#import "SelectFormViewController.h"
#import "SelectShootViewController.h"
#import "SelectStyleViewController.h"

#import "NickNameViewController.h"
@interface FormViewController (){
     NSMutableArray *typeItemArr;
}

@end

@implementation FormViewController
@synthesize formString;
@synthesize modeString;
@synthesize sheString;
@synthesize zaoString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
//       formLabel.text=[NSString stringWithFormat:@"    模特类型：%@",self.modeString];
//       sheformLabel.text=[NSString stringWithFormat:@"摄影师类型：%@",self.sheString];
//       zaoformLabel.text=[NSString stringWithFormat:@"摄影师类型：%@",self.zaoString];

    //self.formString=[NSString stringWithFormat:@"%@|%@|%@",self.modeString,self.sheString,self.zaoString];
    
    NSString *jobcatStr=[messArray objectAtIndex:3];
    NSArray *jobarr = [jobcatStr componentsSeparatedByString:@"|"];
    
    int fillcnt = 0;
    for (int i=0; i<[typeItemArr count]; i++) {
        UILabel *formLabel = [typeItemArr objectAtIndex:i];
        if ([[jobarr objectAtIndex:i] isEqualToString:@"m"]) {
            formLabel.text=[NSString stringWithFormat:@"模特类型：%@",self.modeString];
            if([self.modeString length]>0)fillcnt++;
        }
        if ([[jobarr objectAtIndex:i] isEqualToString:@"p"]) {
            formLabel.text=[NSString stringWithFormat:@"摄影师类型：%@",self.sheString];
            if([self.sheString length]>0)fillcnt++;
        }
        if ([[jobarr objectAtIndex:i] isEqualToString:@"d"]) {
            formLabel.text=[NSString stringWithFormat:@"化妆师类型：%@",self.zaoString];
            if([self.zaoString length]>0)fillcnt++;
        }
    }
    if (fillcnt==[jobarr count]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_0.png" selector:@selector(nextWriteMoreInformation) target:self];
    }
}

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr{
    
    messArray=MessageArr;
    return self;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    self.title = @"选择类型(1/3)";
     self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"选择类型" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
    self.formString=@"";
    self.modeString=@"";
    self.sheString=@"";
    self.zaoString=@"";
    typeItemArr = [[NSMutableArray alloc] init];
    
    NSString *jobcatStr=[messArray objectAtIndex:3];
    NSArray *jobarr = [jobcatStr componentsSeparatedByString:@"|"];
    float fromy = 25;
    
    for (int i=0; i<[jobarr count]; i++) {
        NSString *jobname = [jobarr objectAtIndex:i];
        UIImageView *labImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, fromy,300, 38)];
        labImage.image=[UIImage imageNamed:@"text_box.png"];
        [self.view addSubview:labImage];
        
        UILabel *formLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, fromy,290, 38)];
        if ([jobname isEqualToString:@"m"]) {
            formLabel.text=[NSString stringWithFormat:@"模特类型：%@",self.modeString];
        }
        if ([jobname isEqualToString:@"p"]) {
            formLabel.text=[NSString stringWithFormat:@"摄影师类型：%@",self.modeString];
        }
        if ([jobname isEqualToString:@"d"]) {
            formLabel.text=[NSString stringWithFormat:@"化妆师类型：%@",self.modeString];
        }
        
        formLabel.backgroundColor=[UIColor clearColor];
        [formLabel setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
        [self.view addSubview:formLabel];
        [typeItemArr addObject:formLabel];
        
        UIButton *modebtn=[UIButton buttonWithType:UIButtonTypeCustom];
        modebtn.frame=CGRectMake(10, fromy,300, 30);
        if ([jobname isEqualToString:@"m"]) {
            [modebtn addTarget:self action:@selector(modelTheSelectTheMode) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([jobname isEqualToString:@"p"]) {
            [modebtn addTarget:self action:@selector(modelTheSelectTheshe) forControlEvents:UIControlEventTouchUpInside];
        }
        if ([jobname isEqualToString:@"d"]) {
            [modebtn addTarget:self action:@selector(modelTheSelectTheZao) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:modebtn];
        
        fromy+=50;
    }
    
    
}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)modelTheSelectTheMode{
    
    SelectFormViewController *selectformVC=[[SelectFormViewController alloc] initWithVC:self];
    [self presentViewController:selectformVC animated:YES completion:^(void){}];
}

-(void)modelTheSelectTheshe{
    SelectShootViewController *selectshootVC=[[SelectShootViewController alloc] initWithVC:self];
    [self presentViewController:selectshootVC animated:YES completion:^(void){}];
}


-(void)modelTheSelectTheZao{
    SelectStyleViewController *selectstyleVC=[[SelectStyleViewController alloc] initWithVC:self];
    [self presentViewController:selectstyleVC animated:YES completion:^(void){}];
}



-(void)nextWriteMoreInformation{
    
    //self.formString=[NSString stringWithFormat:@"%@|%@|%@",modeString,sheString,zaoString];
    
    if([modeString length]>0){
        self.formString = [self.formString stringByAppendingFormat:@"%@|",modeString];
    }
    if([sheString length]>0){
        self.formString = [self.formString stringByAppendingFormat:@"%@|",sheString];
    }
    if([zaoString length]>0){
        self.formString = [self.formString stringByAppendingFormat:@"%@|",zaoString];
    }
    self.formString = [self.formString substringToIndex:[self.formString length]-1];
    
    NSLog(@">>>>>>>  %@",self.formString);
      if ([self.formString isEqualToString:@""]){
        self.formString=@"";
      }
     if ([messArray count]<7) {
         [messArray addObject:self.formString];
         }
     else{
         [messArray removeObjectAtIndex:[messArray count]-1];
         [messArray addObject:self.formString];
        }
    NickNameViewController *nicknameVC=[[NickNameViewController alloc] initWithTheMessArray:messArray];
    [self.navigationController pushViewController:nicknameVC animated:YES];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
