//
//  TaskDetailViewController.m
//  mote
//
//  Created by sean on 1/23/14.
//  Copyright (c) 2014 zlm. All rights reserved.
//

#import "TaskDetailViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface TaskDetailViewController (){
    NSDictionary *_dicResponse;
}

@end

@implementation TaskDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务单";
    [self.scrollviewInfo setContentSize:CGSizeMake(self.view.frame.size.width, 710)];
    [self.scrollviewInfo addSubview:self.viewInfo];
    [self getTaskDetailData];
    // Do any additional setup after loading the view from its nib.
}

-(void)getTaskDetailData{
    NSString *strUrl = [UrlHelper stringUrlGetTaskDetailWithTaskId:self.strTaskId];
    [self requestDataWithUrl:strUrl successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        _dicResponse = dictResponse;
        [self.imageViewLogo setImageWithURL:urlFromImageURLstr([dictResponse valueForKey:@"img"]) placeholderImage:[UIImage imageNamed:@"no_image"]];
        self.labelTitle.text = [dictResponse valueForKey:@"name"];
        self.labelDesc1.text = [dictResponse valueForKey:@"district"];
        self.labelDesc2.text = [dictResponse valueForKey:@"industry"];
        self.labelNumber.text = [dictResponse valueForKey:@"pics"];
        self.labelPrice.text = [dictResponse valueForKey:@"price"];
        self.labelTaskDetail.text = [dictResponse valueForKey:@"summary"];
        self.labelDate.text = [dictResponse valueForKey:@"acttime"];
        self.labelLocation.text = [dictResponse valueForKey:@"actplace"];
        int iPolled = [[dictResponse valueForKey:@"isPolled"] integerValue];
        if (iPolled) {
            self.buttonZan.enabled = NO;
            self.buttonCai.enabled = NO;
        }
        
        int isAccepted = [[dictResponse valueForKey:@"isaccepted"] integerValue];
     if(isAccepted){
         self.buttonRefuse.enabled = NO;
     }
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

-(void)refusePostData{
    NSMutableDictionary *dicParameter = [NSMutableDictionaryFactory getMutableDictionary];
    [dicParameter setObject:[_dicResponse valueForKey:@"id"] forKey:@"taskid"];
    NSString *strUrl = [UrlHelper stringUrlTaskRefuse];
    [self actionRequestWithUrl:strUrl parameters:dicParameter successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        self.buttonRefuse.enabled = NO;
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

-(void)pollMerchant:(NSString *)strContent{
    NSMutableDictionary *dictParameter = [NSMutableDictionaryFactory getMutableDictionary];
    [dictParameter setObject:strContent forKey:@"value"];
    [dictParameter setObject:[_dicResponse valueForKey:@"mid"] forKey:@"mid"];
    
    NSString *strUrl = [UrlHelper stringUrlPollMerchant];
    [self actionRequestWithUrl:strUrl parameters:dictParameter successBlock:^(NSDictionary *dictResponse) {
        self.maskView.hidden = YES;
        self.buttonZan.enabled = NO;
        self.buttonCai.enabled = NO;
        [[ToastViewAlert defaultCenter] postAlertWithMessage:@"您已评价，谢谢！"];
    } andFailureBlock:^(NSError *error) {
        self.maskView.hidden = YES;
    }];
}

#pragma mark - IBAction Click

-(IBAction)onAddToCal:(id)sender{
    //事件市场
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    //6.0及以上通过下面方式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    //错误细心
                    // display error message here
                    [[ToastViewAlert defaultCenter] postAlertWithMessage:@"添加日历事件失败！"];
                }
                else if (!granted)
                {
                    [[ToastViewAlert defaultCenter] postAlertWithMessage:@"请在设置中允许访问日历！"];
                    //被用户拒绝，不允许访问日历
                    // display access denied error message here
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    
                    //事件保存到日历
                    
                    
                    //创建事件
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     =  [_dicResponse valueForKey:@"name"];
                    event.location = [_dicResponse valueForKey:@"actplace"];
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    
                    event.startDate =  [tempFormatter dateFromString:[_dicResponse valueForKey:@"ctime"]];
                    event.endDate   = [tempFormatter dateFromString:[_dicResponse valueForKey:@"ctime"]];
                    event.allDay = YES;
                    
                    //添加提醒
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f * 24]];
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -15.0f]];
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    
                    [[ToastViewAlert defaultCenter] postAlertWithMessage:@"添加日历事件成功！"];
                }
            });
        }];
    }
}

-(IBAction)onRefuseClick:(id)sender{
    [self refusePostData];
}

-(IBAction)onZanClick:(id)sender{
    [self pollMerchant:@"up"];
}

-(IBAction)onCaiClick:(id)sender{
    [self pollMerchant:@"down"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
