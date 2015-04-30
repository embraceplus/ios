//
//  self.m
//  EmbracePlus ios7
//
//  Created by 赵雅琦 on 14-12-1.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import "AnimationParameter.h"
#import "FilePath.h"

@implementation AnimationParameter

+ (id)create{
    return [[AnimationParameter alloc] init];
}

+ (id)createFromArray:(NSArray *)array{
    return [[AnimationParameter alloc] initFromArray:array];
}

+ (id)createFromFile:(NSString *)file title:(NSString *)title{
    NSMutableDictionary *fxMenuLightDataDic;
    if ([[NSFileManager defaultManager] fileExistsAtPath:file])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:file];
    }
    
    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:title];
    return [AnimationParameter createFromArray:lightDataArray];
//    return [[AnimationParameter alloc] initFromFile:file title:title];
}

+ (id)testCreate{
    NSString* file = [FilePath fxForStyleFilePath];
//    NSString* title = [titleArray objectAtIndex:0];

    return [AnimationParameter createFromFile:file title:@"Strobe"];
}

- (id)initFromArray:(NSArray*)array{
    self = [super init];
    
    NSArray *lightDataArray = array;
    if (nil != lightDataArray) {
//        assert(lightDataArray.count == 20);
        
        
        self.lFromR = [[lightDataArray objectAtIndex:0] intValue];    //L灯 R  (From)
        self.lFromG = [[lightDataArray objectAtIndex:1] intValue];    //L灯 G  (From)
        self.lFromB = [[lightDataArray objectAtIndex:2] intValue];    //L灯 B  (From)
        
        self.lToR = [[lightDataArray objectAtIndex:3] intValue];    //L灯 R  (To)
        self.lToG = [[lightDataArray objectAtIndex:4] intValue];    //L灯 G  (To)
        self.lToB = [[lightDataArray objectAtIndex:5] intValue];    //L灯 B  (To)
        
        
        self.rFromR= [[lightDataArray objectAtIndex:6] intValue];    //R灯 R  (From)
        self.rFromG= [[lightDataArray objectAtIndex:7] intValue];    //R灯 G  (From)
        self.rFromB= [[lightDataArray objectAtIndex:8] intValue];    //R灯 B  (From)
        
        self.rToR = [[lightDataArray objectAtIndex:9] intValue];    //R灯 R  (To)
        self.rToG = [[lightDataArray objectAtIndex:10] intValue];    //R灯 G  (To)
        self.rToB = [[lightDataArray objectAtIndex:11] intValue];    //R灯 B  (To)
        
        /*
        self.lFromR = [self valueInPos:0 ofArray:lightDataArray];
        self.lFromG = [self valueInPos:1 ofArray:lightDataArray];
        self.lFromB = [self valueInPos:2 ofArray:lightDataArray];
        
        self.lToR = [self valueInPos:3 ofArray:lightDataArray];
        self.lToG = [self valueInPos:4 ofArray:lightDataArray];
        self.lToB = [self valueInPos:5 ofArray:lightDataArray];
        
        
        self.rFromR= [self valueInPos:6 ofArray:lightDataArray];
        self.rFromG= [self valueInPos:7 ofArray:lightDataArray];
        self.rFromB= [self valueInPos:8 ofArray:lightDataArray];
        
        self.rToR = [self valueInPos:9 ofArray:lightDataArray];
        self.rToG = [self valueInPos:10 ofArray:lightDataArray];
        self.rToB = [self valueInPos:11 ofArray:lightDataArray];
         */
        
        self.durationTime1 = [[lightDataArray objectAtIndex:12] intValue];    //duration
        self.durationTime2 = [[lightDataArray objectAtIndex:13] intValue];    //duration
        
        self.isBlackout = [[lightDataArray objectAtIndex:14] intValue];
        self.isRandom = [[lightDataArray objectAtIndex:15] intValue];
        self.hold = [[lightDataArray objectAtIndex:16] intValue];
        self.pause = [[lightDataArray objectAtIndex:17] intValue];
        
        self.isVibrate = [[lightDataArray objectAtIndex:18] intValue];
        self.loop = [[lightDataArray objectAtIndex:19] intValue];
        
    }
    return self;
}

- (int) valueInPos:(NSInteger)pos ofArray:(NSArray*)array{
    int value = [[array objectAtIndex:pos] intValue];
    if (value > 255) {
        return 0;
    }
    return value;
}

@end
