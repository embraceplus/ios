//
//  AddFxMenuViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "TimerClockViewController.h"
#import "FilePath.h"

@interface TimerClockViewController ()

@end

@implementation TimerClockViewController

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
    
    counterDownLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:80];
    counterDownLabel.frame = CGRectMake(16, 75 + deltaY, 285, 155);
    
    startLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    startLabel.frame = CGRectMake(20, 52 + deltaY, 60, 34);
    
    hourLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    minLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    secondLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    hourLabel.frame = CGRectMake(80.5, 142 + deltaY, 60, 30);
    minLabel.frame = CGRectMake(175, 142 + deltaY, 60, 30);
    secondLabel.frame = CGRectMake(270, 142 + deltaY, 60, 30);
    
    CGRect frame;
    frame = startSwitch.frame;
    frame.origin.x = 245;
    frame.origin.y = 52+deltaY;
    startSwitch.frame = frame;
    
    line2.frame = CGRectMake(0, 87 + deltaY, 320, 2);
//    if (iPhone5) {
//        line3.frame = CGRectMake(0, 240 + deltaY, 320, 2);
//
//        fxMenuCollectionView.frame = CGRectMake(17, 255 + deltaY, 287, 134);
//        pageControl.frame = CGRectMake(141, 392 + deltaY, 39, 37);
//    
//    }
//    else {
//
//        fxMenuCollectionView.frame = CGRectMake(17, 235 + deltaY, 287, 134);
//        pageControl.frame = CGRectMake(141, 356 + deltaY, 39, 37);
//        
//    }
    
    if (iPhone5)
    {
        
        line3.frame = CGRectMake(0, 230 + deltaY, 320, 2);
        pickerView.frame = CGRectMake(19, 75 + deltaY, 280, 162);
        fxMenuCollectionView.frame = CGRectMake(19, 255 + deltaY, 285, 134);
        pageControl.frame = CGRectMake(141, 392 + deltaY, 39, 37);
    }
    else
    {
        line3.frame = CGRectMake(0, 230 + deltaY, 320, 2);
        line3.hidden = YES;
        pickerView.frame = CGRectMake(19, 75 + deltaY, 280, 162);
        fxMenuCollectionView.frame = CGRectMake(19, 225 + deltaY, 285, 134);
        pageControl.frame = CGRectMake(141, 350 + deltaY, 39, 37);
    }

 
    pickerDataHour = [[NSMutableArray alloc] init];
    pickerDataMinute = [[NSMutableArray alloc] init];
    pickerDataSecond = [[NSMutableArray alloc] init];
    
    for(int i=0;i <24;i++)
    {
        [pickerDataHour addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=0;i <60;i++)
    {
        [pickerDataMinute addObject:[NSString stringWithFormat:@"%d",i]];
        [pickerDataSecond addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath timerClockConfigFilePath]])
    {
        timerClockConfigDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath timerClockConfigFilePath]];
        startTimeInSecond = [timerClockConfigDic objectForKey:@"startTimeInSecond"];
        startCountDownValue = [timerClockConfigDic objectForKey:@"startCountDownValue"];
        isStart = [[timerClockConfigDic objectForKey:@"isStart"] boolValue];
    }
    else
    {
        isStart = NO;
        timerClockConfigDic = [[NSMutableDictionary alloc] init];
    }
   
    [startSwitch setOn:isStart];
    if(isStart)
    {
        pickerView.hidden = YES;
        counterDownLabel.hidden = NO;
        hourLabel.hidden = YES;
        minLabel.hidden = YES;
        secondLabel.hidden = YES;
        
    }
    else
    {
        pickerView.hidden = NO;
        counterDownLabel.hidden = YES;
        hourLabel.hidden = NO;
        minLabel.hidden = NO;
        secondLabel.hidden = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(isStart)
    {
        pickerView.hidden = YES;
        counterDownLabel.hidden = NO;
        //[timerButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        //show the left counterDown
        NSTimeInterval currentTime, leftCountDown;
        
        currentTime = [[NSDate date] timeIntervalSince1970];
        
        leftCountDown = [startCountDownValue doubleValue]- (currentTime - [startTimeInSecond doubleValue]);
        
        
        timerValueInSecond = leftCountDown;
        int hourRow,minuteRow,secondRow;
        NSString *hourString,*minString,*secString;
        
        hourRow = leftCountDown/3600;
        minuteRow = (leftCountDown - hourRow*3600)/60;
        secondRow = leftCountDown - hourRow*3600 - minuteRow*60;
        if(hourRow<10)
            hourString = [NSString stringWithFormat:@"0%d",hourRow];
        else
            hourString = [NSString stringWithFormat:@"%d",hourRow];
        
        if(minuteRow<10)
            minString = [NSString stringWithFormat:@"0%d",minuteRow];
        else
            minString = [NSString stringWithFormat:@"%d",minuteRow];
        
        if(secondRow<10)
            secString = [NSString stringWithFormat:@"0%d",secondRow];
        else
            secString = [NSString stringWithFormat:@"%d",secondRow];
        
        counterDownLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secString];
        
        //counterDownLabel.text = [hourString ]
        
        NSLog(@"left count = %f , %@",leftCountDown, counterDownLabel.text);
        //start a timer
        //start timer
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(counterDown) userInfo:nil repeats:YES];
        
        
    }
    else
    {
        pickerView.hidden = NO;
        counterDownLabel.hidden = YES;
        
        NSNumber *hourNum,*minuteNum,*secondNum;
        int hourValue,minuteValue,secondValue;
        
        hourNum = [timerClockConfigDic objectForKey:@"hourNum"];
        minuteNum = [timerClockConfigDic objectForKey:@"minuteNum"];
        secondNum = [timerClockConfigDic objectForKey:@"secondNum"];
        
        if(hourNum!=nil)
        {
            hourValue = [hourNum intValue];
            minuteValue = [minuteNum intValue];
            secondValue = [secondNum intValue];
        }
        else
        {
            hourValue = 0;
            minuteValue = 0;
            secondValue = 0;
        }
        
        
        [pickerView selectRow:hourValue inComponent:0 animated:NO];
        [pickerView selectRow:minuteValue inComponent:1 animated:NO];
        [pickerView selectRow:secondValue inComponent:2 animated:NO];
        
        startTimeInSecond = [timerClockConfigDic objectForKey:@"startTimeInSecond"];
        //[timerButton setTitle:@"Start" forState:UIControlStateNormal];

    }
    
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
    NSString *hourString,*minString,*secString;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:[NSNumber numberWithBool:isButtonOn] forKey:@"isStartOn"];
    
    if(isButtonOn)
    {
        pickerView.hidden = YES;
        counterDownLabel.hidden = NO;
        hourLabel.hidden = YES;
        minLabel.hidden = YES;
        secondLabel.hidden = YES;
        int hourRow, minuteRow, secondRow;
        
        hourRow = [pickerView selectedRowInComponent:0];
        minuteRow = [pickerView selectedRowInComponent:1];
        secondRow = [pickerView selectedRowInComponent:2];
        
        timerStartTime = [[NSDate date] timeIntervalSince1970];
        timerValueInSecond = [[pickerDataHour objectAtIndex:hourRow] intValue]*3600 +
        [[pickerDataMinute objectAtIndex:minuteRow] intValue]*60 +[[pickerDataSecond objectAtIndex:secondRow] intValue];
        
        if(hourRow !=0 ||minuteRow!= 0 ||secondRow!=0)
            [timerClockConfigDic setObject:@"1" forKey:@"isStart"];
        
        [timerClockConfigDic setObject:[NSNumber numberWithDouble:timerStartTime] forKey:@"startTimeInSecond"];
        [timerClockConfigDic setObject:[NSNumber numberWithDouble:timerValueInSecond] forKey:@"startCountDownValue"];
        
        if(hourRow<10)
            hourString = [NSString stringWithFormat:@"0%d",hourRow];
        else
            hourString = [NSString stringWithFormat:@"%d",hourRow];
        
        if(minuteRow<10)
            minString = [NSString stringWithFormat:@"0%d",minuteRow];
        else
            minString = [NSString stringWithFormat:@"%d",minuteRow];
        
        if(secondRow<10)
            secString = [NSString stringWithFormat:@"0%d",secondRow];
        else
            secString = [NSString stringWithFormat:@"%d",secondRow];
        
        counterDownLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secString];
        
        //start a timer
        //start timer
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(counterDown) userInfo:nil repeats:YES];
    }
    else
    {
        [timerClockConfigDic setObject:@"0" forKey:@"isStart"];
        pickerView.hidden = NO;
        counterDownLabel.hidden = YES;
        hourLabel.hidden = NO;
        minLabel.hidden = NO;
        secondLabel.hidden = NO;
        
        if(myTimer!= nil)
        {
            [myTimer invalidate];
            myTimer = nil;
            
        }

    }
    [timerClockConfigDic writeToFile:[FilePath timerClockConfigFilePath] atomically:YES];
}


- (void) counterDown
{
    NSString *hourString,*minString,*secString;
    int hourRow, minuteRow, secondRow;
    timerValueInSecond -= 0.1;
    
    if(timerValueInSecond<= 0)
    {
        if(myTimer!= nil)
        {
            [myTimer invalidate];
            myTimer = nil;
            //[myTimer release];
        }
        counterDownLabel.text = @"00:00:00";
    }
    else
    {
        hourRow = timerValueInSecond/3600;
        minuteRow = (timerValueInSecond - hourRow*3600)/60;
        secondRow = timerValueInSecond - hourRow*3600 - minuteRow*60;
        
        if(hourRow<10)
            hourString = [NSString stringWithFormat:@"0%d",hourRow];
        else
            hourString = [NSString stringWithFormat:@"%d",hourRow];
        
        if(minuteRow<10)
            minString = [NSString stringWithFormat:@"0%d",minuteRow];
        else
            minString = [NSString stringWithFormat:@"%d",minuteRow];
        
        if(secondRow<10)
            secString = [NSString stringWithFormat:@"0%d",secondRow];
        else
            secString = [NSString stringWithFormat:@"%d",secondRow];
        
        counterDownLabel.text = [NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secString];
    }
   
    
}

- (IBAction)backButton:(id)sender
{
//    int hourRow, minuteRow, secondRow;
//    hourRow = [pickerView selectedRowInComponent:0];
//    minuteRow = [pickerView selectedRowInComponent:1];
//    secondRow = [pickerView selectedRowInComponent:2];
//   
//    [timerClockConfigDic setObject:[NSNumber numberWithInt:hourRow] forKey:@"hourNum"];
//    [timerClockConfigDic setObject:[NSNumber numberWithInt:minuteRow] forKey:@"minuteNum"];
//    [timerClockConfigDic setObject:[NSNumber numberWithInt:secondRow] forKey:@"secondNum"];
//    
//    [timerClockConfigDic writeToFile:[FilePath timerClockConfigFilePath] atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    NSLog(@"AddFx viewDidDisappear");
//        CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
//    
//        NSLog(@"find hello retain count before= %d",[director.view retainCount]);
//        if([director runningScene] != nil)
//            [director end];
//    
//        NSLog(@"find hello retain count after= %d",[director.view retainCount]);
    if(myTimer!= nil)
    {
        [myTimer invalidate];
        myTimer = nil;
    }

}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger result;
    
    if(component == 0)
        result = 24;
    if(component == 1)
        result = 60;
    if(component == 2)
        result = 60;
    
    return result;
}



#pragma mark Picker Delegate Methods
//- (NSString *)pickerView:(UIPickerView *)pickerView
//             titleForRow:(NSInteger)row
//            forComponent:(NSInteger)component
//{
//    NSString *string;
//    
//    if(component == 0)
//        string = [pickerDataHour objectAtIndex:row];
//    else if(component == 1)
//        string = [pickerDataMinute objectAtIndex:row];
//    else if(component == 2)
//        string = [pickerDataMinute objectAtIndex:row];
//    
//    return string;
//
//}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    // create attributed string
    NSString *string;  //can also use array[row] to get string
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    if(component == 0)
    {
        string = [pickerDataHour objectAtIndex:row];
    }
    else if(component == 1)
    {
        string = [pickerDataMinute objectAtIndex:row];
    }
    else if(component == 2)
    {
        string = [pickerDataMinute objectAtIndex:row];
    }

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:attributeDict];
    
    // add the string to a label's attributedText property
    UILabel *labelView = [[UILabel alloc] init];
    labelView.attributedText = attributedString;
//    CGRect rect;
//    rect = labelView.frame;
//    rect.origin.x += 10;
//    labelView.frame = rect;
    
    //labelView.minimumFontSize = 8.;
    labelView.adjustsFontSizeToFitWidth = YES;
    [labelView setTextAlignment:UITextAlignmentCenter];
//    
//    CGRect rect;
//    rect = labelView.frame;
//    rect.origin.x = 0;
    
    //labelView.frame = rect;
    
    //[labelView setTextAlignment:uitexta]
    [labelView setBackgroundColor:[UIColor clearColor]];
    [labelView setFont:[UIFont boldSystemFontOfSize:25]];
    // return the label
    return labelView;
}

-(void)dealloc
{
    [super dealloc];
    [counterDownLabel release];
    [hourLabel release];
    [minLabel release];
    [secondLabel release];
    [line2 release];
    [line3 release];
    [startLabel release];
    [startSwitch release];
    [pickerView release];
    
    [pickerDataHour release];
    [pickerDataMinute release];
    [pickerDataSecond release];
    
    [timerClockConfigDic release];
}
@end
