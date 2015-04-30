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
#import "AppDelegate.h"

#define HEIGHT_Y 380

#define LOW_Y 220
#define LEFT_X 60
#define RIGHT_X 260


static int sceneType;
static  int callback1Status;
static  int callback2Status;
//enum effect
//{
//    AfterWork = 0,
//    Atomic,
//    BioHazard,
//    Bloodrush,
//    Chat ,
//    Discreet,
//    Electrifying,
//    Fabulous,
//    Fugitive,
//    Heartbeat,
//    Holy,
//    Meeting,
//    Nerdcore,
//    NightFever,
//    Nirvana,
//    Outdoor,
//    Prancing,
//    Psychedelic,
//    Punk,
//    Rasta,
//    Strobe,
//    SweetLife,
//    Toxic,
//    Workout
//};

// HelloWorldLayer
@interface EmbLayer : CCLayerColor
{
    
    float delay_left;
    float delay_right;
    
    bool isReversed;

    AppDelegate *appDelegate;
//    CCTexture2D *pTexture;
//    
//    CCTexture2D *pTextureTemp;
    
}

@property(nonatomic,retain) CCSprite *pBackground;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene:(int) sceneType;


+ (void)SelectEffect:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause;

+ (void)SetEffect:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause isSetAnimation:(bool)isSetAnimation;

+ (void)setHide:(BOOL)isHide;
+ (void)switchPicture:(int)sceneType;
@end 