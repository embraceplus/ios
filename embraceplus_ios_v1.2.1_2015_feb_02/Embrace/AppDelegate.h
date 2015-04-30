//
//  AppDelegate.h
//  Embrace
//
//  Created by s1 dred on 13-8-12.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIImage *backgroundImage;
    UIImage *backgroundImageTemp;
    
    NSMutableArray *notificationTitles;
    
    BOOL isBatteryLowNotified;
    
    NSMutableDictionary *grandfatherClockConfigDic;
//    NSMutableDictionary *fxMenuLightDataDic;
//    NSMutableDictionary *fxForStyleDic;
//    NSMutableDictionary *dictionary;
//    NSMutableArray *fxTitleArray;
    int colorId,count;
    BOOL isStart,isHalfHour,isVibration;
    
    NSMutableDictionary *timerClockConfigDic;
    NSNumber *startTimeInSecond;
    NSNumber *startCountDownValue;
    BOOL isTimerStart;
    BOOL isAlarmStart;
    
    BOOL isGrandpaClockRing;
    
    NSMutableDictionary *embraceUUIDDic;
}

@property bool isNoChooseStyleViewController;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *backgroundImageTemp;

+ (AppDelegate*) instance;

@end
