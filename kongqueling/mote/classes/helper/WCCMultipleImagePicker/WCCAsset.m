//
//  WCCAsset.m
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import "WCCAsset.h"
#import "WCCAssetTablePicker.h"

@implementation WCCAsset

@synthesize asset = _asset;
@synthesize parent = _parent;
@synthesize selected = _selected;

- (id)initWithAsset:(ALAsset*)asset
{
	self = [super init];
	if (self) {
		self.asset = asset;
        _selected = NO;
    }
    
	return self;
}

- (void)toggleSelection
{
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        if (_parent != nil && [_parent respondsToSelector:@selector(assetSelected:)]) {
            [_parent assetSelected:self];
        }
    }
}

- (void)dealloc
{
    
}

@end
