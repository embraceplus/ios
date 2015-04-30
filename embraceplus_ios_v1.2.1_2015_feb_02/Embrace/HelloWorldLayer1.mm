//
//  HelloWorldLayer.m
//  Embrace+
//
//  Created by hum on 9/7/13.
//  Copyright hum 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer1.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "ViewController.h"

#pragma mark - HelloWorldLayer1

// HelloWorldLayer implementation
@implementation HelloWorldLayer1

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
   // scene
	
	// 'layer' is an autorelease object.
	HelloWorldLayer1 *layer = [HelloWorldLayer1 node];
//    layer.opacity = 
    
	//layer.opacity = 1.0f;
	// add layer as a child to scene
	[scene addChild: layer];
	
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
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        //if( (self=[super initWithColor:ccc4(255.0,255.0,0.0,0.0)]) ) {
   
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        NSLog(@"X= %f,Y= %f",screenSize.height,screenSize.width);
        
        
        pBackground = [CCSprite spriteWithFile:@"bg_Athlete.png"];
        [self addChild:pBackground];
        [pBackground setPosition:ccp(screenSize.width*0.5, screenSize.height*0.5)];
//
//        
//        
        CCSprite *emb=[CCSprite spriteWithFile:@"Embrace_3D.png"];
        [self addChild:emb];
         emb.position=ccp(screenSize.width/2,30);
        
        
//        embl=[CCSprite spriteWithFile:@"Embrace_3D-left.png"];
//        [self addChild:embl]; 
//        embl.position=ccp(80,69);
//        
//        embr=[CCSprite spriteWithFile:@"Embrace_3D-right.png"];
//        [self addChild:embr]; 
//        embr.position=ccp(240,69);
//
//        //不是纯覆盖,而是混合
//        //颜色的图层是在sprite下面，如果透明度是0（全透），就看不见；255（不透），就完全看见setcolor设置的颜色?
//        //透明度默认是255,不透
//        //[embl setOpacity:0];
//        //[embr setOpacity:0];
//    
//        NSLog(@"hello layer!!!!!!!!!!!");
//        
//        [self SelectEffect:0];
        

	}
	return self;
}


- (void)btnStrat:(id)sender {
    //[self schedule:@selector(fade:) interval:delay_left];
    id action1;
    id action1Back;
    id action2;
    id action2Back;
    id ac1;
    id ac2;
    
    [embl stopAllActions];
    [embr stopAllActions];
    
    [embl setOpacity:255];
    [embr setOpacity:255];
    
    if(isReversed)
    {
        if(isFade)
        {
            right_begin = left_begin;
        }
        else
        {
            right_end = left_begin;
            right_begin = left_end;
        }
    }
    
    if(isRandom)
    {
        int random;
        //random_float=CCRANDOM_0_1()*5;
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
    [embl setColor:left_begin];
    [embr setColor:right_begin];
    
    if(isFade)
    {
        action1 = [CCFadeIn actionWithDuration:duration];
        action1Back = [action1 reverse];
       
        
        if(isReversed)
        {
            action2 = [CCFadeOut actionWithDuration:duration];
            action2Back = [action2 reverse];
        }
        else
        {
            action2 = [CCFadeIn actionWithDuration:duration];
            action2Back = [action2 reverse];

        }
        
        //ac1 = [CCRepeatForever actionWithAction:[CCSequence actions: action1, action1Back, nil]];
        //ac2 = [CCRepeatForever actionWithAction:[CCSequence actions: action2, action2Back, nil]];
        
    }

    if(isTint)
    {
        
        NSLog(@"Tint");
        action1 = [CCTintTo actionWithDuration:duration red:left_end.r green:left_end.g blue:left_end.b];
        action1Back =[CCTintTo actionWithDuration:duration red:left_begin.r green:left_begin.g blue:left_begin.b];

        action2 = [CCTintTo actionWithDuration:duration red:right_end.r green:right_end.g blue:right_end.b];
        action2Back =[CCTintTo actionWithDuration:duration red:right_begin.r green:right_begin.g blue:right_begin.b];

    }
//

    
    
    //多个 spirte 不能共用 相同的 action，要单独创建参数相同的action 
//    action1 = [CCTintTo actionWithDuration:2 red:255 green:255 blue:0];//yellow
//    action1Back = [CCTintTo actionWithDuration:2 red:255 green:0x99 blue:0];;//[action1 reverse];
//    //CCTintTo 不能reverse
//    //CCTintBy 测试发现By是加上颜色，to是变换到相应颜色，所以应该用To
//    action2 = [CCTintTo actionWithDuration:2 red:255 green:255 blue:0];//yellow
//    action2Back = [CCTintTo actionWithDuration:2 red:255 green:0x99 blue:0];;//[action1 reverse];
    
    if(isRandom)
    {
        id acf1 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack1)];
        id acf2 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack2)];
        ac1 = [CCRepeat actionWithAction:[CCSequence actions: action1, action1Back,acf1,nil] times:1];
        ac2 = [CCRepeat actionWithAction:[CCSequence actions: action2, action2Back,acf2, nil] times:1];
    }
    else
    {
        ac1 = [CCRepeatForever actionWithAction:[CCSequence actions: action1, action1Back, nil]];
        ac2 = [CCRepeatForever actionWithAction:[CCSequence actions: action2, action2Back, nil]];
    }

    
    [embl runAction: ac1];
    [embr runAction: ac2];
}


- (void) CallBack1 {
    id action1;
    id action1Back;
    id ac1;


    
    NSLog(@"CallBack1");
    left_begin.r =arc4random()%256;
    left_begin.g =arc4random()%256;
    left_begin.b =arc4random()%256;
    
    left_end.r =arc4random()%256;
    left_end.g =arc4random()%256;
    left_end.b =arc4random()%256;
    
    [embl setColor:left_begin];
    [embl setOpacity:255];

    action1 = [CCTintTo actionWithDuration:duration red:left_end.r green:left_end.g blue:left_end.b];
    action1Back =[CCTintTo actionWithDuration:duration red:left_begin.r green:left_begin.g blue:left_begin.b];
    
    id acf1 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack1)];

    ac1 = [CCRepeat actionWithAction:[CCSequence actions: action1, action1Back,acf1,nil] times:1];
    
    [embl runAction: ac1];
    
}
- (void) CallBack2 {
    id action2;
    id action2Back;
    id ac2;

    
    NSLog(@"CallBack2");
    right_begin.r =arc4random()%256;
    right_begin.g =arc4random()%256;
    right_begin.b =arc4random()%256;
    
    right_end.r =arc4random()%256;
    right_end.g =arc4random()%256;
    right_end.b =arc4random()%256;
    
    [embr setColor:right_begin];
    [embr setOpacity:255];
    
    action2 = [CCTintTo actionWithDuration:duration red:right_end.r green:right_end.g blue:right_end.b];
    action2Back =[CCTintTo actionWithDuration:duration red:right_begin.r green:right_begin.g blue:right_begin.b];
    
    id acf2 = [CCCallFunc actionWithTarget:self selector:@selector(CallBack2)];
    
    ac2 = [CCRepeat actionWithAction:[CCSequence actions: action2, action2Back,acf2,nil] times:1];
    
    [embl runAction: ac2];

    
}

- (void)SelectEffect:(int) position
{
    NSLog(@"select effect %d",position);
    
    switch (position) {
            
        case AfterWork:
            
            left_begin=emBlue;
            duration = 1.5;
            isRandom = false;
            isReversed = true;
            isFade = true;
            isTint = false;
            
            delay_left=0.1;
            delay_right=0.1;
            break;

        case Atomic:
            
            left_begin=emOrange;
            left_end=emYellow;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 2.0;
            
            delay_left=0.1;
            delay_right=0.1;
            break;
        case BioHazard:
            left_begin=emGreen_Acid;
            right_begin=emGreen_Acid;
            duration = 0.5;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;
            
            
            delay_left=0.1;
            delay_right=0.1;
            break;
        case Bloodrush:
            
            left_begin=emRed;
            left_end=emRed_Blood;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 0.2;
            
            
            delay_left=0.1;
            delay_right=0.1;
            break;
        case Chat:
            left_begin=emYellow;
            right_begin=emYellow;
            duration = 0.6;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;

            
            delay_left=0.1;
            delay_right=0.1;
            break;
        case Discreet:
            left_begin=emBlue_Sky;
            right_begin=emBlue_Sky;
            duration = 1.0;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;
            
            
            delay_left=0.1;
            delay_right=0.1;
            break;
        case Electrifying:
            
            left_begin=emBlue_Sky;
            left_end=emBlue_Light;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 0.1;
            
            delay_left=0.1;
            delay_right=0.1;
            break;
            
        case Fabulous:
            left_begin=emGold;
            left_end=emPink_light;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 1.0;
            
            delay_left=0.1;
            delay_right=0.1;
            break;

            
        case Fugitive:
            
            left_begin=emRed;
            left_end=emBlue;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 0.3;
            
            break;
        case Heartbeat:
            left_begin=emRed_Blood;
            right_begin=emRed_Blood;
            duration = 0.4;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;
            
            
            delay_left=0.1;
            delay_right=0.1;
            break;

        case Holy:
            left_begin=emBlue_Light;
            left_end=emWHITE;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 2.0;
            
            break;

        case Meeting:
            left_begin=emBlue;
            right_begin=emBlue;
            duration = 2.0;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;
            
            
            delay_left=0.1;
            delay_right=0.1;
            break;

        case Nerdcore:
            left_begin=emPurple;
            right_begin = emRed;
            duration = 0.1;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;

            break;
        case NightFever:
            left_begin=emPink;
            right_begin = emPurple;
            duration = 0.5;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;
            
            break;
        case Nirvana:
            left_begin=emBlue_Light;
            duration = 1.5;
            isRandom = false;
            isReversed = true;
            isFade = true;
            isTint = false;
            break;
            
        case Outdoor:
            left_begin=emGreen;
            left_end=emBlue_Light;
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 1.0;
            break;
            
        case Prancing:
            duration = 0.5;
            isRandom = true;
            isReversed = false;
            isFade = false;
            isTint = true;
            break;
            
        case Psychedelic:
            duration = 2.0;
            isRandom = true;
            isReversed = false;
            isFade = false;
            isTint = true;
            break;
            
        case Punk:
            left_begin=emOrange;
            left_end=emPurple;
            right_begin=emRed;
            right_end=emBlue_Light;
            
            isRandom = false;
            isReversed = false;
            isFade = false;
            isTint = true;
            duration = 0.2;
            break;

        case Rasta:
            left_begin=emRed;
            left_end=emGreen;
            right_begin=emYellow;
            right_end=emRed;
            
            isRandom = false;
            isReversed = false;
            isFade = false;
            isTint = true;
            duration = 1.5;
            break;
            
        case Strobe:
            left_begin=emWHITE;
            right_begin = emWHITE;
            duration = 0.1;
            isRandom = false;
            isReversed = false;
            isFade = true;
            isTint = false;
            
            break;
        case SweetLife:
            left_begin=emPink;
            left_end=emYellow;
            
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 1.0;
            break;

        case Toxic:
            left_begin=emGreen;
            left_end=emYellow;
            
            isRandom = false;
            isReversed = true;
            isFade = false;
            isTint = true;
            duration = 1.5;
            break;

            
        case Workout:
            left_begin=emBlue;
            left_end=emPurple;
            right_begin=emOrange;
            right_end=emRed;
            
            isRandom = false;
            isReversed = false;
            isFade = false;
            isTint = true;
            duration = 0.8;
            break;

            
        default:
            break;
    }
    
    [self btnStrat:nil];

}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	//[super dealloc];
}


@end
