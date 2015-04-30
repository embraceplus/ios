//
//  EmulatorView.m
//  EmbracePlus ios7
//
//  Created by 赵雅琦 on 14-12-3.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "EmulatorView.h"
#import "Image.h"
//#import "Color.h"
#import "AppDelegate.h"

#define TIME_FACTOR 1000.0

@implementation EmulatorView{
   AnimationParameter* _animationParameter;
}

+ (EmulatorView *)emulator:(AnimationParameter *)animationParameter{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EmulatorView" owner:self options:nil];
    EmulatorView* view = [nibObjects lastObject];
    view.animationParameter = animationParameter;
    [view startAnimation];
    [view initView];
    return view;
}

+ (EmulatorView *)bigEmulator:(AnimationParameter *)animationParameter{
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"BigEmulatorView" owner:self options:nil];
    EmulatorView* view = [nibObjects lastObject];
    view.animationParameter = animationParameter;
    [view startAnimation];
    [view initView];
    return view;
}

- (void) initView{
    [self setBackgroundImage:[[AppDelegate instance] backgroundImage]];
}

- (void)startAnimation{
    running = YES;
    if (nil != self.animationParameter) {
        [self prepare];
        [self start];
    }
}

- (void) prepare{
    if (self.animationParameter.isRandom == 0) {
        UIColor* leftFrontColor = [UIColor colorWithRed:self.animationParameter.lFromR/255.0
                                                  green:self.animationParameter.lFromG/255.0
                                                   blue:self.animationParameter.lFromB/255.0
                                                  alpha:1];
        UIColor* leftBackColor = [UIColor colorWithRed:self.animationParameter.lToR/255.0
                                                 green:self.animationParameter.lToG/255.0
                                                  blue:self.animationParameter.lToB/255.0
                                                 alpha:1];
        leftFrontEndSprite.image = [leftFrontEndSprite.image tintWithColor:leftFrontColor];
        leftFrontEndSprite.alpha = 1.0;
        leftFrontEndSprite.hidden = 256 == self.animationParameter.lFromR;
        leftBackEndSprite.image = [leftBackEndSprite.image tintWithColor:leftBackColor];
        leftBackEndSprite.alpha = 0;
        leftBackEndSprite.hidden = 256 == self.animationParameter.lToR;
        
        UIColor* rightFrontColor = [UIColor colorWithRed:self.animationParameter.rFromR/255.0
                                                   green:self.animationParameter.rFromG/255.0
                                                    blue:self.animationParameter.rFromB/255.0
                                                   alpha:1];
        UIColor* rightBackColor = [UIColor colorWithRed:self.animationParameter.rToR/255.0
                                                  green:self.animationParameter.rToG/255.0
                                                   blue:self.animationParameter.rToB/255.0
                                                  alpha:1];
        rightFrontEndSprite.image = [rightFrontEndSprite.image tintWithColor:rightFrontColor];
        rightFrontEndSprite.alpha = 1.0;
        rightFrontEndSprite.hidden = 256 == self.animationParameter.rFromR;
        rightBackEndSprite.image = [rightBackEndSprite.image tintWithColor:rightBackColor];
        rightBackEndSprite.alpha = 0;
        rightBackEndSprite.hidden = 256 == self.animationParameter.rToR;
    }
}

- (void) initWithRandomColors{
    if (self.animationParameter.isRandom == 1) {
        UIColor* leftFrontColor = [self randomColor];
        UIColor* leftBackColor = [self randomColor];
        leftFrontEndSprite.image = [leftFrontEndSprite.image tintWithColor:leftFrontColor];
        leftBackEndSprite.image = [leftBackEndSprite.image tintWithColor:leftBackColor];
        
        UIColor* rightFrontColor = [self randomColor];
        UIColor* rightBackColor = [self randomColor];
        rightFrontEndSprite.image = [rightFrontEndSprite.image tintWithColor:rightFrontColor];
        rightBackEndSprite.image = [rightBackEndSprite.image tintWithColor:rightBackColor];
    }
}

- (UIColor*) randomColor{
    return [UIColor colorWithRed:(arc4random()%255)/255.0
                           green:(arc4random()%255)/255.0
                            blue:(arc4random()%255)/255.0
                           alpha:1.0];
}

- (void)showInView:(UIView *)view{
    self.frame = view.bounds;
    [view insertSubview:self atIndex:0];
}

- (void)stopRuning{
    running = NO;
}

- (void) start{
    if (!running) {
        return;
    }
    if (nil != self.animationParameter) {
        [self initWithRandomColors];
        leftFrontEndSprite.alpha = 1.0;
        leftBackEndSprite.alpha = 0.0;
        rightFrontEndSprite.alpha = 1.0;
        rightBackEndSprite.alpha = 0.0;
        [self fadeIn];
    }
}

- (void) fadeIn{
    if (!running) {
        return;
    }
    NSTimeInterval interval = self.animationParameter.durationTime1 /TIME_FACTOR;
    [UIView animateWithDuration:interval
                     animations:^{
                         leftFrontEndSprite.alpha = 0.0;
                         leftBackEndSprite.alpha = 1.0;
                         rightFrontEndSprite.alpha = 0.0;
                         rightBackEndSprite.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"fadeIn finished");
                         [self hold];
                     }];
}

- (void) hold{
    if (!running) {
        return;
    }
    NSTimeInterval interval = self.animationParameter.hold /TIME_FACTOR;
    if (0 == interval) {
        [self fadeOut];
    }
    else{
        [NSTimer scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(fadeOut)
                                       userInfo:nil
                                    repeats:NO];
    }
}

- (void) fadeOut{
    if (!running) {
        return;
    }
    NSTimeInterval interval = self.animationParameter.durationTime2 /TIME_FACTOR;
    if (0 == interval) {
        [self pause];
    }
    else{
        [UIView animateWithDuration:interval
                         animations:^{
                             leftFrontEndSprite.alpha = 1.0;
                             leftBackEndSprite.alpha = 0.0;
                             rightFrontEndSprite.alpha = 1.0;
                             rightBackEndSprite.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             NSLog(@"fadeOut finished");
                             [self pause];
                         }];
    }
}

- (void) pause{
    if (!running) {
        return;
    }
    if (self.animationParameter.isBlackout == 1) {
        leftFrontEndSprite.alpha = 0.0;
        leftBackEndSprite.alpha = 0.0;
        rightFrontEndSprite.alpha = 0.0;
        rightBackEndSprite.alpha = 0.0;
    }
    NSTimeInterval interval = self.animationParameter.pause /TIME_FACTOR;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(start)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)setBackgroundImage:(UIImage *)image{
    backgroundImageView.image = image;
}

- (void)setAnimationParameter:(AnimationParameter *)animationParameter{
    _animationParameter = animationParameter;
    [self prepare];
}

- (AnimationParameter *)animationParameter{
    return _animationParameter;
}

@end
