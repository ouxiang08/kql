//
//  WCCAssetTablePicker.m
//  ImagePicker
//
//  Created by Hayden on 13-10-12.
//  Copyright (c) 2013年 Yardlan. All rights reserved.
//

#import "WCCAssetTablePicker.h"
#import "WCCAssetCell.h"
#import "WCCAsset.h"
#import "WCCAlbumPickerController.h"

@interface WCCAssetTablePicker ()

@property (nonatomic, assign) int columns;

@end

@implementation WCCAssetTablePicker
{
    NSInteger _iSelectedCount;
}
@synthesize parent = _parent;;
@synthesize selectedAssetsLabel = _selectedAssetsLabel;
@synthesize assetGroup = _assetGroup;
@synthesize elcAssets = _elcAssets;
@synthesize singleSelection = _singleSelection;
@synthesize columns = _columns;

- (void)viewDidLoad
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setAllowsSelection:NO];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;
	
    if (self.immediateReturn) {
        
    } else {
        UIBarButtonItem *doneButtonItem = [UIBarButtonItemFactory getBarButtonWithTitle:@"完成" selector:@selector(doneAction:) target:self];
        [self.navigationItem setRightBarButtonItem:doneButtonItem];
        [self.navigationItem setTitle:@"Loading..."];
    }
    
	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.columns = self.view.bounds.size.width / 80;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / 80;
    [self.tableView reloadData];
}

- (void)preparePhotos
{
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        
        if(result == nil) {
            return;
        }
        
        WCCAsset *elcAsset = [[WCCAsset alloc] initWithAsset:result];
        [elcAsset setParent:self];
        
        BOOL isAssetFiltered = NO;
        if (self.assetPickerFilterDelegate &&
            [self.assetPickerFilterDelegate respondsToSelector:@selector(assetTablePicker:isAssetFilteredOut:)])
        {
	        isAssetFiltered = [self.assetPickerFilterDelegate assetTablePicker:self isAssetFilteredOut:(WCCAsset*)elcAsset];
        }
        
        if (!isAssetFiltered) {
	        [self.elcAssets addObject:elcAsset];
        }
        
    }];
    NSLog(@"done enumerating photos");
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        // scroll to bottom
        long section = [self numberOfSectionsInTableView:self.tableView] - 1;
        long row = [self tableView:self.tableView numberOfRowsInSection:section] - 1;
        if (section >= 0 && row >= 0) {
            NSIndexPath *ip = [NSIndexPath indexPathForRow:row
                                                 inSection:section];
            [self.tableView scrollToRowAtIndexPath:ip
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:NO];
        }
        
        [self.navigationItem setTitle:[NSString stringWithFormat:@"%d/%d",_iSelectedCount,self.iMaxSelected]];
    });
}

- (void)doneAction:(id)sender
{
    if (_iSelectedCount<self.iMinSelected) {
        [[ToastViewAlert defaultCenter] postAlertWithMessage:[NSString stringWithFormat:@"选择图片数量不为%d!" ,self.iMinSelected]];
    }else{
        NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
        
        for(WCCAsset *elcAsset in self.elcAssets) {
            
            if([elcAsset selected]) {
                
                [selectedAssetsImages addObject:[elcAsset asset]];
            }
        }
        
        [self.parent selectedAssets:selectedAssetsImages];
    }
}

- (void)assetSelected:(id)asset
{
    if (self.singleSelection) {
        
        for(WCCAsset *elcAsset in self.elcAssets) {
            if(asset != elcAsset) {
                elcAsset.selected = NO;
            }
        }
    }
    if (self.immediateReturn) {
        NSArray *singleAssetArray = [NSArray arrayWithObject:[asset asset]];
        [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.elcAssets count] / (float)self.columns);
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    long index = path.row * self.columns;
    long length = MIN(self.columns, [self.elcAssets count] - index);
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    WCCAssetCell *cell = (WCCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WCCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    } else {
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}

- (int)totalSelectedAssets {
    
    int count = 0;
    
    for(WCCAsset *asset in self.elcAssets) {
		if([asset selected]) {
            count++;
		}
	}
    
    return count;
}

- (void)cellItemTapedWithSelected:(BOOL)bSelected
{
    if (bSelected) {
        _iSelectedCount ++;
    }else{
        _iSelectedCount --;
    }
     [self.navigationItem setTitle:[NSString stringWithFormat:@"%d/%d",_iSelectedCount,self.iMaxSelected]];
}

- (NSInteger)numberOfSelected
{
    return _iSelectedCount;
}

- (NSInteger)maxNumberOfSelected
{
    return self.iMaxSelected;
}

- (void)dealloc
{
    
}

@end