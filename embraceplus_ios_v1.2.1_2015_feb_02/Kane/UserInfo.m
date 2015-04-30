//
//  UserInfo.m
//  EmbracePlus ios7
//
//  Created by 晓坤张 on 14-9-7.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+ (UserInfo *) sharedInstance
{
    //定义一个全局变量
    static UserInfo *share = nil;
    //synchronized类似于一个线程锁 主要防止多线程的不规则性破坏了单例模式的只允许拥有一个实例的原则
    @synchronized(self)
    {
        if (share == nil )
        {
            share = [[self alloc] init];
        }
    }
    return share;

}

// 当第一次使用这个单例时，会调用这个init方法。
- (id)init
{
    self = [super init];
    
    if (self) {
      
    }
    
    return self;
}


@end
