//
//  ChooseStyleViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-13.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "addStyleViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"

#import "ConnectingViewController.h"

#import "EmulatorView.h"

#define TI_KEYFOB_PROXIMITY_ALERT_UUID                      0x1802
#define stepper   0x2A06
@interface ChooseStyleViewController : UIViewController<SwipeViewDelegate, SwipeViewDataSource,addStyleDelegate,UIActionSheetDelegate>
{
    IBOutlet UILabel *chooseStyleLabel;
    IBOutlet UIButton *selectButton;
    
    IBOutlet UIButton *connectButton;
    
    IBOutlet UIButton *settingButton;
    IBOutlet UIImageView *line1;
    IBOutlet UIImageView *line2;
    IBOutlet SwipeView *swipeView;
    
    IBOutlet UIButton *actionsheetButton;
    IBOutlet UIButton *doneButton;
    
    NSMutableArray *styleTitleArray;       //style title array
    NSMutableArray *styleImages;           //style image array
    
    
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *fxMenuLightDataDic;
    
    NSTimer *sendTimer;
    
    AppDelegate *appDelegate;
    
    NSMutableDictionary *embraceUUIDDic;
    
    ConnectingViewController *connectingViewController;
    
    UIActivityIndicatorView* indicator;
    
    NSTimer *myTimer;
    
    int editStatus;

    EmulatorView* emulator;
}

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) CBPeripheral *connectPeripheral;

@property (strong, nonatomic) CIImage *selectImageTemp;
@property BOOL isConnected;
- (IBAction)pageControlTapped;
- (IBAction)reConnectButtonClicked;

@end
