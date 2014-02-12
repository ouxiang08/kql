//
//  MakingMokaViewController.m
//  mote
//
//  Created by sean on 11/9/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "MakingMokaViewController.h"
#import "EditProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FrameModel.h"

@interface MakingMokaViewController ()


@end

@implementation MakingMokaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.arrImageView = [[NSMutableArray alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"生成模卡";
    UIBarButtonItem *rightButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"编辑资料" selector:@selector(onEditProfile) target:self];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    [self addImageViewToView:[self.dicMoka valueForKey:@"imageInfo"]];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)onEditProfile{
    EditProfileViewController *editProfileViewController = [[EditProfileViewController alloc] init];
    //UIGraphicsBeginImageContext(CGSizeMake(self.viewMokaCenter.frame.size.width, self.viewMokaCenter.frame.size.height+20));
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.viewMokaCenter.frame.size.width, self.viewMokaCenter.frame.size.height+20),NO,0);
    [self.viewMokaCenter.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    //UIImageWriteToSavedPhotosAlbum(viewImage,nil,nil,nil);
    UIGraphicsEndImageContext();
    //NSLog(@"%@",NSStringFromCGSize(viewImage.size));
    editProfileViewController.imageMoka = viewImage;
    [self.navigationController pushViewController:editProfileViewController animated:YES];
}

-(void)addImageViewToView:(NSArray *)arrImageFrame{
    CGFloat widthCenter = [[self.dicMoka valueForKey:@"width"] floatValue]/2;
    CGFloat heightCenter = [[self.dicMoka valueForKey:@"heigh"] floatValue]/2;
    CGFloat orginX = (self.view.frame.size.width-widthCenter)/2;
    CGFloat orginY = (self.view.frame.size.height-heightCenter)/2;
//    UIImageView *imageViewCenterBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthCenter, heightCenter)];
//    [imageViewCenterBg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KTemplateImageUrlDefault,[self.dicMoka valueForKey:@"thumbnailPath"]]] placeholderImage:[UIImage imageNamed:@"no_image"]];
    self.viewMokaCenter.frame = CGRectMake(orginX, orginY, widthCenter, heightCenter);
    
    UIView *imageViewCenterBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, widthCenter, heightCenter)];
    imageViewCenterBg.backgroundColor = [UIColor whiteColor];
    [self.viewMokaCenter addSubview:imageViewCenterBg];
    
    for (int i=0; i<arrImageFrame.count; i++) {
        NSDictionary *dictFrame = [arrImageFrame objectAtIndex:i];
        FrameModel *frameModel = [[FrameModel alloc] initWithDictionary:dictFrame];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameModel.x, frameModel.y,frameModel.width,frameModel.height)];
        imageView.image = [self.arrImage objectAtIndex:i];
        imageView .contentMode = KimageShowMode;
        [imageView setClipsToBounds:YES];
        [self.arrImageView addObject:imageView];
        [self.viewMokaCenter addSubview:imageView];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self.viewMokaCenter];
    for (UIImageView *imageView in self.arrImageView) {
        if(CGRectContainsPoint(imageView.frame, location)){
            self.imageViewStart = imageView;
            break;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.imageViewStart) {
        for (UIImageView *imageView in self.arrImageView) {
            [imageView.layer setBorderWidth:2];
            [imageView.layer setBorderColor:[[UIColor clearColor] CGColor]];
        }
        
        for (UIImageView *imageView in self.arrImageView) {
            CGPoint location = [[touches anyObject] locationInView:self.viewMokaCenter];
            if(CGRectContainsPoint(imageView.frame, location)&&imageView!=self.imageViewStart){
                [imageView.layer setBorderWidth:2];
                [imageView.layer setBorderColor:[[UIColor redColor] CGColor]];
                break;
            }
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if(self.imageViewStart){
        for (UIImageView *imageView in self.arrImageView) {
            [imageView.layer setBorderWidth:2];
            [imageView.layer setBorderColor:[[UIColor clearColor] CGColor]];
        }
        
        CGPoint location = [[touches anyObject] locationInView:self.viewMokaCenter];
        
        for (UIImageView *imageView in self.arrImageView) {
            if(CGRectContainsPoint(imageView.frame, location)){
                self.imageViewEnd = imageView;
                break;
            }
        }
        
        [self changePicture];
    }
}

-(void)changePicture{
    if (self.imageViewStart&&self.imageViewEnd) {
        UIImage *image = self.imageViewStart.image;
        self.imageViewStart.image = self.imageViewEnd.image;
        self.imageViewEnd.image = image;
    }
    
    self.imageViewStart = nil;
    self.imageViewEnd = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
