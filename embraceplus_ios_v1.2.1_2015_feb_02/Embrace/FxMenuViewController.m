//
//  FxMenuViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "FxMenuViewController.h"
#import "CustomEffectConfig.h"

#define Screen_height   [[UIScreen mainScreen] bounds].size.height
#define Screen_width    [[UIScreen mainScreen] bounds].size.width
NSString *kDetailedViewControllerID = @"DetailView";    // view controller storyboard id
                         // UICollectionViewCell storyboard id
@interface FxMenuViewController ()

@end

@implementation FxMenuViewController
//@synthesize delegate;



uint8_t data[15];
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
    cellNumPerPage = 6;
    
    CGRect frame = pageControl.frame;
    

   
    fxMenuCollectionView.frame = CGRectMake(19, 65+deltaY, 285, 275);
    
    if (iPhone5) {
        
        line2.frame = CGRectMake(0, 414 + deltaY, 320, 2);
        frame.origin.y = 390;

    }
    else {

        line2.frame = CGRectMake(0, 363+ deltaY, 320, 2);
        frame.origin.y = 350;
    
    }
    
    pageControl.frame = frame;
  	
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *_currentView in actionSheet.subviews) {
        if ([_currentView isKindOfClass:[UIButton class]]) {
            ((UIButton *)_currentView).titleLabel.font = [UIFont fontWithName:@"Avenir" size:18];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [super dealloc];
        
    [line2 release];
    
}
@end
