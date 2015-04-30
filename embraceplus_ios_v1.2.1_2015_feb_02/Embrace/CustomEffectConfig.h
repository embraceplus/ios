//
//  CustomEffectConfig.h
//  Embrace ios7
//
//  Created by 张达棣 on 13-12-31.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomEffectConfig : NSObject<NSCoding>

@property (nonatomic) int patternIndex;
@property (nonatomic) int colorIndex;
@property (nonatomic) int lColorId;
@property (nonatomic) int rColorId;
@property (nonatomic) int leftRightValue;
@property (nonatomic) BOOL isVibrateOn;

@end
