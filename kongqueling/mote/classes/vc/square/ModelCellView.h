//
//  SquareCellView.h
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GirlModel.h"

@interface ModelCellView : UIView

@property (strong, nonatomic) GirlModel *model;

- (void)prepareForReuse;
- (id)initWIthModel:(GirlModel *)gModels;
- (void)loadSubviews;
@end
