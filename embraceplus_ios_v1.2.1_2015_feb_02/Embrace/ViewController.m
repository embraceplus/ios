//
//  ViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-12.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "ConnectingViewController.h"
#import "ChooseStyleViewController.h"
#import "NotificationsViewController.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
#import "FilePath.h"
#import "NotificationUtility.h"

#import "Factory.h"

extern bool isNoChooseStyleViewController;
extern bool isFromSettingView;

@interface ViewController () <CBCentralManagerDelegate, CBPeripheralDelegate,LeEmbraceProtocol>
@property (strong, nonatomic) IBOutlet UITextView   *textview;
@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;
@end


int selectStyleIndex;
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationImageFilePath]])
    {
        notificationImages = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationImageFilePath]];
        
    }else
    {
        
        notificationImages = [[NSMutableArray alloc] initWithObjects:@"callIcon", @"smsIcon", /*@"alarmIcon",*/ @"calendarIcon",
                              @"batteryIcon",@"addIcon", nil];
        
        
    }


    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
    {
        
        notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
    }else
    {
       
        notificationTitles = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"  %@", callsNotificationString],[NSString stringWithFormat:@"  %@", textNotificationString],[NSString stringWithFormat:@"  %@", calendarNotificationString],[NSString stringWithFormat:@"  %@", batteryPhoneNotificationString],@"  Add event", nil];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationIsSilentFilePath]];
    }else
    {
        
        notificationIsSilent = [[NSMutableArray alloc] initWithObjects:@"0",@"0",
                                 @"0",@"0",@"0", nil];
    }
    

    [notificationImages writeToFile:[FilePath notificationImageFilePath] atomically:YES];
    [notificationTitles writeToFile:[FilePath notificationTitleFilePath] atomically:YES];
    [notificationIsSilent writeToFile:[FilePath notificationIsSilentFilePath] atomically:YES];

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationImageFilePath]])
    {
        callsNotificationImages = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationImageFilePath]];
        
    }
    else
    {
    
        callsNotificationImages = [[NSMutableArray alloc] initWithObjects:@"callIncoming", @"callUnknown", nil];
    
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationTitleFilePath]])
    {
        
        callsNotificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationTitleFilePath]];
    }else
    {
        
        callsNotificationTitles = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"  %@", incomingCallNotificationString],[NSString stringWithFormat:@"  %@", unknownCallNotificationString], nil];
        
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
    {
        
        callsNotificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
    }else
    {
        
        callsNotificationIsSilent = [[NSMutableArray alloc] initWithObjects:@"0",@"0",
                                nil];
    }
    
    [callsNotificationIsSilent writeToFile:[FilePath callsNotificationIsSilentFilePath] atomically:YES];
    
    [callsNotificationTitles writeToFile:[FilePath callsNotificationTitleFilePath] atomically:YES];
    [callsNotificationImages writeToFile:[FilePath callsNotificationImageFilePath] atomically:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    selectStyleIndex = [ud integerForKey:@"styleIndex"];
}

-(void) viewDidAppear:(BOOL)animated
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
    //if come from the Setting view
    
    if(isFromSettingView)
    {
        isFromSettingView = false;
        
        [self performSegueWithIdentifier:@"ChooseStyle" sender:self];
        
        return;
    }
    
#if 1
    
    backgroundImageView.image = appDelegate.backgroundImage;
    
    
    //if bt is connected, don't do scanning
    if([[[LeDiscovery sharedInstance] connectedServices] count] != 0)
    {
        [self performSegueWithIdentifier:@"ChooseStyle" sender:self];
        return;
        
    }
    connectingViewController = [[ConnectingViewController alloc] initWithNibName:@"ConnectingViewController" bundle:nil];
    [self presentPopupViewController:connectingViewController animationType:0];
    [connectingViewController.connectedLabel setHidden:YES];
    [connectingViewController.indicatorView startAnimating];
    [connectingViewController.indicatorView setHidden:NO];
    
    
    [[LeDiscovery sharedInstance] setPeripheralDelegate:self];
    //开始扫描指定服务
    //[[LeDiscovery sharedInstance] startScanningForUUIDString:kEmbraceServiceUUIDString];
    
    
#endif

    //start a timer
  
    myTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(btDidnotFound) userInfo:nil repeats:NO];
    
}

#pragma mark - kane
-(void) btDidnotFound
{
    NSLog(@"!!!!!!!!!");
    //releae the timer
    
    //
    [self dismissPopView];
    
    
    //pop up a dialog
    
//    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
//                                                   message:@"Embrace+ not found"
//                                                  delegate:self
//                                         cancelButtonTitle:@"ok"
//                                         otherButtonTitles:nil];
//    [alert show];
    //[alert release];
    [Factory dispanchTimerWithTime:BuleToothScanInterval Block:^
     {
         [[LeDiscovery sharedInstance] reConnect];
     }];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


static int count = 0;
- (void)dismissPopView
{
    [self dismissPopupViewControllerWithanimationType:0];
    if (count == 0) {
        count++;
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        if ([[ud objectForKey:@"isChangeBg"] boolValue])
        {
            [self performSegueWithIdentifier:@"JumpToNotification" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"ChooseStyle" sender:self];
        }
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"ChooseStyle"])
	{
        ChooseStyleViewController *chooseStyleViewController = segue.destinationViewController;
		chooseStyleViewController.connectPeripheral = self.discoveredPeripheral;
        
        if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        {
            chooseStyleViewController.isConnected = NO;
        }
        else
        {
            chooseStyleViewController.isConnected = YES;
        }
	}
    else if ([segue.identifier isEqualToString:@"JumpToNotification"])
    {
        NotificationsViewController *notificationViewController = segue.destinationViewController;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        if([ud objectForKey:@"styleIndex"]!=nil)
        {
            notificationViewController.styleIndex = [ud integerForKey:@"styleIndex"];
        }
        else{
            notificationViewController.styleIndex = 0;
        }
        
        if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        {
            notificationViewController.isConnected = NO;
        }
        else
        {
            notificationViewController.isConnected = YES;
        }

    }
}



- (void) deviceDidConnect
{
    NSLog(@"deviceDidConnect");
    //stop timer
    if(myTimer!=nil)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
    [connectingViewController.connectedLabel setHidden:NO];
    [connectingViewController.indicatorView stopAnimating];
    [connectingViewController.indicatorView setHidden:YES];
    
    [self performSelector:@selector(dismissPopView) withObject:nil afterDelay:2];

}


@end
