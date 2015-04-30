//
//  SettingsViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface HelpViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *helpLabel;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *line1;
    
    IBOutlet UITableView *helpTableView;
    AppDelegate *appDelegate;
    
    NSArray *helpTitleArray;
    
    int currentHelpIndex;
}
@end
