//
//  EmulatorView.h
//  EmbracePlus ios7
//
//  Created by 赵雅琦 on 14-12-3.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationParameter.h"

@interface EmulatorView : UIView{
    IBOutlet UIImageView* backgroundImageView;
    IBOutlet UIImageView* leftBackEndSprite;
    IBOutlet UIImageView* leftFrontEndSprite;
    IBOutlet UIImageView* rightBackEndSprite;
    IBOutlet UIImageView* rightFrontEndSprite;
    
    CGFloat alpha;
    BOOL running;
}


@property(strong) AnimationParameter* animationParameter;

+ (EmulatorView*)emulator:(AnimationParameter*)animationParameter;
+ (EmulatorView*)bigEmulator:(AnimationParameter*)animationParameter;

- (void) setBackgroundImage:(UIImage*)image;

- (void) showInView:(UIView*)view;
- (void) stopRuning;    //must called when remove from superview or release
- (void)startAnimation;

@end
