//
//  NotificationsViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FxMenuViewController.h"
#import "CallsNotificationsViewController.h"
#import "AddEventViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"
#import "ConnectingViewController.h"


#import "DAContextMenuCell.h"

@interface NotificationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,addEventViewDelegate,DAContextMenuCellDelegate>

{
    IBOutlet UILabel *notificationsLabel;
    IBOutlet UITableView *notificationTableView;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIButton *connectButton;
    IBOutlet UIButton *settingButton;
    IBOutlet UIImageView *line1;
    
    NSMutableArray *notificationTitles;
    NSMutableArray *notificationImages;
    NSMutableArray *notificationIsSilent;
    
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *fxMenuLightDataDic;
    
    int selectNotiIndex;
    AppDelegate *appDelegate;
    
    NSMutableDictionary *embraceUUIDDic;
    ConnectingViewController *connectingViewController;
    
    NSTimer *myTimer;
    
    BOOL shouldDisableUserInteractionWhileEditing;
}
@property int styleIndex;
@property BOOL isConnected;

@property (assign, nonatomic) UITableView *notificationTableView;
@property (strong, nonatomic) CBPeripheral *connectPeripheral;

@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;
- (IBAction)reConnectButtonClicked;
@end
