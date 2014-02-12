//
//  NickNameViewController.m
//  Login
//
//  Created by ruisheng on 13-11-5.
//  Copyright (c) 2013年 ruisheng. All rights reserved.
//

#import "NickNameViewController.h"
#import "HeadViewController.h"
@interface NickNameViewController ()

@end

@implementation NickNameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}

-(id)initWithTheMessArray:(NSMutableArray *)MessageArr{
    
    messArray=MessageArr;
    return self;
    
}



- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.view.backgroundColor=MOKA_VIEW_BG_COLOR_BLUE;
    self.title = @"填写昵称(2/3)";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"填写昵称" style: UIBarButtonItemStyleBordered target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
    UIImageView *labImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 25,300, 40)];
    labImage.image=[UIImage imageNamed:@"text_box.png"];
    [self.view addSubview:labImage];
     UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(20, 25,80, 40)];
    nameLabel.text=[NSString stringWithFormat:@"你的昵称："];
    nameLabel.backgroundColor=[UIColor clearColor];
    [nameLabel setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [self.view addSubview:nameLabel];
    
    nameText=[[UITextField alloc] initWithFrame:CGRectMake(100, 35, 210, 20)];
    nameText.backgroundColor=[UIColor clearColor];
    nameText.clearButtonMode=UITextFieldViewModeWhileEditing;
    [nameText setFont:[UIFont fontWithName:KdefaultFont size:KRegFontSize]];
    [nameText addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:nameText];


}

- (void)textFieldDidChange{
    if ([nameText.text length]>0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_0.png" selector:@selector(nextToFinishYourInformation) target:self];
        
    }else{
        self.navigationItem.rightBarButtonItem = [UIBarButtonItemFactory getBarButtonItemWithImage:@"next_step_1.png" selector:nil target:nil];
    }
}

-(void)backToTheUpLevel{
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)nextToFinishYourInformation{
    if ([nameText.text isEqualToString:@""]){
        nameText.text=@"无";
    }
    
     if ([messArray count]<8) {
    [messArray addObject:nameText.text];
     }
     else{
         [messArray removeObjectAtIndex:[messArray count]-1];
         [messArray addObject:nameText.text];
     }

    HeadViewController *headVC=[[HeadViewController alloc] initWithTheMessArray:messArray];
    [self.navigationController pushViewController:headVC animated:YES];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [nameText resignFirstResponder];
    

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
