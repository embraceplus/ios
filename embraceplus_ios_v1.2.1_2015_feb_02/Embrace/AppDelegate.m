//
//  AppDelegate.m
//  Embrace
//
//  Created by s1 dred on 13-8-12.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "AppDelegate.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
//#import "EmbLayer.h"
#import "FilePath.h"
#import "NotificationUtility.h"
#import "PresetEffect.h"
#import "UserInfo.h"

extern  int selectStyleIndex;
BOOL isFirstConnect;
@implementation AppDelegate
@synthesize backgroundImage;
@synthesize backgroundImageTemp;
@synthesize isNoChooseStyleViewController;

static AppDelegate* instance;

+ (AppDelegate *)instance{
    return instance;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    instance = self;
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    

    isNoChooseStyleViewController = false;
    isFirstConnect = YES;
    
    // Override point for customization after application launch.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([[ud objectForKey:@"isChangeBg"] boolValue])
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:@"backgroundImageView.png"];
        backgroundImage = [UIImage imageWithContentsOfFile:fullPathToFile];
        backgroundImageTemp = [UIImage imageWithContentsOfFile:fullPathToFile];
    }
    else
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bg_Business" ofType:@"png"];
        backgroundImage = [UIImage imageWithContentsOfFile:path];
        backgroundImageTemp = [UIImage imageWithContentsOfFile:path];
    }

    
    if([ud objectForKey:@"globleNotificationSwitchStatus"]== nil)
        [ud setObject:[NSNumber numberWithBool:YES] forKey:@"globleNotificationSwitchStatus"];
    
    NSLog(@"AppDelegate");
//    // initialize cocos2d director
	CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
	//director.wantsFullScreenLayout = NO;
    director.wantsFullScreenLayout = YES;
	director.projection = kCCDirectorProjection2D;
	director.animationInterval = 1.0 / 60.0;
	director.displayStats = YES;
	//[director enableRetinaDisplay:YES];
    if( ! [director enableRetinaDisplay:YES] )
    {
        CCLOG(@"Retina Display Not supported");
    }
    
    
    // If the 1st suffix is not found and if fallback is enabled then fallback suffixes are going to searched. If none is found, it will try with the name without suffix.
	// On iPad HD  : "-ipadhd", "-ipad",  "-hd"
	// On iPad     : "-ipad", "-hd"
	// On iPhone HD: "-hd"
	CCFileUtils *sharedFileUtils = [CCFileUtils sharedFileUtils];
	[sharedFileUtils setEnableFallbackSuffixes:NO];				// Default: NO. No fallback suffixes are going to be used
	[sharedFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[sharedFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "ipad"
	[sharedFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

    isBatteryLowNotified = NO;
    
    //start timer
     NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(inquiryInBackground) userInfo:nil repeats:YES];
    
    
     //NSTimer *bleTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectBleConnection) userInfo:nil repeats:YES];
    
    UIWindow *window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    CGRect  viewRect = [window_ bounds];
    CCGLView* view = [[CCGLView alloc] initWithFrame:viewRect];
    
     director.view = view;
    //[director runWithScene:[EmbLayer scene:0]];
    
#pragma mark - kane
    [UserInfo sharedInstance].userThems = [[NSUserDefaults standardUserDefaults] stringForKey:@"styletitle"];
    return YES;
}

- (void)detectBleConnection // @BLE
{
    NSLog(@"detectBleConnection");
    if([[[LeDiscovery sharedInstance] connectedServices] count] != 0)
    {
        return;
    }
    
    CBCentralManager * central;
    central = ((LeDiscovery *)[LeDiscovery sharedInstance]).centralManager;
    
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(version<7.0)
    {
        [central retrieveConnectedPeripherals];
    }
    else
    {
        NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:kEmbraceServiceUUIDString], nil];
        
        NSArray *connectedPeripheralArray = [[NSArray alloc] init];
        connectedPeripheralArray = [central retrieveConnectedPeripheralsWithServices:uuidArray];
        
        NSLog(@"connectedPeripheralArray = %d",[connectedPeripheralArray count]);
        CBPeripheral *peripheral;
        
        NSString *UUID;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
        {
            embraceUUIDDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath embraceUUIDFilePath]];
            
            UUID = [embraceUUIDDic objectForKey:@"UUID"];
            NSLog(@"saved uuid = %@",UUID);
            
        }
        else
        {
            UUID = @"";
        }
        
        if([connectedPeripheralArray count] > 0)
        {
            for (peripheral in connectedPeripheralArray) {
                NSLog(@"didRetrieveConnectedPeripherals");
                
                if([[peripheral.identifier UUIDString] isEqualToString:UUID])
                {
                    NSLog(@"uuid is found");
                    [central connectPeripheral:peripheral options:nil];
                    //[peripheral retain];
                    return;
                }
            }
            
            [central connectPeripheral:connectedPeripheralArray[0] options:nil];
            //[connectedPeripheralArray[0] retain];
            
        }else
        {
            NSLog(@"start scanning!!!!!!!");
            [[LeDiscovery sharedInstance] startScanningForUUIDString:kEmbraceServiceUUIDString];
        }
        
    }

}

- (void)inquiryInBackground
{
    
    ///////////

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDate * alarmClock = [ud objectForKey:@"alarmClock"];
    NSDate * currentDate = [NSDate date];
    
    isAlarmStart = [[ud objectForKey:@"alarmIsStart"] boolValue];
    if(isAlarmStart)
    {
        if([currentDate compare:alarmClock] == NSOrderedDescending)
        {
            NSLog(@"alarm is coming");
            [ud setObject:[NSNumber numberWithBool: NO] forKey:@"alarmIsStart"];
            [ud setObject:[NSNumber numberWithBool: NO] forKey:@"isStartOn"];
            
            if([NotificationUtility getNotificationSilentStatus:200]==0)
            {
                [self sendAlarmandTimerEffect:0];
                
                //turn off alarm
                [[NSNotificationCenter  defaultCenter]postNotificationName:@"turnOffAlarmNotification" object:nil];
            }
        
        }
        else
        {
            NSLog(@"alarmClock = %@, currentTime = %@", alarmClock, currentDate);

        }
    }
    
    //grandpa
    NSTimeInterval currentTime = [currentDate timeIntervalSince1970]*1;
    NSNumber *grandpaTimeNumber;
    double timerNextValueInSecond;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath grandfatherClockConfigFilePath]])
    {
        grandfatherClockConfigDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath grandfatherClockConfigFilePath]];
        colorId = [[grandfatherClockConfigDic objectForKey:@"clolorIndex"] intValue];
        isHalfHour = [[grandfatherClockConfigDic objectForKey:@"halfhour"] boolValue];
        isVibration = [[grandfatherClockConfigDic objectForKey:@"vibration"] boolValue];
        count = [[grandfatherClockConfigDic objectForKey:@"count"] intValue];
        isStart = [[grandfatherClockConfigDic objectForKey:@"isStart"] boolValue];
        //grandpaTimeNumber = [grandfatherClockConfigDic objectForKey:@"endTime"];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
        NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
        
        
        if(isStart)
        {
            
            NSLog(@"HalfHour hour = %d,min = %d,sec = %d",[comps hour],[comps minute],[comps second]);
            if([comps minute]== 30)
            {
                if(isHalfHour == YES)
                {
                    if(!isGrandpaClockRing)
                    {
                        if([NotificationUtility getNotificationSilentStatus:202]==0)
                        {
                            [self sendGranpaEffect:1];
                        }
                        
                        isGrandpaClockRing = YES;
                    }
                }
    
            }
            else if([comps minute]== 0)
            {
                if(count == 0)
                {
                    if(!isGrandpaClockRing)
                    {
                        if([NotificationUtility getNotificationSilentStatus:202]==0)
                        {
                            [self sendGranpaEffect:1];
                        }
                        
                        isGrandpaClockRing = YES;
                    }

                }
                else
                {
                    if(!isGrandpaClockRing)
                    {
                        if([NotificationUtility getNotificationSilentStatus:202]==0)
                        {
                            int cycleNum;
                            if([comps hour]>12)
                            {
                                cycleNum = [comps hour] - 12;
                            }
                            else
                            {
                                cycleNum = [comps hour];
                            }
                            //for(int i=0;i<cycleNum;i++)
                            NSLog(@"vibratation count= %d",cycleNum);
                            [self sendGranpaEffect:cycleNum];
                        }
                        
                        isGrandpaClockRing = YES;
                    }

                }
            }
            else
            {
                isGrandpaClockRing = NO;
            }
            //just send once
        
            
        }
        
    }
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath timerClockConfigFilePath]])
    {
        timerClockConfigDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath timerClockConfigFilePath]];
        
        isTimerStart = [[timerClockConfigDic objectForKey:@"isStart"] boolValue];
        startTimeInSecond = [timerClockConfigDic objectForKey:@"startTimeInSecond"];
        startCountDownValue = [timerClockConfigDic objectForKey:@"startCountDownValue"];
        
        if(isTimerStart)
        {
            if(currentTime > [startTimeInSecond doubleValue] + [startCountDownValue doubleValue])
            {
                //send effect
                NSLog(@"timer clock comes");
                if([NotificationUtility getNotificationSilentStatus:201]==0)
                {
                    [self sendAlarmandTimerEffect:1];
                }
                [timerClockConfigDic setObject:@"0" forKey:@"isStart"];
                [timerClockConfigDic writeToFile:[FilePath timerClockConfigFilePath] atomically:YES];
                
            }
            else
            {
                double delta;
                int hour,minute,second;
                delta = [startCountDownValue doubleValue] - (currentTime - [startTimeInSecond doubleValue]);
                hour = delta/3600;
                minute = (delta - hour*3600)/60;
                second = delta - hour*3600 - minute *60;
                NSLog(@"To next timer clock time = %d:%d:%d",hour,minute,second);
            }
            
        }
        
    }
    
    
}

- (void) sendAlarmandTimerEffect:(int)type
{
    
    int selectFxIndex;
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];

    
    NSMutableArray *fxTitleArray;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        NSMutableDictionary *fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
        NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",selectStyleIndex]];
        fxTitleArray = [dictionary objectForKey:@"title"];
        
        NSMutableDictionary *notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",selectStyleIndex]];
        
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
        {
            
            notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
        }
        
        if(type == 0)
        {
            selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",200]] intValue];
        }
        else if(type == 1)
        {
            selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",201]] intValue];
        }

        
    }
    
    
    NSMutableDictionary *fxMenuLightDataDic = [[NSMutableDictionary alloc]init];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }
    
    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[fxTitleArray objectAtIndex:selectFxIndex]];
    
    
    int lFromR;
    int lFromG;
    int lFromB;
    
    int lToR;
    int lToG;
    int lToB;
    
    int rFromR;
    int rFromG;
    int rFromB;
    
    int rToR;
    int rToG;
    int rToB;
    
    int durationTime1;
    int durationTime2;
    int isBlackout;
    int isRandom;
    
    int hold;
    int pause;
    int isVibrate;
    int loop;
    
    
    lFromR = [[lightDataArray objectAtIndex:0] intValue];    //L灯 R  (From)
    lFromG= [[lightDataArray objectAtIndex:1] intValue];    //L灯 G  (From)
    lFromB = [[lightDataArray objectAtIndex:2] intValue];    //L灯 B  (From)
    
    lToR = [[lightDataArray objectAtIndex:3] intValue];    //L灯 R  (To)
    lToG = [[lightDataArray objectAtIndex:4] intValue];    //L灯 G  (To)
    lToB = [[lightDataArray objectAtIndex:5] intValue];    //L灯 B  (To)
    
    
    rFromR= [[lightDataArray objectAtIndex:6] intValue];    //R灯 R  (From)
    rFromG= [[lightDataArray objectAtIndex:7] intValue];    //R灯 G  (From)
    rFromB= [[lightDataArray objectAtIndex:8] intValue];    //R灯 B  (From)
    
    rToR = [[lightDataArray objectAtIndex:9] intValue];    //R灯 R  (To)
    rToG = [[lightDataArray objectAtIndex:10] intValue];    //R灯 G  (To)
    rToB = [[lightDataArray objectAtIndex:11] intValue];    //R灯 B  (To)
    
    durationTime1 = [[lightDataArray objectAtIndex:12] intValue];    //duration
    durationTime2 = [[lightDataArray objectAtIndex:13] intValue];    //duration
    
    isBlackout = [[lightDataArray objectAtIndex:14] intValue];
    isRandom = [[lightDataArray objectAtIndex:15] intValue];
    hold = [[lightDataArray objectAtIndex:16] intValue];
    pause = [[lightDataArray objectAtIndex:17] intValue];
    isVibrate = [[lightDataArray objectAtIndex:18] intValue];
    loop = [[lightDataArray objectAtIndex:19] intValue];
    
    [service writeEffectCommand:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:0 VIBRATE:isVibrate LOOP:loop];
}
- (void) sendGranpaEffect:(int)loop
{
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    
    int lFromR;
    int lFromG;
    int lFromB;
    
    int lToR;
    int lToG;
    int lToB;
    
    int rFromR;
    int rFromG;
    int rFromB;
    
    int rToR;
    int rToG;
    int rToB;
    
    int durationTime1;
    int durationTime2;
    int isBlackout;
    int isRandom;
    
    int hold;
    int pause;
    //int isVibrate;
    
    ccColor3B colorTemp;
    switch (colorId) {
        case 0:
            
            colorTemp = emColor1;
            break;
            
//        case 1:
//            
//            break;
            
        case 1:
            colorTemp = emColor3;
            break;
            
        case 2:
            colorTemp = emColor4;
            break;
            
        case 3:
            colorTemp = emColor5;
            break;
            
        case 4:
            colorTemp = emColor6;
            break;
            
        case 5:
            colorTemp = emColor7;
            break;
            
        case 6:
            colorTemp = emColor8;
            break;
            
        case 7:
            colorTemp = emColor9;
            break;
            
        case 8:
            colorTemp = emColor10;
            break;
            
        case 9:
            colorTemp = emColor11;
            break;
            
        case 10:
            colorTemp = emColor12;
            break;
            
        case 11:
            colorTemp = emColor13;
            break;
            
        case 12:
            colorTemp = emColor14;
            break;
            
        case 13:
            colorTemp = emColor15;
            break;
            
        case 14:
            colorTemp = emColor16;
            break;
            
        default:
            break;
    }
    
    
//    if(colorId == 1)
//    {
//        isRandom = 1;
//    }
//    else
//    {
//        isRandom = 0;
//    }
    
    isRandom = 0;
    durationTime1 = emPatternLongBeat2.durationTime1;
    durationTime2 = emPatternLongBeat2.durationTime2;
    pause = emPatternLongBeat2.pause;
    isBlackout = 1;
    hold = emPatternLongBeat2.hold;
    
    
    lToR = colorTemp.r;
    lToG = colorTemp.g;
    lToB = colorTemp.b;
    
    rToR = colorTemp.r;
    rToG = colorTemp.g;
    rToB = colorTemp.b;

    lFromR = 256;
    lFromG = 0;
    lFromB = 0;
    
    rFromR = 256;
    rFromG = 0;
    rFromB = 0;

    
     [service writeEffectCommand:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:0 VIBRATE:isVibration LOOP:loop];
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] pause];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [[CCDirector sharedDirector] stopAnimation]; // call this to make sure you don't start a second display link!
        [[CCDirector sharedDirector] resume];
        [[CCDirector sharedDirector] startAnimation];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
