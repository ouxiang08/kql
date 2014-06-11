//
//  SquareCellView.m
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "ModelCellView.h"

#define avatarImgHeight 135
#define avatarImgWidth 146

@interface ModelCellView (){

     UIImageView *_avatarImgV;
     UILabel *_nameLbl;
     UIImageView *_genderImgV;
     UILabel *_cityLbl;
     UILabel *_cateLbl;
     UILabel *_bWHLbl;
     UILabel *_priceLbl;
     UIImageView *_vipImgV;
     UIImageView *_lineImgV;

}

@end

@implementation ModelCellView

@synthesize model;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"modelCellBg"]]];
    }
    return self;
}

- (id)initWIthModel:(GirlModel *)gModels
{
    self = [super init];
    if (self) {
        self.model = gModels;
        [self loadSubviews];
    }
    return self;
}


-(void)loadSubviews{
    
    //头像
    _avatarImgV = [[UIImageView alloc] init];
    _avatarImgV.frame = CGRectMake(0, 0, avatarImgWidth, avatarImgHeight);
    _avatarImgV.backgroundColor = [UIColor clearColor];
    [_avatarImgV setImageWithURL:[NSURL URLWithString:model.avatarPath]];
    _avatarImgV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_avatarImgV];
    //姓名
    _nameLbl = [[UILabel alloc] init];
    CGSize  nameSize = [self sizeForLalbelWithContont:model.nickName andFontSize:15.0f];
    CGFloat nameWidth = nameSize.width>70 ? 70 : nameSize.width;
    _nameLbl.frame = CGRectMake(5, 138, nameWidth, nameSize.height);
    _nameLbl.backgroundColor = [UIColor clearColor];
    _nameLbl.textColor = [UIColor blackColor];
    _nameLbl.font = [UIFont systemFontOfSize:15.0f];
    _nameLbl.text = model.nickName;
    [self addSubview:_nameLbl];
    //性别和年龄
    _genderImgV = [[UIImageView alloc] init];
    UIImage *genderImg = nil;
    
    UILabel *ageLbl = [[UILabel alloc] init];
    ageLbl.frame = CGRectMake(14, 0, 15, 12);
    ageLbl.textColor = [UIColor whiteColor];
    ageLbl.font = [UIFont systemFontOfSize:10.0f];
    
    if ([model.gender isEqualToString:@"女"]) {
        
        if (model.age > 0 ) {
            genderImg = [UIImage imageNamed:@"female_big"];
            ageLbl.text = [NSString stringWithFormat:@"%d",model.age];
            [_genderImgV addSubview:ageLbl];
        }else{
            
            genderImg = [UIImage imageNamed:@"female_small"];
        }
        _genderImgV.frame = CGRectMake(nameWidth+5, 143, genderImg.size.width, genderImg.size.height);
    }else{
        if (model.age > 0) {
            
            genderImg = [UIImage imageNamed:@"male_big"];
            ageLbl.text = [NSString stringWithFormat:@"%d",model.age];
            [_genderImgV addSubview:ageLbl];
        }else{
            genderImg = [UIImage imageNamed:@"male_small"];
        }
        _genderImgV.frame = CGRectMake(nameWidth+5, 143, genderImg.size.width, genderImg.size.height);
    }
    _genderImgV.image = genderImg;
    [self addSubview:_genderImgV];
    //居住地
    _cityLbl = [[UILabel alloc] init];
    CGSize citySize = [self sizeForLalbelWithContont:model.city andFontSize:14.0f];
    CGFloat cityWidth = citySize.width>45 ? 45 : citySize.width;
    _cityLbl.frame = CGRectMake(avatarImgWidth-cityWidth, 138, cityWidth, citySize.height);
    _cityLbl.backgroundColor = [UIColor clearColor];
    _cityLbl.textColor = [UIColor blackColor];
    _cityLbl.font = [UIFont systemFontOfSize:14.0f];
    _cityLbl.text = model.city;
    [self addSubview:_cityLbl];
    
    //line
    _lineImgV = [[UIImageView alloc] init];
    _lineImgV.frame = CGRectMake(0, 162, avatarImgWidth, 1);
    _lineImgV.image = [UIImage imageNamed:@"avatarLine"];
    [self addSubview:_lineImgV];
    
    //身高和体重
    _bWHLbl = [[UILabel alloc] init];
    _bWHLbl.textColor = [UIColor lightGrayColor];
    _bWHLbl.backgroundColor = [UIColor clearColor];
    _bWHLbl.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_bWHLbl];
    
    if ([model.cate isNotNilOrBlankString]) {
        
        _bWHLbl.frame = CGRectMake(65, 165, 80, 15);
        //类别
        _cateLbl = [[UILabel alloc] init];
        _cateLbl.frame = CGRectMake(10, 165, 50, 15);
        _cateLbl.backgroundColor = [UIColor clearColor];
        _cateLbl.textColor = [UIColor lightGrayColor];
        _cateLbl.font = [UIFont systemFontOfSize:12.0f];
        _cateLbl.text = model.cate;
        [self addSubview:_cateLbl];
    }else{
        
        _bWHLbl.frame = CGRectMake(10, 165, 80, 15);
    }
    _bWHLbl.text = [NSString stringWithFormat:@"%@cm/%@kg",model.height,model.weight];
    [self addSubview:_bWHLbl];
    
    if ([model.price isNotNilOrBlankString]) {
        NSString *priStr = [NSString stringWithFormat:@"￥%@",model.price];
        CGSize priceSize = [self sizeForLalbelWithContont:priStr andFontSize:16.0f];
        _priceLbl = [[UILabel alloc] init];
        _priceLbl.frame = CGRectMake(10, 182, priceSize.width, priceSize.height);
        //_priceLbl.textColor = [UIColor colorWithRed:255 green:139 blue:35 alpha:0];
        _priceLbl.textColor = [UIColor orangeColor];
        _priceLbl.font = [UIFont systemFontOfSize:16.0f];
        _priceLbl.text = [NSString stringWithFormat:@"￥%@",model.price];
        [self addSubview:_priceLbl];
    }
    //是否是Vip
    if (model.isVip==1) {
        _vipImgV = [[UIImageView alloc] init];
        _vipImgV.frame = CGRectMake(125, 182, 15, 15);
        _vipImgV.image = [UIImage imageNamed:@"π"];
        [self addSubview:_vipImgV];
    }
}

- (void)prepareForReuse {
    
    self.model = nil;
    _avatarImgV.image = nil;
    _nameLbl = nil;
    _genderImgV.image = nil;
    _cityLbl = nil;
    _cateLbl = nil;
    _bWHLbl = nil;
    _priceLbl = nil;
    _vipImgV.image = nil;
    _lineImgV.image = nil;
}

- (CGSize)sizeForLalbelWithContont:(NSString *)content andFontSize:(CGFloat)fontSize{

    CGSize  size = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(avatarImgWidth, 2000) lineBreakMode:NSLineBreakByWordWrapping];
    return size;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	NSUInteger tapCount = touch.tapCount;
	switch (tapCount) {
		case 1:
			[self handleSingleTap:touch];
			break;
		default:
			break;
	}
	[[self nextResponder] touchesEnded:touches withEvent:event];
}
- (void)handleSingleTap:(UITouch *)touch {
	if ([_delegate respondsToSelector:@selector(didSeletedModelViewWith:)])
		[_delegate didSeletedModelViewWith:model.uid];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
