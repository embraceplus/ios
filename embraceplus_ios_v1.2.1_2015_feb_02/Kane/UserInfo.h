//
//  UserInfo.h
//  EmbracePlus ios7
//
//  Created by 晓坤张 on 14-9-7.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
//当前主题的名称
@property (nonatomic, strong) NSString *userThems;
//改变主题之后的列表下标刷新
@property(nonatomic,assign) BOOL isChangeText;
@property(nonatomic,assign) BOOL isChangeCalendar;
@property(nonatomic,assign) BOOL isChangeBattery;

//改变主题之后的列表下标刷新
@property(nonatomic,assign) BOOL isText;
@property(nonatomic,assign) BOOL isCalendar;
@property(nonatomic,assign) BOOL isBattery;

+ (UserInfo *) sharedInstance;

@end
