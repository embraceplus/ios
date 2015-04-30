//
//  NotificationSwitched.h
//  Embrace ios7
//
//  Created by 张达棣 on 14-1-11.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *callsNotificationString;
extern NSString *textNotificationString;
extern NSString *emailNotificationString;
extern NSString *clockNotificationString;
extern NSString *calendarNotificationString;
extern NSString *facebookNotificationString;
extern NSString *twitterNotificationString;
extern NSString *tumblrNotificationString;
extern NSString *skypeNotificationString;
extern NSString *instagramNotificationString;
extern NSString *linkedinNotificationString;
extern NSString *whatsappNotificationString;
extern NSString *facetimeNotificationString;
extern NSString *viberNotificationString;
extern NSString *pinterestNotificationString;
extern NSString *fourSquareNotificationString;
extern NSString *candyCrushNotificationString;
extern NSString *phoneOutOfRangeNotificationString;
extern NSString *batteryEmbraceNotificationString;
extern NSString *batteryPhoneNotificationString;
extern NSString *scrabbleNotificationString;
extern NSString *scrabbleFreeNotificationString;


extern NSString *incomingCallNotificationString;
extern NSString *unknownCallNotificationString;


@interface NotificationUtility : NSObject

+(void) disableNotificationByAppId:(int)appId;
+(void) disableNotificationByTitle:(NSString *)notificationTitle;
+(void) singleNotificationSwitched:(int)styleIndex notificationIndex:(int)notificationIndex mode:(int)mode;
+(void) allNotificationSwitched:(int)styleIndex status:(int)status;
+(int) notificationIndexToAppid:(int)notificationIndex;
+(int) notificationTitleToAppid:(NSString *)notificationTitle;
+(int) getNotificationSilentStatus:(int)notificationIndex;
+(void) configAllNotification:(int)styleIndex;
@end

