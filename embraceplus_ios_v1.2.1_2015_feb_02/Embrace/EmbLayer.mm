//
//  HelloWorldLayer.m
//  Embrace+
//
//  Created by hum on 9/7/13.
//  Copyright hum 2013. All rights reserved.
//


// Import the interfaces
#import "EmbLayer.h"

// Needed to obtain the Navigation Controller
//#import "AppDelegate.h"
#import "ViewController.h"
#import "EmbColor.h"

#pragma mark - HelloWorldLayer

static CCSprite *embl;
static CCSprite *embr;
static CCSprite *emb;

static CCSprite *bigEmbl;
static CCSprite *bigEmbr;
static CCSprite *bigEmb;

//static CCSprite *pBackground;
static ccColor3B left_begin;
static ccColor3B left_end;
static ccColor3B right_begin;
static ccColor3B right_end;
static bool isRandom;
static int isLFade;  //0 no fade; 1 fade in; 2 fade out
static bool isLTint;
static int isRFade;
static bool isRTint;
static float duration1;
static float duration2;
static int pauseTime;
static int holdTime;

static bool isSetAnimation;

// HelloWorldLayer implementation
@implementation EmbLayer
@synthesize pBackground;
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene:(int) scene_Type;
{
	// 'scene' is an autorelease object.
    
    sceneType = scene_Type;
	CCScene *scene = [CCScene node];
   // scene
	
	// 'layer' is an autorelease object.
	EmbLayer *layer = [EmbLayer node];
	// add layer as a child to scene
    [scene removeAllChildrenWithCleanup:YES];
	[scene addChild: layer];
    
	callback1Status = 0;
    callback2Status = 0;
	// return the scene
	return scene;
}
//-(void)draw
//{
//
//}
// on "init" you need to initialize your instance
-(id) init
{
    //pTexture = nil;
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
    
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        NSLog(@"X= %f,Y= %f",screenSize.height,screenSize.width);
        
        CCTexture2D *pTexture = [[CCTextureCache sharedTextureCache] addCGImage:appDelegate.backgroundImageTemp.CGImage forKey:nil];
        
        pBackground = [CCSprite spriteWithTexture:pTexture];
        pBackground = [CCSprite spriteWithCGImage:appDelegate.backgroundImage.CGImage key:nil];
        
        [self addChild:pBackground];
        [pBackground setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];

        emb=[CCSprite spriteWithFile:@"Embrace_3D.png"];
        [self addChild:emb];
        emb.position=ccp(screenSize.width/2,22);
        
        
        embl=[CCSprite spriteWithFile:@"Embrace_3D-left.png"];
        [self addChild:embl];
        embl.position=ccp(screenSize.width/2-75,22);
    
        embr=[CCSprite spriteWithFile:@"Embrace_3D-right.png"];
        [self addChild:embr];
        embr.position=ccp(screenSize.width/2+75,22);
  
        bigEmb=[CCSprite spriteWithFile:@"chooseStyleEmbrace.png"];
        [self addChild:bigEmb];

        bigEmbl=[CCSprite spriteWithFile:@"Embrace_3Dwhole-lightL.png"];
        [self addChild:bigEmbl];
       
        
        bigEmbr=[CCSprite spriteWithFile:@"Embrace_3Dwhole-lightR.png"];
        [self addChild:bigEmbr];
        
    
        if(sceneType == 0)
        {
            [emb setVisible:YES];
            [embl setVisible:YES];
            [embr setVisible:YES];
            
            [bigEmb setVisible:NO];
            [bigEmbl setVisible:NO];
            [bigEmbr setVisible:NO];
        }
        else
        {
            [emb setVisible:NO];
            [embl setVisible:NO];
            [embr setVisible:NO];
            
            [bigEmb setVisible:YES];
            [bigEmbl setVisible:YES];
            [bigEmbr setVisible:YES];
        }
            
        if (iPhone5) {
            NSLog(@"iphone 5");
            bigEmb.position=ccp(screenSize.width/2,72);//about 115
            bigEmbl.position=ccp(screenSize.width/2-74.9,71);
            bigEmbr.position=ccp(screenSize.width/2+74.9,72);
            
            emb.position=ccp(screenSize.width/2,22);
            embl.position=ccp(screenSize.width/2-75,22);
            embr.position=ccp(screenSize.width/2+75,22);
        }
        else
        {
            NSLog(@"not iphone 5");
            emb.position=ccp(screenSize.width/2,72);//about 115
            bigEmb.position=ccp(screenSize.width/2,72);//about 115
            bigEmbl.position=ccp(screenSize.width/2-74.9,71);
            bigEmbr.position=ccp(screenSize.width/2+74.9,72);
            
            emb.position=ccp(screenSize.width/2,22);
            embl.position=ccp(screenSize.width/2-75,22);
            embr.position=ccp(screenSize.width/2+75,22);
            
        }

        
        emb.zOrder = 2;
        embl.zOrder = 2;
        embr.zOrder = 2;

        bigEmb.zOrder = 2;
        bigEmbl.zOrder = 2;
        bigEmbr.zOrder = 2;
	}
    
    if(isSetAnimation == true)
    {
        isSetAnimation = false;
        [EmbLayer startAnimation];
    }
    
	return self;
}


+ (void)startAnimation{

    id action1;
    id action1Back;
    id action2;
    id action2Back;
    id ac1;
    id ac2;
    
    if(sceneType == 0)
    {
        [bigEmbl stopAllActions];
        [bigEmbr stopAllActions];
        
        [embl stopAllActions];
        [embr stopAllActions];
    
        [embl setOpacity:255];
        [embr setOpacity:255];
    }
    else
    {
        [embl stopAllActions];
        [embr stopAllActions];
        
        [bigEmbl stopAllActions];
        [bigEmbr stopAllActions];
    
        [bigEmbl setOpacity:255];
        [bigEmbr setOpacity:255];
    }
   
    if(isRandom)
    {
        int random;
        random = arc4random()%256;
        left_begin.r =arc4random()%256;
        left_begin.g =arc4random()%256;
        left_begin.b =arc4random()%256;
        
        left_end.r =arc4random()%256;
        left_end.g =arc4random()%256;
        left_end.b =arc4random()%256;
        
        right_begin.r =arc4random()%256;
        right_begin.g =arc4random()%256;
        right_begin.b =arc4random()%256;
        
        right_end.r =arc4random()%256;
        right_end.g =arc4random()%256;
        right_end.b =arc4random()%256;
        NSLog(@"random1 = %d",random);
        
        random = arc4random()%256;
        NSLog(@"random2 = %d",random);
        
    }
    //set start color
    
    if(isLFade == 1)
    {
        if(sceneType == 0)
        {
            [embl setColor:left_end];
        }
        else
        {
            [bigEmbl setColor:left_end];
        }
        action1 = [CCFadeIn actionWithDuration:duration1];
        action1Back = [CCFadeOut actionWithDuration:duration2];
       
    }else if(isLFade == 2)
    {
        if(sceneType == 0)
        {
            [embl setColor:left_begin];
        }else
        {
            [bigEmbl setColor:left_begin];
        }
        action1 = [CCFadeOut actionWithDuration:duration2];
        action1Back = [CCFadeIn actionWithDuration:duration1];
    }
    
    if(isRFade == 1)
    {
        if(sceneType == 0)
        {
            [embr setColor:right_end];
        }
        else
        {
            [bigEmbr setColor:right_end];
        }
        action2 = [CCFadeIn actionWithDuration:duration1];
        action2Back = [CCFadeOut actionWithDuration:duration2];
        
        
    }else if(isRFade == 2)
    {
        if(sceneType == 0)
        {
            [embr setColor:right_begin];
        }
        else
        {
            [bigEmbr setColor:right_begin];
        }
        action2 = [CCFadeOut actionWithDuration:duration2];
        action2Back = [CCFadeIn actionWithDuration:duration1];
    }

    
    if(isLTint)
    {
        if(sceneType == 0)
        {
            [embl setColor:left_begin];
        }
        else
        {
            [bigEmbl setColor:left_begin];
        }
        action1 = [CCTintTo actionWithDuration:duration1 red:left_end.r green:left_end.g blue:left_end.b];
        action1Back =[CCTintTo actionWithDuration:duration2 red:left_begin.r green:left_begin.g blue:left_begin.b];
    }

    
    if(isRTint)
    {
        if(sceneType == 0)
        {
            [embr setColor:right_begin];
        }
        else
        {
            [bigEmbr setColor:right_begin];
        }
        action2 = [CCTintTo actionWithDuration:duration1 red:right_end.r green:right_end.g blue:right_end.b];
        action2Back =[CCTintTo actionWithDuration:duration2 red:right_begin.r green:right_begin.g blue:right_begin.b];

    }
    
    if(isRandom)
    {
        id acf1 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack1)];
        id acf2 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack2)];
        
        ac1 = [CCRepeat actionWithAction:[CCSequence actions: action1,[CCDelayTime actionWithDuration:holdTime/1000.0],[CCDelayTime actionWithDuration:pauseTime/1000.0],acf1,nil] times:1];
        ac2 = [CCRepeat actionWithAction:[CCSequence actions: action2,[CCDelayTime actionWithDuration:holdTime/1000.0],[CCDelayTime actionWithDuration:pauseTime/1000.0],acf2, nil] times:1];
    }
    else
    {
        ac1 = [CCRepeatForever actionWithAction:[CCSequence actions: action1,[CCDelayTime actionWithDuration:holdTime/1000.0], action1Back, [CCDelayTime actionWithDuration:pauseTime/1000.0],nil]];
        ac2 = [CCRepeatForever actionWithAction:[CCSequence actions: action2,[CCDelayTime actionWithDuration:holdTime/1000.0],action2Back, [CCDelayTime actionWithDuration:pauseTime/1000.0],nil]];
    }
    
    if(sceneType == 0)
    {
        [embl runAction: ac1];
        [embr runAction: ac2];
    }
    else
    {
        [bigEmbl runAction: ac1];
        [bigEmbr runAction: ac2];
    }
    

}


+ (void) CallBack1 {
    id action1;
    id ac1;

    if(sceneType == 0)
    {
        [embl setColor:left_end];
        [embl setOpacity:255];
    }
    else
    {
        [bigEmbl setColor:left_end];
        [bigEmbl setOpacity:255];
    }

    
    left_end.r =arc4random()%256;
    left_end.g =arc4random()%256;
    left_end.b =arc4random()%256;

    if(callback1Status == 0)
    {
        action1 = [CCTintTo actionWithDuration:duration2 red:left_end.r green:left_end.g blue:left_end.b];
        callback1Status = 1;
    }
    else
    {
        action1 = [CCTintTo actionWithDuration:duration1 red:left_end.r green:left_end.g blue:left_end.b];
        callback1Status = 0;
    }
    
    id acf1 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack1)];

    ac1 = [CCRepeat actionWithAction:[CCSequence actions: action1,[CCDelayTime actionWithDuration:holdTime/1000.0],acf1,[CCDelayTime actionWithDuration:pauseTime/1000.0],nil] times:1];
    
    if(sceneType == 0)
    {
        [embl runAction: ac1];
    }
    else
    {
        [bigEmbl runAction: ac1];
    }
    
}
+ (void) CallBack2 {
    id action2;
    id ac2;

    if(sceneType == 0)
    {
        [embr setColor:right_end];
        [embr setOpacity:255];
    }
    else
    {
        [bigEmbr setColor:right_end];
        [bigEmbr setOpacity:255];
    }

    
    right_end.r =arc4random()%256;
    right_end.g =arc4random()%256;
    right_end.b =arc4random()%256;
    
    
    if(callback2Status == 0)
    {
        action2 = [CCTintTo actionWithDuration:duration1 red:right_end.r green:right_end.g blue:right_end.b];
        callback2Status = 1;
    }
    else
    {
        action2 = [CCTintTo actionWithDuration:duration2 red:right_end.r green:right_end.g blue:right_end.b];
        callback2Status = 0;
    }

    id acf2 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack2)];
    
    ac2 = [CCRepeat actionWithAction:[CCSequence actions: action2,[CCDelayTime actionWithDuration:holdTime/1000.0],acf2,[CCDelayTime actionWithDuration:pauseTime/1000.0],nil] times:1];
    
    if(sceneType == 0)
    {
        [embr runAction: ac2];
    }
    else
    {
        [bigEmbr runAction: ac2];
    }

}

//frome/to L: R,G,B,    frome/to R: R,G,B  duration1 dutation2  blackout random hold pause
+ (void)SelectEffect:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause
{
    
    left_begin.r = lFromR;
    left_begin.g = lFromG;
    left_begin.b = lFromB;
    
    left_end.r = lToR;
    left_end.g = lToG;
    left_end.b = lToB;

    right_begin.r = rFromR;
    right_begin.g = rFromG;
    right_begin.b = rFromB;

    right_end.r = rToR;
    right_end.g = rToG;
    right_end.b = rToB;

    isRandom = random;
    
    if(lFromR == 256)
    {
        isLFade = 1;
        isLTint = false;
    }
    else if(lToR == 256)
    {
        isLFade = 2;
        isLTint = false;
    }
    else
    {
        isLFade = false;
        isLTint = true;
    }
    
    if(rFromR == 256)
    {
        isRFade = 1;
        isRTint = false;
    }
    else if(rToR == 256)
    {
        isRFade = 2;
        isRTint = false;
    }
    else
    {
        isRFade = false;
        isRTint = true;
    }

    
    duration1 = (float)durationMil1/1000.0;
    duration2 = (float)durationMil2/1000.0;
    
    pauseTime = pause;
    holdTime = hold;
    
    [EmbLayer startAnimation];
    
}


+ (void)SetEffect:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause isSetAnimation:(bool)isSetAnimation1
{
    
    left_begin.r = lFromR;
    left_begin.g = lFromG;
    left_begin.b = lFromB;
    
    left_end.r = lToR;
    left_end.g = lToG;
    left_end.b = lToB;
    
    right_begin.r = rFromR;
    right_begin.g = rFromG;
    right_begin.b = rFromB;
    
    right_end.r = rToR;
    right_end.g = rToG;
    right_end.b = rToB;
    
    isRandom = random;
    
    
    if(lFromR == 256)
    {
        isLFade = 1;
        isLTint = false;
    }
    else if(lToR == 256)
    {
        isLFade = 2;
        isLTint = false;
    }
    else
    {
        isLFade = false;
        isLTint = true;
    }
    
    if(rFromR == 256)
    {
        isRFade = 1;
        isRTint = false;
    }
    else if(rToR == 256)
    {
        isRFade = 2;
        isRTint = false;
    }
    else
    {
        isRFade = 0;
        isRTint = true;
    }
    
    if(isRandom)
    {
        isRTint = true;
        isLTint = true;
    }
    
    duration1 = (float)durationMil1/1000;
    duration2 = (float)durationMil2/1000;
    
    pauseTime = pause;
    holdTime = hold;
    
    isSetAnimation = isSetAnimation1;
    
}


+ (void)switchPicture:(int)type
{
    
    sceneType = type;
    if(sceneType == 0)
    {
        [emb setVisible:YES];
        [embl setVisible:YES];
        [embr setVisible:YES];
        
        [bigEmb setVisible:NO];
        [bigEmbl setVisible:NO];
        [bigEmbr setVisible:NO];
        
        [EmbLayer startAnimation];
    
    }
    else if(sceneType == 1)
    {
        
        [emb setVisible:NO];
        [embl setVisible:NO];
        [embr setVisible:NO];
        
        [bigEmb setVisible:YES];
        [bigEmbl setVisible:YES];
        [bigEmbr setVisible:YES];
        
        [EmbLayer startAnimation];
    }

    
}

//// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
    NSLog(@"Helloworld dealloc");
	[super dealloc];
//    [pBackground release];
//    [appDelegate release];
    
//    [embr release];
//    [emb release];
}

- (void)SetBackground
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    NSLog(@"SetBackground X= %f,Y= %f",screenSize.height,screenSize.width);
    
    CCTexture2D *pTexture = [[CCTextureCache sharedTextureCache] addCGImage:appDelegate.backgroundImageTemp.CGImage forKey:nil];
    
	[pBackground setTexture:pTexture];
}

@end
