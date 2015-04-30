//
//  CallsNotificationsViewController.h
//  Embrace ios7
//
//  Created by Jie on 13-10-6.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FxMenuViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"
#import "DAContextMenuCell.h"
#import "DAOverlayView.h"


@class CallsNotificationsViewController;


@interface CallsNotificationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,DAContextMenuCellDelegate>
{
    IBOutlet UILabel *notificationsLabel;
    IBOutlet UITableView *notificationTableView;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIButton *backButton;
    IBOutlet UIImageView *line1;
    IBOutlet UIButton *actionsheetButton;
    
    NSMutableArray *notificationTitles;
    NSMutableArray *notificationImages;
    NSMutableArray *notificationIsSilent;
    
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *fxMenuLightDataDic;
    
    NSMutableArray *nameArray;
    NSMutableArray *imageNameArray;
    
    
    int selectNotiIndex;

    AppDelegate *appDelegate;
    

}
@property int styleIndex;
@property (strong, nonatomic) CBPeripheral *connectPeripheral;

@property (assign, nonatomic) UITableView *notificationTableView;

@property (assign, nonatomic) BOOL shouldDisableUserInteractionWhileEditing;

@property (strong, nonatomic) DAContextMenuCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) DAOverlayView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;

@end
