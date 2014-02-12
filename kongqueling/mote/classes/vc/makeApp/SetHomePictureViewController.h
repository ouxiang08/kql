//
//  SetHomePictureViewController.h
//  mote
//
//  Created by sean on 1/5/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetHomePictureDelegate <NSObject>

-(void)setHomePictureWithIndex:(int)index;

@end

@interface SetHomePictureViewController : UIViewController

@property(nonatomic, strong) IBOutlet UITableView *tableViewPicture;
@property(nonatomic, strong) NSArray *arrImageUrl;
@property(nonatomic, assign) id<SetHomePictureDelegate>delegate;

@end
