//
//  FilePath.h
//  Embrace ios7
//
//  Created by 张达棣 on 14-1-11.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface FilePath : NSObject



+ (NSString *)fxMenuLightDataFilePath;
+ (NSString *)fxForStyleFilePath ;

+ (NSString *)notificationTitleFilePath;
+ (NSString *)notificationImageFilePath;
+ (NSString *)notificationIsSilentFilePath;

+(NSString *)callsNotificationTitleFilePath;
+ (NSString *)callsNotificationImageFilePath;
+ (NSString *)callsNotificationIsSilentFilePath;

+ (NSString *)customFxConfigFilePath;
+ (NSString *)embraceUUIDFilePath;

+ (NSString *)styleFxmenuTitleFilePath;
+ (NSString *)styleFxmenuImageFilePath;

+ (NSString *)clockNotificationTitleFilePath;
+ (NSString *)clockNotificationIsSilentFilePath;

+ (NSString *)grandfatherClockConfigFilePath;
+ (NSString *)timerClockConfigFilePath;


#pragma mark - kane
//+ (NSString *)getThemesNotificationFilePath:(NSString *)s;
//+ (NSString *)getImageNotificationFilePath:(NSString *)s;
//+ (NSString *)getThemesCallsFilePath:(NSString *)s;
//+ (void)initTitleDic:(NSArray *)arr;
//+ (void)initCallsDic:(NSArray *)arr;
//+ (void)initImageDic:(NSArray *)arr;
//+ (void)addThems:(NSString *)thems;

@end
