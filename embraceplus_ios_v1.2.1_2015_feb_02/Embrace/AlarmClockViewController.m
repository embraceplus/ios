//
//  AddFxMenuViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "AlarmClockViewController.h"

@interface AlarmClockViewController ()

@end

@implementation AlarmClockViewController

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
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;

    cellNumPerPage = 3;
    
        
    startLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    [startLabel setFrame:CGRectMake(20, 52 + deltaY, 60, 34)];
    
    colonLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    colonLabel.textColor = [UIColor blackColor];
    [colonLabel setFrame:CGRectMake(200, 145 + deltaY, 60, 34)];
    
    CGRect frame;
    frame = startSwitch.frame;
    frame.origin.x = 245;
    frame.origin.y = 52+deltaY;
    startSwitch.frame = frame;

    
    line2.frame = CGRectMake(0, 87 + deltaY, 320, 2);
    if (iPhone5)
    {
       
        line3.frame = CGRectMake(0, 240 + deltaY, 320, 2);
        datePicker.frame = CGRectMake(18.5, 88 + deltaY, 284, 162);
        fxMenuCollectionView.frame = CGRectMake(20, 255 + deltaY, 285, 134);
        pageControl.frame = CGRectMake(141, 392 + deltaY, 39, 37);
    }
    else
    {
        line3.frame = CGRectMake(0, 240 + deltaY, 320, 2);
        line3.hidden = YES;
        datePicker.frame = CGRectMake(18.5, 75 + deltaY, 284, 162);
        fxMenuCollectionView.frame = CGRectMake(20, 225 + deltaY, 285, 134);
        pageControl.frame = CGRectMake(141, 350 + deltaY, 39, 37);
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnOffAlarm:)  name:@"turnOffAlarmNotification" object:nil];
    
#pragma mark - kane
    datePicker.backgroundColor = [UIColor clearColor];
    
}

-(void)turnOffAlarm:(NSNotification *)notification
{
    NSLog(@"turnOffAlarm");
    
    [startSwitch setOn:NO];
    
    NSDate * currentDate = [NSDate date];
    [datePicker setDate:currentDate];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"AddFxMenuViewController");
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDate * alarmClock = [ud objectForKey:@"alarmClock"];
    
    isStart = [[ud objectForKey:@"isStartOn"] boolValue];
    [startSwitch setOn:isStart];
    
    NSDate * currentDate = [NSDate date];
    if(alarmClock!=nil)
    {
        if([currentDate compare:alarmClock] == NSOrderedAscending)
        {
            [datePicker setDate:alarmClock];
            return;
        }
    }
    
    [datePicker setDate:currentDate];
   
}


- (void)willPresentAlertView:(UIAlertView *)alertView {
    for (UIView *_currentView in alertView.subviews) {
        
        if( [_currentView isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) _currentView;
            label.font=[UIFont fontWithName:@"Avenir" size:18];
        }
        if ( [_currentView isKindOfClass:[UIButton class]] )
        {
            ((UIButton *)_currentView).titleLabel.font = [UIFont fontWithName:@"Avenir" size:18];
        }
    }
}

- (IBAction)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
 
    [ud setObject:[NSNumber numberWithBool:isButtonOn] forKey:@"isStartOn"];
    
    [self isStartAlarm];
}

- (void) isStartAlarm
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDate * currentDate = [NSDate date];
    NSDate * selectDate = [datePicker date];
    BOOL isButtonOn = [startSwitch isOn];
    
    if([currentDate compare:selectDate] == NSOrderedAscending && isButtonOn)
    {
        NSLog(@"alarm really starts");
        [ud setObject:[NSNumber numberWithBool:YES] forKey:@"alarmIsStart"];
    }
    else
    {
        [ud setObject:[NSNumber numberWithBool:NO] forKey:@"alarmIsStart"];
    }
}
- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dateChanged
{

    NSDate *date = [datePicker date];
    NSLog(@"before date = %@",date);
    
    //make sure second part is 0 
    NSTimeInterval timerInterval = [date timeIntervalSince1970];
    //NSLog(@"before timerInterval = %f",timerInterval);
    timerInterval = (int)((timerInterval/60))* 60;
    //NSLog(@"after timerInterval = %f",timerInterval);
    date = [NSDate dateWithTimeIntervalSince1970:timerInterval];
    
    NSLog(@"date = %@",date);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:date forKey:@"alarmClock"];
    
    [self isStartAlarm];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
  
    
}

-(void)dealloc
{
    [line2 release];
    [line3 release];
}
@end
