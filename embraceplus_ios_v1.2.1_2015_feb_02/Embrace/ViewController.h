//
//  ViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-12.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ConnectingViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController
{
    ConnectingViewController *connectingViewController;
    
    IBOutlet UIImageView *backgroundImageView;
    
    AppDelegate *appDelegate;
    NSTimer *myTimer;
    
    NSMutableArray *notificationTitles;
    NSMutableArray *notificationImages;
    
    NSMutableArray *notificationIsSilent;
    NSMutableArray *callsNotificationTitles;
    NSMutableArray *callsNotificationImages;
    NSMutableArray *callsNotificationIsSilent;
}

@end
