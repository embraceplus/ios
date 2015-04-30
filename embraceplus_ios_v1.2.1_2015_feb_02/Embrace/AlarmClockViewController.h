//
//  AddFxMenuViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FxIconsViewController.h"
#import "AppDelegate.h"
#import "AddFxMenuViewController.h"
#import "BaseFxMenuViewController.h"

@class AddFxMenuViewController;


@interface AlarmClockViewController : BaseFxMenuViewController
{
    
    IBOutlet UIImageView *line2;
    IBOutlet UIImageView *line3;
    
    IBOutlet UILabel *startLabel;
    IBOutlet UILabel *colonLabel;
    
    IBOutlet UISwitch *startSwitch;

    IBOutlet UIDatePicker *datePicker;

    AppDelegate *appDelegate;
    
    BOOL isStart;
}

- (IBAction)dateChanged;

@end
