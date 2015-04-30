//
//  NotificationSwitched.m
//  Embrace ios7
//
//  Created by 张达棣 on 14-1-11.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import "NotificationUtility.h"
#import "FilePath.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
//#import "EmbLayer.h"
#import "AnimationParameter.h"
#import "EmulatorView.h"

NSString *callsNotificationString = @"Calls";
NSString *textNotificationString = @"Text";
NSString *emailNotificationString = @"Email";
NSString *clockNotificationString = @"Clock";
NSString *calendarNotificationString = @"Calendar";
NSString *facebookNotificationString = @"Facebook";
NSString *twitterNotificationString = @"Twitter";
NSString *tumblrNotificationString = @"Tumblr";
NSString *skypeNotificationString = @"Skype";
NSString *instagramNotificationString = @"Instagram";
NSString *linkedinNotificationString = @"LinkedIn";
NSString *whatsappNotificationString = @"WhatsApp";
NSString *facetimeNotificationString = @"FaceTime";
NSString *viberNotificationString = @"Viber";
NSString *pinterestNotificationString = @"Pinterest";
NSString *fourSquareNotificationString = @"FourSquare";
NSString *candyCrushNotificationString = @"CandyCrush";
NSString *phoneOutOfRangeNotificationString = @"Phone out of range";
NSString *batteryEmbraceNotificationString = @"Battery Embrace+";
NSString *batteryPhoneNotificationString = @"Battery phone";
NSString *scrabbleNotificationString = @"Scrabble";
NSString *scrabbleFreeNotificationString = @"Scrabble free";


NSString *incomingCallNotificationString = @"Incoming call";
NSString *unknownCallNotificationString = @"Unknown call";

@implementation NotificationUtility

+(void) singleNotificationSwitched:(int)styleIndex notificationIndex:(int)notificationIndex mode:(int)mode
{
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *styleDictionary;
    NSMutableDictionary *notificationDictionary;
    NSMutableDictionary *fxMenuLightDataDic;
    
    NSMutableArray *titleArray;
    NSMutableArray *imageNameArray;

    
    int selectFxIndex;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
        styleDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
        
        notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        
        NSLog(@"select style = %d",styleIndex);
        
        titleArray = [styleDictionary objectForKey:@"title"];
        imageNameArray = [styleDictionary objectForKey:@"image"];
        
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",notificationIndex]] intValue];
        
    }
 
    NSString* file = [FilePath fxMenuLightDataFilePath];
    NSString* title = [titleArray objectAtIndex:selectFxIndex];
    
    
//    AnimationParameter* animationParameter = [[AnimationParameter alloc] initFromFile:file title:title];
    AnimationParameter* animationParameter = [AnimationParameter createFromFile:file title:title];
    
    /*
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }

    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
    
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
    
    if(mode == 0)
        [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
     */
    
    NSLog(@"notificationIndex !!!!!!!!!!!!!= %d",notificationIndex);

    int appId = [NotificationUtility notificationIndexToAppid:notificationIndex];
    
    int silent = [NotificationUtility getNotificationSilentStatus:notificationIndex];
    
    NSLog(@"appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
    
    //if it is caller Id, don't set the config, because it will overwrite incoming call
    if(notificationIndex >=102 && notificationIndex <200)
        return;
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    //set update configuration
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    [service writeUpdateCofig:appId parameter:animationParameter silent:silent];
//    [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:loop];

}
+(void) disableNotificationByTitle:(NSString *)notificationTitle
{

    int appId = [NotificationUtility notificationTitleToAppid:notificationTitle];
    
    [NotificationUtility disableNotificationByAppId:appId];
    
}

+(void) disableNotificationByAppId:(int)appId
{
    /*
    int lFromR = 0;
    int lFromG = 0;
    int lFromB = 0;
    
    int lToR = 0;
    int lToG = 0;
    int lToB = 0;
    
    int rFromR = 0;
    int rFromG = 0;
    int rFromB = 0;
    
    int rToR = 0;
    int rToG = 0;
    int rToB = 0;
    
    int durationTime1 = 0;
    int durationTime2 = 0;
    int isBlackout = 0;
    int isRandom = 0;
    
    int hold = 0;
    int pause = 0;
    int isVibrate = 0;
     */
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    
    //set update configuration
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    
    [service writeUpdateCofig:appId parameter:nil silent:1];
    
//    [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:1 VIBRATE:isVibrate LOOP:1];
    
}
+(void) allNotificationSwitched:(int)styleIndex status:(int)status
{
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *styleDictionary;
    NSMutableDictionary *notificationDictionary;
    NSMutableDictionary *fxMenuLightDataDic;
    
    NSMutableArray *titleArray;
    NSMutableArray *imageNameArray;
    
    
    int selectFxIndex;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
        styleDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
        
        notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        
        NSLog(@"select style = %d",styleIndex);
        
        titleArray = [styleDictionary objectForKey:@"title"];
        imageNameArray = [styleDictionary objectForKey:@"image"];
        
        
        
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }
    
 
    NSString* file = [FilePath fxMenuLightDataFilePath];
    
    /*
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
     */
    
    NSMutableArray *notificationIsSilent;
    NSMutableArray *callsNotificationIsSilent;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationIsSilentFilePath]];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
    {
        
        callsNotificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
    }

    
    for(int i=0;i<[notificationIsSilent count];i++)
    {
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];

        NSString* title = [titleArray objectAtIndex:selectFxIndex];
        
        AnimationParameter* animationParameter = [AnimationParameter createFromFile:file title:title];
        
        /*
        NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
        
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
        loop = [[lightDataArray objectAtIndex:18] intValue];
         */
        
        int appId = [NotificationUtility notificationIndexToAppid:i];
        int silent;
        if(status == 0)
        {
            silent = 1;
        }
        else
        {
            silent = [notificationIsSilent[i] intValue];
        }
        
        
        NSLog(@"appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
        if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
            return;
        
        //set update configuration
        LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
        
        [service writeUpdateCofig:appId parameter:animationParameter silent:silent];
//        [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:1];
        
    }

  
    for(int i=0;i<2;i++)
    {
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",i+100]] intValue];
        
        NSString* title = [titleArray objectAtIndex:selectFxIndex];
        
        AnimationParameter* animationParameter = [AnimationParameter createFromFile:file title:title];
        
        /*
        NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
        
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
         */
        
        int appId = [NotificationUtility notificationIndexToAppid:i+100];
        int silent;
        if(status == 0)
        {
            silent = 1;
        }
        else
        {
            silent = [callsNotificationIsSilent[i] intValue];
        }
        
        
        NSLog(@"call appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
        if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
            return;
        
        //set update configuration
        LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
        
        [service writeUpdateCofig:appId parameter:animationParameter silent:silent];
//        [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:1];
        
    }

}

+(void) configAllNotification:(int)styleIndex
{
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *styleDictionary;
    NSMutableDictionary *notificationDictionary;
    NSMutableDictionary *fxMenuLightDataDic;
    
    NSMutableArray *titleArray;
    NSMutableArray *imageNameArray;
    
    
    int selectFxIndex;
    
    //pop up a window
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
        styleDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
        
        notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        
        NSLog(@"select style = %d",styleIndex);
        
        titleArray = [styleDictionary objectForKey:@"title"];
        imageNameArray = [styleDictionary objectForKey:@"image"];
        
        
        
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }
    
    NSString* file = [FilePath fxMenuLightDataFilePath];
    
    /*
    
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
     */
    
    int appIdConfiged[30];
    int appIdIndex = 0;
    
    NSMutableArray *notificationIsSilent;
    NSMutableArray *callsNotificationIsSilent;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationIsSilentFilePath]];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
    {
        
        callsNotificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
    }
    
    
    for(int i=0;i<[notificationIsSilent count];i++)
    {
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] intValue];
        
        NSString* title = [titleArray objectAtIndex:selectFxIndex];
        AnimationParameter* animationParameter = [AnimationParameter createFromFile:file title:title];
        
        /*
        NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
        
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
        
         */
        int appId = [NotificationUtility notificationIndexToAppid:i];
        appIdConfiged[appIdIndex] = appId;
        appIdIndex ++;
        int silent;
    
        silent = [notificationIsSilent[i] intValue];
        
        
        NSLog(@"appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
        if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
            return;
        
        //set update configuration
        LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
        
        [service writeUpdateCofig:appId parameter:animationParameter silent:silent];
//        [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:1];
        
    }
    
    
    for(int i=0;i<2;i++)
    {
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",i+100]] intValue];
        
        NSString* title = [titleArray objectAtIndex:selectFxIndex];
        AnimationParameter* animationParameter = [AnimationParameter createFromFile:file title:title];
        /*
        NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
        
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
        */
        int appId = [NotificationUtility notificationIndexToAppid:i+100];
        appIdConfiged[appIdIndex] = appId;
        appIdIndex ++;
        
        int silent;
      
   
        silent = [callsNotificationIsSilent[i] intValue];
    
        
        
        NSLog(@"call appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
        if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
            return;
        
        //set update configuration
        LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
        
        [service writeUpdateCofig:appId parameter:animationParameter silent:silent];
        
//        [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:1];
        
    }
    

    for(int i =1;i < 23;i++)
    {
        BOOL isFound = NO;
        //search unconfig appid
        for(int j =0;j<22;j++)
        {
            if(i == appIdConfiged[j])
            {
                isFound = YES;
                break;
            }
        }
        if(!isFound)
        {
            [NotificationUtility disableNotificationByAppId:i];
        }
        
    }
    
}

+(int) notificationTitleToAppid:(NSString *)notificationTitle
{
    
    int appId;
    
    if([notificationTitle rangeOfString:callsNotificationString].length!=0)
    {
        appId = 0x1;
    }
    
    if([notificationTitle rangeOfString:textNotificationString].length!=0)
    {
        appId = 0x2;
    }
    
    if([notificationTitle rangeOfString:emailNotificationString].length!=0)
    {
        appId = 0x3;
    }
    
    if([notificationTitle rangeOfString:calendarNotificationString].length!=0)
    {
        appId = 0x4;
    }
    
    if([notificationTitle rangeOfString:facebookNotificationString].length!=0)
    {
        appId = 0x5;
    }
    
    if([notificationTitle rangeOfString:twitterNotificationString].length!=0)
    {
        appId = 0x6;
    }
    
    if([notificationTitle rangeOfString:tumblrNotificationString].length!=0)
    {
        appId = 0x7;
    }
    
    if([notificationTitle rangeOfString:skypeNotificationString].length!=0)
    {
        appId = 0x8;
    }
    
    if([notificationTitle rangeOfString:instagramNotificationString].length!=0)
    {
        appId = 0x9;
    }
    
    
    if([notificationTitle rangeOfString:linkedinNotificationString].length!=0)
    {
        appId = 10;
    }
    
    if([notificationTitle rangeOfString:whatsappNotificationString].length!=0)
    {
        appId = 11;
    }
    
    if([notificationTitle rangeOfString:facetimeNotificationString].length!=0)
    {
        appId = 12;
    }
    
    if([notificationTitle rangeOfString:viberNotificationString].length!=0)
    {
        appId = 13;
    }
    
    if([notificationTitle rangeOfString:pinterestNotificationString].length!=0)
    {
        appId = 14;
    }
    
    if([notificationTitle rangeOfString:fourSquareNotificationString].length!=0)
    {
        appId = 15;
    }
    
    if([notificationTitle rangeOfString:candyCrushNotificationString].length!=0)
    {
        appId = 16;
    }
    
    if([notificationTitle rangeOfString:phoneOutOfRangeNotificationString].length!=0)
    {
        appId = 17;
    }
    
    if([notificationTitle rangeOfString:batteryEmbraceNotificationString].length!=0)
    {
        appId = 18;
    }
    
    if([notificationTitle rangeOfString:batteryPhoneNotificationString].length!=0)
    {
        appId = 19;
    }
    
    if([notificationTitle rangeOfString:scrabbleNotificationString].length!=0)
    {
        appId = 21;
    }
    
    if([notificationTitle rangeOfString:scrabbleFreeNotificationString].length!=0)
    {
        appId = 22;
    }
        
    
    
    NSLog(@"appid = %d",appId);
    
    return appId;
    
}

+(int) notificationIndexToAppid:(int)notificationIndex
{
    
    NSMutableArray *notificationTitles;
    
    int appId;
    
    if(notificationIndex <100)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
        {
            
            notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
//            notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath getThemesNotificationFilePath:[UserInfo sharedInstance].userThems]];
            
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:callsNotificationString].length!=0)
        {
            appId = 0x1;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:textNotificationString].length!=0)
        {
            appId = 0x2;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:emailNotificationString].length!=0)
        {
            appId = 0x3;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:calendarNotificationString].length!=0)
        {
            appId = 0x4;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:facebookNotificationString].length!=0)
        {
            appId = 0x5;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:twitterNotificationString].length!=0)
        {
            appId = 0x6;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:tumblrNotificationString].length!=0)
        {
            appId = 0x7;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:skypeNotificationString].length!=0)
        {
            appId = 0x8;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:instagramNotificationString].length!=0)
        {
            appId = 0x9;
        }
        
        
        if([notificationTitles[notificationIndex] rangeOfString:linkedinNotificationString].length!=0)
        {
            appId = 10;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:whatsappNotificationString].length!=0)
        {
            appId = 11;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:facetimeNotificationString].length!=0)
        {
            appId = 12;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:viberNotificationString].length!=0)
        {
            appId = 13;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:pinterestNotificationString].length!=0)
        {
            appId = 14;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:fourSquareNotificationString].length!=0)
        {
            appId = 15;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:candyCrushNotificationString].length!=0)
        {
            appId = 16;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:phoneOutOfRangeNotificationString].length!=0)
        {
            appId = 17;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:batteryEmbraceNotificationString].length!=0)
        {
            appId = 18;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:batteryPhoneNotificationString].length!=0)
        {
            appId = 19;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:scrabbleNotificationString].length!=0)
        {
            appId = 21;
        }
        
        if([notificationTitles[notificationIndex] rangeOfString:scrabbleFreeNotificationString].length!=0)
        {
            appId = 22;
        }
        
    }
    else if(notificationIndex <200)
    {
        
        if(notificationIndex == 100)
        {
            appId = 1;
        }
        else if(notificationIndex == 101)
        {
            appId = 20;
        }
        else
        {
            appId = 1;
        }
        
    }
    else if(notificationIndex <300)
    {
        
    }
    
    NSLog(@"appid = %d",appId);
    
    return appId;

}

+(int) getNotificationSilentStatus:(int)notificationIndex
{
    int silent;
    NSMutableArray *notificationIsSilent;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *globleNotificationSwitchStatus = [ud objectForKey:@"globleNotificationSwitchStatus"];
    
    if([globleNotificationSwitchStatus intValue] == 0)
    {
        silent = 1;
    }
    else
    {
        if(notificationIndex <100)
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationIsSilentFilePath]])
            {
                
                notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationIsSilentFilePath]];
            }
            
            silent = [notificationIsSilent[notificationIndex] intValue];

        }
        else if(notificationIndex <200)
        {
            //check the status of calls group first
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
            {
                
                notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
            }
            
            silent = [notificationIsSilent[notificationIndex-100] intValue];

        }
        else if(notificationIndex <300)
        {
            if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath clockNotificationIsSilentFilePath]])
            {
                
                notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath clockNotificationIsSilentFilePath]];
            }
            
            silent = [notificationIsSilent[notificationIndex-200] intValue];
        }
    }
    
    return silent;
}


@end
