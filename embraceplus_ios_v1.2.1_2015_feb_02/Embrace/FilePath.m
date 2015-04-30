//
//  FilePath.m
//  Embrace ios7
//
//  Created by 张达棣 on 14-1-11.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import "FilePath.h"


@implementation FilePath

+ (NSString *)fxMenuLightDataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"fxMenuLightData.plist"];
}

+ (NSString *)fxForStyleFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"fxForStyle.plist"];
}

+ (NSString *)notificationTitleFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"notificationTitle.plist"];
}

+ (NSString *)notificationIsSilentFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"notificationIsSilent.plist"];
}

+ (NSString *)callsNotificationIsSilentFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"callsNotificationIsSilent.plist"];
}


+(NSString *)callsNotificationTitleFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"callsNotificationTitle.plist"];
}

+ (NSString *)customFxConfigFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"customFxConfig.plist"];
}

+ (NSString *)embraceUUIDFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"embraceUUID.plist"];
}


+ (NSString *)styleFxmenuTitleFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"styleTitle.plist"];
}
+ (NSString *)styleFxmenuImageFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"styleImage.plist"];
}

+ (NSString *)notificationImageFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"notificationImage.plist"];
}

+ (NSString *)callsNotificationImageFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"callsNotificationImage.plist"];
}

+ (NSString *)clockNotificationTitleFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"clockNotificationTitle.plist"];
}

+ (NSString *)clockNotificationIsSilentFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"clockNotificationIsSilent.plist"];
}

+ (NSString *)grandfatherClockConfigFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"grandfatherClockConfig.plist"];
}

+ (NSString *)timerClockConfigFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"timerClockConfig.plist"];
}

#pragma mark - 管理每一个样式 kane
////获取每一个主题的title路径
//+ (NSString *)getThemesNotificationFilePath:(NSString *)s
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"title%@",s]];
//}
////获取每一个主题图片的路径
//+ (NSString *)getImageNotificationFilePath:(NSString *)s
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"image%@",s]];
//}
//
////获取每一个主题的call路径
//+ (NSString *)getThemesCallsFilePath:(NSString *)s
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"calls%@",s]];
//}
//
//
////获取字典
//+ (NSString *)gettitleDicFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:@"filemanegedic.plist"];
//}
//
////获取字典
//+ (NSString *)getcallsDicFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:@"callsmanegedic.plist"];
//}
//
////获取字典
//+ (NSString *)getImagesDicFilePath
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(
//                                                         NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    return [documentsDirectory stringByAppendingPathComponent:@"imagessmanegedic.plist"];
//}
//
//
//////管理字典
////+(NSString *)cre
////{
////    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
////    if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath getDicFilePath]])
////    {
////        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath getDicFilePath]];
////    }
////    return nil;
////}
//
//
////初始化字典
//+ (void)initTitleDic:(NSArray *)arr
//{
//        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//        if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath gettitleDicFilePath]])
//        {
//            dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath gettitleDicFilePath]];
//        }
//        if(dic.count == 0)
//        {
//            NSArray *titleArr = [NSArray arrayWithObjects:@"Calls",@"Text",@"Calendar",@"Battery phone",@"Add event",nil];
//            for(int i = 0;i < titleArr.count-1;i++)
//            {
//                NSString *s = [FilePath getThemesNotificationFilePath:[arr objectAtIndex:i]];
//                [titleArr writeToFile:s atomically:YES];
//                [dic setValue:s forKey:[arr objectAtIndex:i]];
//            }
//            NSString *s = [FilePath gettitleDicFilePath];
//            [dic writeToFile:s atomically:YES];
//            
//            
//        }
//}
//
////初始化字典
//+ (void)initImageDic:(NSArray *)arr
//{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath getImagesDicFilePath]])
//    {
//        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath getImagesDicFilePath]];
//    }
//    if(dic.count == 0)
//    {
//        NSArray *imageArr = [NSArray arrayWithObjects:@"callIcon",@"smsIcon",@"calendarIcon",@"batteryIcon",@"addIcon",nil];
//        for(int i = 0;i < arr.count-1;i++)
//        {
//            NSString *s1 = [FilePath getImageNotificationFilePath:[arr objectAtIndex:i]];
//            [imageArr writeToFile:s1 atomically:YES];
//            [dic setValue:s1 forKey:[arr objectAtIndex:i]];
//        }
//        NSString *s1 = [FilePath getImagesDicFilePath];
//        [dic writeToFile:s1 atomically:YES];
//
//    }
//}
//
////初始化字典
//+ (void)initCallsDic:(NSArray *)arr
//{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath getcallsDicFilePath]])
//    {
//        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath getcallsDicFilePath]];
//    }
//    if(dic.count == 0)
//    {
//        NSArray *titleArr = [NSArray arrayWithObjects:@"Incoming call",@"Unknown call",nil];
//        for(int i = 0;i < arr.count-1;i++)
//        {
//            NSString *s = [FilePath getThemesCallsFilePath:[arr objectAtIndex:i]];
//            [titleArr writeToFile:s atomically:YES];
//            [dic setValue:s forKey:[arr objectAtIndex:i]];
//        }
//        NSString *s = [FilePath getcallsDicFilePath];
//        [dic writeToFile:s atomically:YES];
//    }
//}
//
//
//+ (void)addThems:(NSString *)them
//{
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath gettitleDicFilePath]])
//    {
//        dic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath gettitleDicFilePath]];
//    }
//    
//    NSArray *titleArr = [NSArray arrayWithObjects:@"Calls",@"Text",@"Calendar",@"Battery phone",@"Add event",nil];
//        NSString *s = [FilePath getThemesNotificationFilePath:them];
//        [titleArr writeToFile:s atomically:YES];
//        [dic setValue:s forKey:them];
//    
//    NSString *ss = [FilePath gettitleDicFilePath];
//    [dic writeToFile:ss atomically:YES];
//    
//    
//    
//    NSMutableDictionary *dic1 = [[NSMutableDictionary alloc] initWithCapacity:0];
//    if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath getcallsDicFilePath]])
//    {
//        dic1 = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath getcallsDicFilePath]];
//    }
//    
//    NSArray *titleArr1 = [NSArray arrayWithObjects:@"Incoming call",@"Unknown call",nil];;
//    NSString *s1 = [FilePath getThemesCallsFilePath:them];
//    [titleArr1 writeToFile:s1 atomically:YES];
//    [dic1 setValue:s1 forKey:them];
//    
//    NSString *sss = [FilePath getcallsDicFilePath];
//    [dic1 writeToFile:sss atomically:YES];
//    
//    
//    
//    
//    NSMutableDictionary *dic2 = [[NSMutableDictionary alloc] initWithCapacity:0];
//    if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath getImagesDicFilePath]])
//    {
//        dic2 = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath getImagesDicFilePath]];
//    }
//    
//    NSArray *imageArr = [NSArray arrayWithObjects:@"callIcon",@"smsIcon",@"calendarIcon",@"batteryIcon",@"addIcon",nil];
//    NSString *ssss = [FilePath getImageNotificationFilePath:them];
//    [imageArr writeToFile:ssss atomically:YES];
//    [dic2 setValue:ssss forKey:them];
//    
//    NSString *sssss = [FilePath getImagesDicFilePath];
//    [dic writeToFile:sssss atomically:YES];
//
//}
@end
