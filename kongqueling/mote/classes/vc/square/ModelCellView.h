//
//  SquareCellView.h
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GirlModel.h"


@protocol ModelCellViewDelegate <NSObject>

@optional

- (void)didSeletedModelViewWith:(NSUInteger)uid;

@end

@interface ModelCellView : UIView

@property (strong, nonatomic) GirlModel *model;

@property(nonatomic,assign) id<ModelCellViewDelegate> delegate;

- (void)prepareForReuse;
- (id)initWIthModel:(GirlModel *)gModels;
- (void)loadSubviews;
@end
