//
//  SettingsViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface AboutViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *aboutLabel;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *line1;
    
    UIScrollView *scroll;
    AppDelegate *appDelegate;
}
@end
