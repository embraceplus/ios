//
//  SettingsViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *settingLabel;
    IBOutlet UITableView *notificationTableView;
    IBOutlet UIImageView *backgroundImageView;
    NSArray* viewControllers;
	NSArray* indexImages;
    IBOutlet UIImageView *line1;
    
    int batteryLevel;
    
    AppDelegate *appDelegate;
}
@property int styleIndex;
@end
