//
//  HelloWorldLayer.h
//  Embrace+
//
//  Created by hum on 9/7/13.
//  Copyright hum 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "ViewController.h"

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"


#define HEIGHT_Y 380

#define LOW_Y 220
#define LEFT_X 60
#define RIGHT_X 260

static const ccColor3B emWHITE = {0xff,0xff,0xff};
static const ccColor3B emSilver = {0x99,0x99,0x99};
static const ccColor3B emPink_light = {0xff,0x99,0xff};
static const ccColor3B emPink = {0xff,0,0xff};

static const ccColor3B emPurple = {0x99,0,0xff};
static const ccColor3B emPink_red = {0xff,0,0xff};
static const ccColor3B emRed = {0xff,0,0};
static const ccColor3B emRed_Blood = {0xff,0x33,0x33};

static const ccColor3B emYellow = {0xff,0xff,0};
static const ccColor3B emGreen_Acid = {0x99,0xff,0};
static const ccColor3B emGreen = {0,0xff,0};
static const ccColor3B emOrange = {0xff,0x99,0};

static const ccColor3B emGold = {0xff,0xcc,0x33};
static const ccColor3B emBlue_Sky= {0xcc,0xff,0xff};
static const ccColor3B emBlue_Light = {0x33,0x99,0xff};
static const ccColor3B emBlue = {0,0,0xff};

enum effect
{
    AfterWork = 0,
    Atomic,
    BioHazard,
    Bloodrush,
    Chat ,
    Discreet,
    Electrifying,
    Fabulous,
    Fugitive,
    Heartbeat,
    Holy,
    Meeting,
    Nerdcore,
    NightFever,
    Nirvana,
    Outdoor,
    Prancing,
    Psychedelic,
    Punk,
    Rasta,
    Strobe,
    SweetLife,
    Toxic,
    Workout
};

// HelloWorldLayer
@interface HelloWorldLayer1 : CCLayerColor
{
    CCSprite *embl;
    CCSprite *embr;
    
    CCSprite *pBackground;
    
    float delay_left;
    float delay_right;
    
    ccColor3B left_begin;
    ccColor3B left_end;
    ccColor3B right_begin;
    ccColor3B right_end;
    
    bool isReversed;
    bool isRandom;
    
    bool isFade;
    bool isTint;
    
    float duration;
    
    ccColor3B left_cur;
    ccColor3B right_cur;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
 - (float)color_change:(float)colorb colorend:(float)colore colorcur:(float)cur_color;
@end 