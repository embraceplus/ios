//
//  AnimationParameter.h
//  EmbracePlus ios7
//
//  Created by 赵雅琦 on 14-12-1.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationParameter : NSObject

@property(assign) int lFromR;
@property(assign) int lFromG;
@property(assign) int lFromB;

@property(assign) int lToR;
@property(assign) int lToG;
@property(assign) int lToB;

@property(assign) int rFromR;
@property(assign) int rFromG;
@property(assign) int rFromB;

@property(assign) int rToR;
@property(assign) int rToG;
@property(assign) int rToB;

@property(assign) int durationTime1;
@property(assign) int durationTime2;
@property(assign) int isBlackout;
@property(assign) int isRandom;

@property(assign) int hold;
@property(assign) int pause;

@property(assign) int isVibrate;
@property(assign) int loop;

//- (void)initFromFile;
//- (id)initFromFile;
+ (id) create;
+ (id) createFromArray:(NSArray*)array;
+ (id) createFromFile:(NSString*)file title:(NSString*)title;

+ (id) testCreate;

//- (void) setLFromColor
//- (id)initFromFile:(NSString*)file title:(NSString*)title;

@end
