//
//  PiazzaViewController.m
//  mote
//
//  Created by apple on 14-6-9.
//  Copyright (c) 2014年 zlm. All rights reserved.
//

#import "SquareViewController.h"
#import "ModelCellView.h"
#import "FinderConditionListViewController.h"
#import "MyWebHomeViewController.h"

#define ModelViewWidth 146
#define ModelViewHeight 205
#define ModelViewMargin 10

@interface SquareViewController ()<UIScrollViewDelegate,ConditionSelectedDelegate,UITextFieldDelegate,ModelCellViewDelegate>{

    NSUInteger _ModelViewCount;
    
    NSString *_gender;
    NSString *_cate;
    NSString *_sort;
    NSString *_key;
    int _from;
    
    NSMutableArray *_modelListArray;
    
    NSMutableArray *_ModelViews;
    NSMutableSet *_visibleModelViews,*_recycledModelViews;
    
    UIScrollView *_pagingScrollView;
}

@end

@implementation SquareViewController

@synthesize buttonGender;
@synthesize buttonCate;
@synthesize buttonDefault;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"广场";
		self.tabBarItem.image = [UIImage imageNamed:@"moka_tabbar_piazza_normal_bg"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _gender = @"";
    _cate = @"";
    _sort = @"";
    _key = @"";
    _from = 1;
    
    _recycledModelViews = [[NSMutableSet alloc] init];
    _modelListArray = [[NSMutableArray alloc] init];
    
    _pagingScrollView = [[UIScrollView alloc] init];
    _pagingScrollView.frame = CGRectMake(0, 80, self.view.width, self.view.height-45);
	_pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_pagingScrollView.delegate = self;
//	_pagingScrollView.showsHorizontalScrollIndicator = NO;
//	_pagingScrollView.showsVerticalScrollIndicator = NO;
	_pagingScrollView.backgroundColor = [UIColor clearColor];
    //_pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
	[self.view addSubview:_pagingScrollView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    [self loadModelList];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [_txtSearch resignFirstResponder];
}

- (void)loadModelList{
    
    if (_from>0) {
        NSString *urlModelStr = [UrlHelper stringUrlGetModelListFromLine:_from gender:_gender cate:_cate sort:_sort key:_key];
        
        [self requestDataWithUrl:urlModelStr successBlock:^(NSDictionary *dictResponse) {
            
            self.maskView.hidden = YES;
            
            _from = [[dictResponse objectForKey:@"next"] integerValue];
            NSArray *array= [dictResponse objectForKey:@"rows"];
            NSMutableArray *configArray = [[NSMutableArray alloc] init];
            
            for (NSDictionary *dict in array) {
                GirlModel *mode = [[GirlModel alloc] initWithDictionary:dict];
                [configArray addObject:mode];
            }
            [_modelListArray addObjectsFromArray:configArray];
            if (_modelListArray.count>0) {
                [self reloadData];
            }
        } andFailureBlock:^(NSError *error) {
            
            self.maskView.hidden = YES;
        }];
    }
}

- (void)reloadData{

    _ModelViewCount = NSNotFound;
    NSUInteger numberOfModelView = [_modelListArray count];
    [_ModelViews removeAllObjects];
    
    for (int i = 0; i < numberOfModelView; i++) {
        [_ModelViews addObject:[NSNull null]];
    }
    
    while (_pagingScrollView.subviews.count) {
        [[_pagingScrollView.subviews lastObject] removeFromSuperview];
    }
    
    [_visibleModelViews removeAllObjects];
    [_recycledModelViews removeAllObjects];
    
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    [self displayModelView];
    [self.view setNeedsLayout];
}

- (void)displayModelView{
    
    for (ModelCellView *modelView in _visibleModelViews) {
        [_recycledModelViews addObject:modelView];
        [modelView removeFromSuperview];
        [modelView prepareForReuse];
    }
    
    [_visibleModelViews minusSet:_recycledModelViews];
    while (_recycledModelViews.count > 2) // Only keep 2 recycled pages
        [_recycledModelViews removeObject:[_recycledModelViews anyObject]];
    
    for (int i=0; i<_modelListArray.count; i++) {
//        ModelCellView *modelView = [self dequeueRecycledModelView];
//        if (!modelView) {
//            modelView = [[ModelCellView alloc] init];
//        }
//        [self configureModelView:modelView forIndex:i];
//        
//        [_visibleModelViews addObject:modelView];
        
        ModelCellView *modelView = [[ModelCellView alloc] init];
        modelView.frame = [self frameForModelViewAtIndex:i];
        modelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"modelCellBg"]];
        modelView.model = [_modelListArray objectAtIndex:i];
        modelView.delegate = self;
        [modelView loadSubviews];
        [_pagingScrollView addSubview:modelView];
    }
}

- (ModelCellView *)dequeueRecycledModelView {
    
	ModelCellView *view = [_recycledModelViews anyObject];
	if (view) {
		[_recycledModelViews removeObject:view];
	}
	return view;
}
- (void)configureModelView:(ModelCellView *)modelView forIndex:(NSUInteger)index {

    modelView.model = [_modelListArray objectAtIndex:index];
    modelView.frame = [self frameForModelViewAtIndex:index];
    [modelView loadSubviews];
    
}
- (CGRect)frameForModelViewAtIndex:(NSUInteger)index {
    
    CGFloat originX = 0.0;
    CGFloat originY = 0.0;
    
    
    int lineNum = index/2;
    originX = (index%2)*(ModelViewWidth+ModelViewMargin)+ModelViewMargin;
    originY = lineNum*(ModelViewHeight+ModelViewMargin)+ModelViewMargin;
    
    //NSLog(@"originX:%f originY:%f",originX, originY);
    return CGRectMake(originX, originY, ModelViewWidth, ModelViewHeight);

}

- (CGSize)contentSizeForPagingScrollView {

    NSUInteger numberOfModelView = [_modelListArray count];
    int lineNum = numberOfModelView/2;
    return CGSizeMake(self.view.width, lineNum*(ModelViewHeight+ModelViewMargin));
}

-(IBAction)onGenderClick:(id)sender{
    FinderConditionListViewController *conditionVC = [[FinderConditionListViewController alloc] init];
    conditionVC.type = kByGender;
    conditionVC.delegate = self;
    [self.navigationController pushViewController:conditionVC animated:YES];
}

-(IBAction)onCateClick:(id)sender{
    FinderConditionListViewController *conditionVC = [[FinderConditionListViewController alloc] init];
    conditionVC.type = kByCate;
    conditionVC.delegate = self;
    [self.navigationController pushViewController:conditionVC animated:YES];
}

-(IBAction)onDefaultClick:(id)sender{
    FinderConditionListViewController *conditionVC = [[FinderConditionListViewController alloc] init];
    conditionVC.type = kBySort;
    conditionVC.delegate = self;
    [self.navigationController pushViewController:conditionVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [_recycledModelViews removeAllObjects];
}

#pragma mark - ConditionSelectedDelegate Mehthods

-(void)selectWithGender:(NSDictionary *)dict{
    _gender = [dict valueForKey:@"label_id"];
    _from = 1;
    [_modelListArray removeAllObjects];
    [self.buttonGender setTitle:[dict valueForKey:@"label_text"] forState:UIControlStateNormal];
    [self loadModelList];
}
-(void)selectWithCate:(NSString *)strCate{
    _cate = strCate;
    _from = 1;
    [_modelListArray removeAllObjects];
    [self.buttonCate setTitle:_cate forState:UIControlStateNormal];
    [self loadModelList];
}
-(void)selectWithSort:(NSString *)strSort{
    _sort = strSort;
    _from = 1;
    [_modelListArray removeAllObjects];
    [self.buttonDefault setTitle:_sort forState:UIControlStateNormal];
    [self loadModelList];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_pagingScrollView.contentOffset.y + _pagingScrollView.frame.size.height > _pagingScrollView.contentSize.height && _pagingScrollView && _pagingScrollView.contentOffset.y > 10.0f) {
        [self loadModelList];
    }
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _from = 1;
    [_modelListArray removeAllObjects];
    [self loadModelList];
    [_txtSearch resignFirstResponder];
    return YES;
}

#pragma mark - ModelCellViewDelegate Methods

- (void)didSeletedModelViewWith:(NSUInteger)uid{
    
    MyWebHomeViewController *webVC = [[MyWebHomeViewController alloc] init];
    webVC.uid = [NSString stringWithFormat:@"%d",uid];
    [self.navigationController pushViewController:webVC animated:YES];
}


@end
