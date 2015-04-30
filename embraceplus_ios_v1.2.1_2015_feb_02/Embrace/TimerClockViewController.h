//
//  AddFxMenuViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FxIconsViewController.h"
#import "AppDelegate.h"
#import "AddFxMenuViewController.h"
#import "BaseFxMenuViewController.h"

@class AddFxMenuViewController;


@interface TimerClockViewController : BaseFxMenuViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    IBOutlet UILabel *counterDownLabel;
    IBOutlet UILabel *hourLabel;
    IBOutlet UILabel *minLabel;
    IBOutlet UILabel *secondLabel;
    
    IBOutlet UIImageView *line2;
    IBOutlet UIImageView *line3;
    
    IBOutlet UILabel *startLabel;
    IBOutlet UISwitch *startSwitch;
    
    IBOutlet UIPickerView * pickerView;
    NSMutableArray *pickerDataHour;
    NSMutableArray *pickerDataMinute;
    NSMutableArray *pickerDataSecond;
    
    AppDelegate *appDelegate;
    
    NSTimer *myTimer;
    

    BOOL isTimerStart;
    double timerValueInSecond;
    NSTimeInterval timerStartTime;
    
    NSMutableDictionary *timerClockConfigDic;
    NSNumber *startTimeInSecond;
    NSNumber *startCountDownValue;
    BOOL isStart;

}

@property (nonatomic, retain) NSString *iconName;

- (IBAction)dateChanged;

@end
