//
//  PresetEffect.h
//  Embrace ios7
//
//  Created by 张达棣 on 14-2-15.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#ifndef Embrace_ios7_PresetEffect_h
#define Embrace_ios7_PresetEffect_h

static const ccColor3B emColor1 = {0xff,0xff,0xff};

static const ccColor3B emColor3 = {0x0,0x0,0xff};
static const ccColor3B emColor4 = {0x0,0xff,0x0};

static const ccColor3B emColor5 = {0x33,0x99,0xff};
static const ccColor3B emColor6 = {0x99,0xff,0x00};

static const ccColor3B emColor7 = {0xcc,0xff,0xff};
static const ccColor3B emColor8 = {0xff,0xff,0x0};

static const ccColor3B emColor9 = {0xff,0x00,0x00};
static const ccColor3B emColor10 = {0xff,0x99,0x00};

static const ccColor3B emColor11 = {0xff,0x33,0x33};
static const ccColor3B emColor12 = {0xff,0xcc,0x33};

static const ccColor3B emColor13 = {0x99,0x00,0xff};
static const ccColor3B emColor14 = {0xff,0x99,0xff};

static const ccColor3B emColor15 = {0xff,0x0,0xff};
static const ccColor3B emColor16 = {0xff,0x99,0xff};


typedef struct _presetPattern
{
    int durationTime1;
    int hold;
    int durationTime2;
    int pause;
    int loop;
    int isBlackout;
    int isReversed;

} presetPattern;

//durationTime1,hold,durationTime2,pause,loop,isBlackout,isReversed;
static const presetPattern emPatternLongBeat = {0,1000,0,1000,1,1,0};
static const presetPattern emPatternLongBeat2 = {0,1000,0,1000,1,1,0};
static const presetPattern emPatternShortBeat = {0,500,0,100,1,1,0};
static const presetPattern emPatternLighting = {100,0,0,0,30,30,1};
static const presetPattern emPatternFlicker = {300,400,300,1000,2,0,0};
//static const presetPattern emPatternFlicker = {300,4000,300,4000,2,0,1};//for test
static const presetPattern emPatternOscillate = {100,200,100,200,5,1,0};
static const presetPattern emPatternTwinkle = {300,300,100,0,3,1,0};
static const presetPattern emPatternSirens = {300,400,300,0,3,0,1};
static const presetPattern emPatternBomb = {1500,500,0,0,1,1,0};
static const presetPattern emPatternPulse = {400,0,400,0,3,1,0};
static const presetPattern emPatternShimmering = {1000,0,1000,0,3,1,0};
static const presetPattern emPatternTreeBeat = {0,600,0,400,3,1,0};
static const presetPattern emPatternShine = {1000,2000,1000,0,1,1,0};

#endif
