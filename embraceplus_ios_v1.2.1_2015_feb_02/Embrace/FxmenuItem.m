//
//  FxmenuItem.m
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "FxmenuItem.h"
#import <QuartzCore/QuartzCore.h>
@implementation FxmenuItem

@synthesize delegate;
@synthesize isEditable;
@synthesize delButton;
@synthesize selectImageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 66, 66)];
        // imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        // [self addGestureRecognizersToPiece:imageView];
        [imageView release];
        isEditable = NO;
        delButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        delButton.frame = CGRectMake(0, 0, 25, 25);
        [delButton setBackgroundImage:[UIImage imageNamed:@"erase_btn.png"] forState:UIControlStateNormal];
        [delButton addTarget:self action:@selector(itemDelete) forControlEvents:UIControlEventTouchUpInside];
        delButton.hidden = YES;
        delButton.tag = 100;
        [self addSubview:delButton];
    }
    return self;
}

-(void)showDeleteIcon
{
    
    if (delButton.isHidden)
    {
        delButton.hidden = NO;
        
        CATransform3D transform;
        if (arc4random()%2 ==1)
            transform = CATransform3DMakeRotation(-0.10, 0, 0, 1.0);
        else
            transform = CATransform3DMakeRotation(0.10, 0, 0, 1.0);
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.toValue = [NSValue valueWithCATransform3D:transform];
        animation.autoreverses = YES;
        animation.duration = 0.1;
        animation.repeatCount = 10000;
        animation.delegate = self;
        [[self layer] addAnimation:animation forKey:@"wiggleAnimation"];
    }
    else
    {
        delButton.hidden = YES;
        [[self layer]removeAllAnimations];
    }
}

// Delete Button Touched
-(void)itemDelete {
    
    NSLog(@"item deleted");
    [self removeFromSuperview];
    [delegate itemDidDelectedWithTag:self.tag];
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.image forKey:@"itemImage"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        self.image  = [aDecoder decodeObjectForKey:@"itemImage"];
    }
    return self;
}
- (void)dealloc
{
    [delButton release];
    [selectImageView release];
    [super dealloc];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
