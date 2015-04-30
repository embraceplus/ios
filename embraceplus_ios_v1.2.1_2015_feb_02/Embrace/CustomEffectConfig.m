//
//  CustomEffectConfig.m
//  Embrace ios7
//
//  Created by 张达棣 on 13-12-31.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "CustomEffectConfig.h"

@implementation CustomEffectConfig

@synthesize patternIndex;
@synthesize colorIndex;
@synthesize leftRightValue;
@synthesize isVibrateOn;

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:patternIndex forKey:@"patternIndex"];
    [aCoder encodeInt:colorIndex forKey:@"colorIndex"];
    [aCoder encodeInt:leftRightValue forKey:@"leftRightValue"];
    [aCoder encodeBool:isVibrateOn forKey:@"isVibrateOn"];
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        patternIndex = [aDecoder decodeIntForKey:@"patternIndex"];
        colorIndex = [aDecoder decodeIntForKey:@"colorIndex"];
        leftRightValue = [aDecoder decodeIntForKey:@"leftRightValue"];
        isVibrateOn = [aDecoder decodeBoolForKey:@"isVibrateOn"];
    }
    
    return self;
}

@end
