//
//  DateViewController.m
//  mote
//
//  Created by sean on 12/27/13.
//  Copyright (c) 2013 zlm. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController (){
    NSString *_strToday;
    NSString *_strThisMonth;
    NSMutableArray *_arrDateChangedList;
    NSMutableArray *_arrCheck;
    NSMutableArray *_arrDayReturn;
    NSMutableArray *_arrResponse;
    
    int _iYear;
    int _iMonth;
    int _lineNum;
    int _num;
}

@end

@implementation DateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.bIsBtnClicked = NO;
    self.bIsBtnTaskDateClicked = NO;
    _arrCheck = [[NSMutableArray alloc] init];
    _arrDateChangedList = [[NSMutableArray alloc] init];
    _arrDayReturn = [[NSMutableArray alloc] init];
    _arrResponse = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.currentDate) {
        [self initTodayStr];
    }
    
//    UIImage *image = [UIImage imageNamed:@"task_date_bg"];
//    self.viewDate.backgroundColor = [UIColor colorWithPatternImage:image];
//    self.viewDate.frame = CGRectMake(0, 69, image.size.width, image.size.height);
    
    [self getTaskListByMonth:self.currentDate];
}

-(void)saveDate{
    [self setDateRequest];
}

-(void)setDateRequest{
    if (_arrDateChangedList.count) {
        NSString *strDates = @"";
        NSString *strStatus = @"";
        
        for (int i=0; i<_arrDateChangedList.count; i++) {
            NSMutableDictionary *dict = [_arrDateChangedList objectAtIndex:i];
            NSString *strTmpDate = [dict valueForKey:@"day"];
            NSString * strTmpStatus = [dict valueForKey:@"status"] ;
            strDates = [strDates stringByAppendingFormat:@"%@,",strTmpDate];
            strStatus =  [strStatus stringByAppendingFormat:@"%@,",strTmpStatus];
        }
        [_arrDateChangedList removeAllObjects];
        
        NSString *strUrl = [UrlHelper stringUrlSetDate];
        NSMutableDictionary *dictParameters = [NSMutableDictionaryFactory getMutableDictionary];
        [dictParameters setObject:strDates forKey:@"dates"];
        [dictParameters setObject:strStatus forKey:@"status"];
        
        [self actionRequestWithUrl:strUrl parameters:dictParameters successBlock:^(NSDictionary *dictResponse) {
            self.maskView.hidden = YES;
            [self.delegate setDateSuccess];
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"档期设置成功！"];
        } andFailureBlock:^(NSError *error) {
            self.maskView.hidden = YES;
        }];
    }
}

-(void)getTaskListByMonth:(NSDate *)date{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
    
    _iYear = comps.year;
    _iMonth = comps.month;
    
    NSString *strUrl = [UrlHelper stringUrlGetTaskByMonth:_iYear month:_iMonth];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        [self updateDayReturnArray:(NSArray *)dictResponse];
        _arrResponse = (NSMutableArray *)dictResponse;
        [self initDateButtons:date];
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

-(void)updateDayReturnArray:(NSArray *)arr{
    [_arrDayReturn removeAllObjects];
    for (NSDictionary *dict in arr) {
        NSString *strDay = [dict valueForKey:@"day"];
        NSString *strStatus = [dict valueForKey:@"status"];
        if ([strStatus isEqualToString:@"1"]||[strStatus isEqualToString:@"2"]) {
            [_arrDayReturn addObject:strDay];
        }
    }
}

-(IBAction)onFrontClick:(id)sender{
    if (_iMonth-1<=0) {
        _iMonth = 12;
        _iYear--;
    }else{
        _iMonth--;
    }
    
    NSString *strMonth = [NSString stringWithFormat:@"%d年%d月",_iYear,_iMonth];
    if ([strMonth isEqualToString:_strThisMonth]) {
        [self onBackToNowClick:self.buttonBackToNow];
    }else{
        NSDate *newDate =[self convertDateFromString:[NSString stringWithFormat:@"%d年%d月10日",_iYear,_iMonth]];
        [self getTaskListByMonth:newDate];
        [self updateBackToNowButton];
        
        self.currentDate = newDate;
    }
}

-(IBAction)onNextClick:(id)sender{
    if (_iMonth+1>12) {
        _iMonth = 1;
        _iYear++;
    }else{
        _iMonth++;
    }
    NSString *strMonth = [NSString stringWithFormat:@"%d年%d月",_iYear,_iMonth];
    if ([strMonth isEqualToString:_strThisMonth]) {
        [self onBackToNowClick:self.buttonBackToNow];
    }else{
        NSDate *newDate =[self convertDateFromString:[NSString stringWithFormat:@"%d年%d月10日",_iYear,_iMonth]];
        [self getTaskListByMonth:newDate];
        [self updateBackToNowButton];
        
        self.currentDate = newDate;
    }
    
}

-(void)updateBackToNowButton{
    NSString *strMonth = [NSString stringWithFormat:@"%d年%d月",_iYear,_iMonth];
    if ([strMonth isEqualToString:_strThisMonth]) {
        self.buttonBackToNow.hidden = YES;
    }else{
        self.buttonBackToNow.hidden = NO;
    }
}

-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

-(IBAction)onBackToNowClick:(id)sender{
    [self getTaskListByMonth:[NSDate date]];
    [self updateBackToNowButton];
}

-(void)onDayButtonClick:(id)sender{
    if (self.bIsBtnClicked) {
        UIButton *button = (UIButton *)sender;
        NSString *strCheck = [_arrCheck objectAtIndex:button.tag-1];
        NSString *strDateDisplay = [NSString stringWithFormat:@"%d年%d月%d日",_iYear,_iMonth,button.tag];
        int iResult = [self compareDate:strDateDisplay];
        if (iResult>0) {
            if ([strCheck isEqualToString:@"0"]) {
                [button setBackgroundImage:[UIImage imageNamed:@"task_date_tik_btn"] forState:UIControlStateNormal];
                [_arrCheck setObject:@"1" atIndexedSubscript:button.tag-1];
                [self updateDateChangedArray:button.tag strStatus:@"1"];
            }else{
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [_arrCheck setObject:@"0" atIndexedSubscript:button.tag-1];
                [self updateDateChangedArray:button.tag strStatus:@"0"];
            }
        }else{
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"无法编辑以前的档期！"];
        }
    }
    
    if (self.bIsBtnTaskDateClicked) {
        UIButton *button = (UIButton *)sender;
        NSString *strDayTmp = [NSString stringWithFormat:@"%d",button.tag];
        int i = 0;
        for (i=0; i<_arrResponse.count; i++) {
            NSDictionary *dict = [_arrResponse objectAtIndex:i];
            NSString *strDayDict = [dict valueForKey:@"day"];
            NSArray *arrTaskInfo = [dict valueForKey:@"taskinfo"];
            NSString *strStatusTmp = [dict valueForKey:@"status"];
            
            if ([strDayDict isEqualToString:strDayTmp]&&[strStatusTmp isEqualToString:@"2"]) {
                if ([self.delegate respondsToSelector:@selector(onClickDateWithArrTaskInfo:)]) {
                    [self.delegate onClickDateWithArrTaskInfo:arrTaskInfo];
                    break;
                }
            }
        }
        
        if (i==_arrResponse.count) {
            [self.delegate onClickDateWithArrTaskInfo:[[NSArray alloc] init]];
            [[ToastViewAlert defaultCenter] postAlertWithMessage:@"当天无任务！"];
        }
        
    }
}

-(int)compareDate:(NSString *)strDateDisplay{
    NSDate *dateNow = [self convertDateFromString:_strToday];
    NSDate *dateDisplay = [self convertDateFromString:strDateDisplay];
    NSTimeInterval timeInterval = [dateNow timeIntervalSinceDate: dateDisplay];
    if (timeInterval<0) {
        return 1;
    }else{
        return 0;
    }
}

-(void)updateDateChangedArray:(int)iDay strStatus:(NSString *)strStatus{
    int i=0;
    NSString *str = [NSString stringWithFormat:@"%d-%d-%d",_iYear,_iMonth,iDay];
    
    for (; i<_arrDateChangedList.count; i++) {
        NSMutableDictionary *dict = [_arrDateChangedList objectAtIndex:i];
        NSString *strDate = [dict valueForKey:@"day"];
        int iStatus = [[dict valueForKey:@"status"] integerValue];
        
        if ([strDate isEqualToString:str]) {
            if (iStatus) {
                iStatus = 0;
                [_arrDateChangedList removeObjectAtIndex:i];
            }else{
                iStatus = 1;
                [dict setObject:[NSString stringWithFormat:@"%d",iStatus] forKey:@"status"];
                [_arrDateChangedList replaceObjectAtIndex:i withObject:dict];
            }
            
            break;
        }
    }
    
    if (i==_arrDateChangedList.count) {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:strStatus forKey:@"status"];
        [dict setObject:str forKey:@"day"];
        [_arrDateChangedList addObject:dict];
    }
}

-(void)initTodayStr{
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:[NSDate date]];
    _strToday = [NSString stringWithFormat:@"%d年%d月%d日",comps.year,comps.month,comps.day];
    _strThisMonth = [NSString stringWithFormat:@"%d年%d月",comps.year,comps.month];
    self.buttonBackToNow.hidden = YES;

    self.currentDate = [self convertDateFromString:_strToday];
}

-(void)initDateButtons:(NSDate *)date{
    [_arrCheck removeAllObjects];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit |NSDayCalendarUnit) fromDate:date];
    
    _iYear = comps.year;
    _iMonth = comps.month;
    int day = comps.day;
    self.labelTitle.text = [NSString stringWithFormat:@"%d年%d月",comps.year,comps.month];
    
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                       fromDate:date];
    NSInteger weekday = [comps weekday]; //currrent day is which weekday
    
    int iFirstDay = weekday-day%7;
    if (iFirstDay<0) {
        iFirstDay +=7;
    }
    //int iFirstDay = abs(day%7-weekday)+1;
    int february =28;
    int monthDays = 31;
    
    if((comps.year%4==0&&comps.year%100!=0)||comps.year%400==0){
        february=29;
    }
    
    switch(_iMonth){
        case 2:monthDays=february;break;
        case 4:
        case 6:
        case 9:
        case 11:
            monthDays=30;
            break;
        default:
            monthDays=31;
            break;
    }
    
    int iXOffset = iFirstDay*46;
    int iYOffset = 0;
    
    for (UIView *view in self.viewDate.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i=1; i<=monthDays; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(iXOffset, iYOffset, 45, 45)];
        button.tag = i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onDayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self isExistInArray:[NSString stringWithFormat:@"%d",i]]) {
            if (_bIsBtnClicked) {
                [button setBackgroundImage:[UIImage imageNamed:@"task_date_tik_btn"] forState:UIControlStateNormal];
            }else if(_bIsBtnTaskDateClicked){
                NSString *strDayTmp = [NSString stringWithFormat:@"%d",button.tag];
                for (int i=0; i<_arrResponse.count; i++) {
                    NSDictionary *dict = [_arrResponse objectAtIndex:i];
                    NSString *strDayDict = [dict valueForKey:@"day"];
                    NSString *strStatusTmp = [dict valueForKey:@"status"];
                    
                    if ([strDayDict isEqualToString:strDayTmp]&&[strStatusTmp isEqualToString:@"2"]) {
                        [button setBackgroundImage:[UIImage imageNamed:@"task_date_yellow_bg"] forState:UIControlStateNormal];
                    }else if([strDayDict isEqualToString:strDayTmp]&&[strStatusTmp isEqualToString:@"1"]){
                        [button setBackgroundImage:[UIImage imageNamed:@"task_grey_button"] forState:UIControlStateNormal];
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                }
            }
            
             [_arrCheck addObject:@"1"];
        }else{
            [_arrCheck addObject:@"0"];
        }
        NSLog(@"iXOffset:%d",iXOffset);
        
        _num = iYOffset;
        [self.viewDate addSubview:button];
        
        NSString *strDay = [NSString stringWithFormat:@"%d年%d月%d日",_iYear,_iMonth,i];
        if ([strDay isEqualToString:_strToday]) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
            imageView.image = [UIImage imageNamed:@"task_date_now"];
            [button addSubview:imageView];
        }
        
        if (iXOffset >270) {
            iXOffset = 0;
            iYOffset += 46;
        }else{
            iXOffset +=46;
        }
    }
    
    /*----------------------------------------jiajingjing--------------------------------------------*/
    _lineNum=_num/46;
    if (_lineNum==5) {
        UIImage *image = [UIImage imageNamed:@"task_date_bg_big"];
        self.viewDate.backgroundColor = [UIColor colorWithPatternImage:image];
        self.viewDate.frame = CGRectMake(0, 68, image.size.width, image.size.height);
        _lineNum = 0;
    }else if (_lineNum==4){
        UIImage *image = [UIImage imageNamed:@"task_date_bg"];
        self.viewDate.backgroundColor = [UIColor colorWithPatternImage:image];
        self.viewDate.frame = CGRectMake(0, 68, image.size.width, image.size.height);
        _lineNum = 0;
    }
}

-(BOOL)isExistInArray:(NSString *)str{
    for (NSString *strTmp in _arrDayReturn) {
        if ([strTmp isEqualToString:str]) {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
