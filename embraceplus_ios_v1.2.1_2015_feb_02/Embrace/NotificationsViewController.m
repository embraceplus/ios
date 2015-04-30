//
//  NotificationsViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "NotificationsViewController.h"
#import "FxMenuViewController.h"
#import "CallsNotificationsViewController.h"
#import "ClockNotificationsViewController.h"
#import "LeDiscovery.h"
#import "FilePath.h"
#import "SettingsViewController.h"


#import "DAContextMenuCell.h"
#import "DAOverlayView.h"

#import "UIViewController+MJPopupViewController.h"
#import "NotificationUtility.h"

#import "Factory.h"

@interface NotificationsViewController ()<DAOverlayViewDelegate,LeEmbraceProtocol>

@property (strong, nonatomic) DAContextMenuCell *cellDisplayingMenuOptions;
@property (strong, nonatomic) DAOverlayView *overlayView;
@property (assign, nonatomic) BOOL customEditing;
@property (assign, nonatomic) BOOL customEditingAnimationInProgress;
@property (strong, nonatomic) UIBarButtonItem *editBarButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneBarButtonItem;

@end

@implementation NotificationsViewController
@synthesize styleIndex;
@synthesize isConnected;
@synthesize connectPeripheral;
@synthesize notificationTableView;


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
    
    self.customEditing = self.customEditingAnimationInProgress = NO;
	// Do any additional setup after loading the view.
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
    connectButton.frame = CGRectMake(18, 8 + deltaY, 34, 34);
    connectButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
    
    settingButton.frame = CGRectMake(268, 8 + deltaY, 34, 34);
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    
    if (iPhone5) {
        notificationTableView.frame = CGRectMake(0, 48.5+ deltaY, 320, 477);
    }else
    {
        notificationTableView.frame = CGRectMake(0, 48.5+ deltaY, 320, 425);
    }
    
    CGRect chooseLabelFrame = notificationsLabel.frame;
    chooseLabelFrame.origin.y = 7+ deltaY;
    notificationsLabel.frame = chooseLabelFrame;

    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationImageFilePath]])
    {
        notificationImages = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationImageFilePath]];
#pragma mark -kane
//        NSString *s = [FilePath getImageNotificationFilePath:[UserInfo sharedInstance].userThems];
//        notificationImages = [[NSMutableArray alloc]initWithContentsOfFile:s];
        
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
    {
        
        notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
#pragma mark -kane
//        NSString *s = [FilePath getThemesNotificationFilePath:[UserInfo sharedInstance].userThems];
//        notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:s];
    }
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationIsSilentFilePath]];
    }
    
    
    [notificationTitles writeToFile:[FilePath notificationTitleFilePath] atomically:YES];
    [notificationImages writeToFile:[FilePath notificationImageFilePath] atomically:YES];
    [notificationIsSilent writeToFile:[FilePath notificationIsSilentFilePath] atomically:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btConnect:)  name:@"btConnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btDisconnect:)  name:@"btDisconnectNotification" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] != 0)
    {
        [connectButton setImage:[UIImage imageNamed:@"btConnect.png"] forState:UIControlStateNormal];
    }
    else {
        [connectButton setImage:[UIImage imageNamed:@"btDisconnect.png"] forState:UIControlStateNormal];
    }

    
    notificationTableView.separatorColor = [UIColor clearColor];
    notificationsLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backgroundImageView.image = appDelegate.backgroundImage;
    
    selectNotiIndex = 0;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iPhone5)
        return 59;
    else
        return 58;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [notificationTitles count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NotificationCell";
    
    DAContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[DAContextMenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier: CellIdentifier] autorelease];

    }
    else
    {
        [[cell viewWithTag:99] removeFromSuperview];
        [[cell viewWithTag:100] removeFromSuperview];
        [[cell viewWithTag:1] removeFromSuperview];
        [[cell viewWithTag:2] removeFromSuperview];
    }

    cell.delegate = self;
    
    cell.isAllowDelete = YES;
    
    //NSLog(@"silent value = %d",[notificationIsSilent[indexPath.row] intValue]);
    if([notificationIsSilent[indexPath.row] intValue] == 0)
    {
        cell.isSilent = NO;
    }
    else
    {
        cell.isSilent = YES;
    }
    
    if(indexPath.row == [notificationTitles count]-1)
        cell.isSwipeOn = NO;
    else
        cell.isSwipeOn = YES;
    
	
    UILabel *label = [[UILabel alloc] init];
    if (iPhone5)
        label.frame = CGRectMake(80, 8, 150, 43);
    else
        label.frame = CGRectMake(80, 7, 150, 43);
    
    label.tag = 99;
    label.font = [UIFont fontWithName:@"Avenir Next Condensed" size:18];
    //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
	label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = [notificationTitles objectAtIndex:indexPath.row];
    if([notificationIsSilent[indexPath.row] intValue] == 0)
    {
        label.alpha = 1.0;
    }
    else
    {
        label.alpha = 0.4;
    }

    [cell.actualContentView addSubview:label];
	[label release];

   
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[notificationImages objectAtIndex:indexPath.row]]];
    if (iPhone5)
        icon.frame = CGRectMake(18, 8, 43, 43);
    else
        icon.frame = CGRectMake(18, 7, 43, 43);
    
    icon.tag = 100;
    if([notificationIsSilent[indexPath.row] intValue] == 0)
    {
        icon.alpha = 1.0;
    }
    else
    {
        icon.alpha = 0.4;
    }
	[cell.actualContentView addSubview:icon];
	[icon release];
    
	UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification_cell_arrow"]];
	//accessoryView.frame = CGRectMake(290, 25-5, 15, 15);
    accessoryView.frame = CGRectMake(290, 25-12, 13, 30);
    accessoryView.tag = 1;
	[cell.actualContentView addSubview:accessoryView];
	[accessoryView release];
  

    UIImageView* cellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
    if (iPhone5) {
        cellLine.frame = CGRectMake(66, 57, 254, 2);
    }
    else
        cellLine.frame = CGRectMake(68, 56, 249, 2);
    
    cellLine.tag = 2;
    [cell.actualContentView addSubview:cellLine];
	[cellLine release];

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)deleteButtonTapped
{
    NSLog(@"!!!!!!!!!");
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectNotiIndex = indexPath.row;
    
    if([notificationTitles[selectNotiIndex] rangeOfString:@"Calls"].length!=0)
    {
        [self performSegueWithIdentifier:@"calls" sender:self];
    }
    else if([notificationTitles[selectNotiIndex] rangeOfString:@"Clock"].length!=0)
    {
        [self performSegueWithIdentifier:@"clock" sender:self];
    }
    else if([notificationTitles[selectNotiIndex] rangeOfString:@"Add event"].length!=0)
    {
        [self performSegueWithIdentifier:@"addevent" sender:self];
    }
    else
    {
        if([notificationTitles[selectNotiIndex] rangeOfString:@"Text"].length!=0)
        {
            [UserInfo sharedInstance].isText = YES;
        }
        if([notificationTitles[selectNotiIndex] rangeOfString:@"Calendar"].length!=0)
        {
            [UserInfo sharedInstance].isCalendar = YES;
        }
        if([notificationTitles[selectNotiIndex] rangeOfString:@"Battery phone"].length!=0)
        {
            [UserInfo sharedInstance].isBattery = YES;
        }
        [self performSegueWithIdentifier:@"fxmenu" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"fxmenu"])
	{
		FxMenuViewController *fxViewController = segue.destinationViewController;
        fxViewController.styleIndex = styleIndex;
        fxViewController.notificationIndex = selectNotiIndex;
        
    }
    else if ([segue.identifier isEqualToString:@"calls"])
	{
        CallsNotificationsViewController *callsNotificationsViewController = segue.destinationViewController;
        callsNotificationsViewController.styleIndex = styleIndex;

        
    }
    else if ([segue.identifier isEqualToString:@"clock"])
	{
        ClockNotificationsViewController *clockNotificationsViewController = segue.destinationViewController;
        clockNotificationsViewController.styleIndex = styleIndex;
        
        
    }
    else if ([segue.identifier isEqualToString:@"addevent"])
	{
        AddEventViewController *addEventViewController = segue.destinationViewController;
        addEventViewController.delegate = self;
    
    }
    else if ([segue.identifier isEqualToString:@"setting"])
	{
        SettingsViewController *settingsViewController = segue.destinationViewController;
        settingsViewController.styleIndex = styleIndex;
        
    }


}

#pragma mark - 添加时间回调  kane
- (void)backNotificationViewControllerFromAddEvent:(AddEventViewController*)controller iconImagePath:(NSString *)imageName notificationTitle:(NSString *)notificationTitle

{
    
    [notificationTitles insertObject:[NSString stringWithFormat:@"%@",notificationTitle] atIndex:[notificationTitles count]-1];
    [notificationImages insertObject:[NSString stringWithFormat:@"%@",imageName] atIndex:[notificationImages count]-1];
    [notificationIsSilent insertObject:@"0" atIndex:[notificationIsSilent count]-1];
    
    [notificationTitles writeToFile:[FilePath notificationTitleFilePath] atomically:YES];
#pragma mark - kane
//    [notificationTitles writeToFile:[FilePath getThemesNotificationFilePath:[UserInfo sharedInstance].userThems] atomically:YES];
    
    
    [notificationImages writeToFile:[FilePath notificationImageFilePath] atomically:YES];
#pragma mark - kane
//    [notificationImages writeToFile:[FilePath getImageNotificationFilePath:[UserInfo sharedInstance].userThems] atomically:YES];
    
    [notificationIsSilent writeToFile:[FilePath notificationIsSilentFilePath] atomically:YES];
    
    [notificationTableView reloadData];
	[self.navigationController popViewControllerAnimated:YES];
    
    [NotificationUtility singleNotificationSwitched:styleIndex notificationIndex:[notificationTitles count]-2 mode:1];
    
#pragma mark - kane
    [notificationTableView reloadData];
    
    
}
- (void)dealloc
{
    [super dealloc];
    
    [notificationsLabel release];
    [notificationTableView release];
    [backgroundImageView release];
    [connectButton release];
    [settingButton release];
    [line1 release];
    
    [fxForStyleDic release];
    
    [notificationTitles release];
    [notificationImages release];
    [notificationIsSilent release];
    [fxMenuLightDataDic release];

}


-(void)btConnect:(NSNotification *)notification
{
    NSLog(@"btConnect");
    [connectButton setImage:[UIImage imageNamed:@"btConnect.png"] forState:UIControlStateNormal];
}

-(void)btDisconnect:(NSNotification *)notification
{
    NSLog(@"btDisconnect");
    [connectButton setImage:[UIImage imageNamed:@"btDisconnect.png"] forState:UIControlStateNormal];
}

- (void)dismissPopView
{
    [self dismissPopupViewControllerWithanimationType:0];
    
}

-(void) btDidnotFound
{
   
    //release the timer
    if(myTimer!=nil)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
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
- (IBAction)reConnectButtonClicked
{
    if([[[LeDiscovery sharedInstance] connectedServices] count] != 0)
    {
        return;
    }
    
    connectingViewController = [[ConnectingViewController alloc] initWithNibName:@"ConnectingViewController" bundle:nil];
    [self presentPopupViewController:connectingViewController animationType:0 dismissed:nil];
    [connectingViewController.connectedLabel setHidden:YES];
    [connectingViewController.indicatorView startAnimating];
    [connectingViewController.indicatorView setHidden:NO];
    
    //start a timer
    [[LeDiscovery sharedInstance] setPeripheralDelegate:self];
    
    myTimer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(btDidnotFound) userInfo:nil repeats:NO];
    
    CBCentralManager * central;
    central = ((LeDiscovery *)[LeDiscovery sharedInstance]).centralManager;
    
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version<7.0)
    {
        [central retrieveConnectedPeripherals];
    }
    else
    {
        NSArray	*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:kEmbraceServiceUUIDString], nil];
        
        NSArray *connectedPeripheralArray = [[NSArray alloc] init];
        connectedPeripheralArray = [central retrieveConnectedPeripheralsWithServices:uuidArray];
        
        NSLog(@"connectedPeripheralArray = %d",[connectedPeripheralArray count]);
        CBPeripheral *peripheral;
        
        NSString *UUID;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
        {
            embraceUUIDDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath embraceUUIDFilePath]];
            
            UUID = [embraceUUIDDic objectForKey:@"UUID"];
            NSLog(@"saved uuid = %@",UUID);
            
        }
        else
        {
            UUID = @"";
        }
        
        if([connectedPeripheralArray count] > 0)
        {
            for (peripheral in connectedPeripheralArray) {
                NSLog(@"didRetrieveConnectedPeripherals");
                
                if([[peripheral.identifier UUIDString] isEqualToString:UUID])
                {
                    NSLog(@"uuid is found");
                    [central connectPeripheral:peripheral options:nil];
                    [peripheral retain];
                    return;
                }
            }
            
            [central connectPeripheral:connectedPeripheralArray[0] options:nil];
            [connectedPeripheralArray[0] retain];
            
        }else
        {
            NSLog(@"start scanning!!!!!!!");
            [[LeDiscovery sharedInstance] startScanningForUUIDString:kEmbraceServiceUUIDString];
        }

    }

}


#pragma mark - Private

- (void)hideMenuOptionsAnimated:(BOOL)animated
{
    __block NotificationsViewController *weakSelf = self;
    [self.cellDisplayingMenuOptions setMenuOptionsViewHidden:YES animated:animated completionHandler:^{
        weakSelf.customEditing = NO;
    }];
}

- (void)setCustomEditing:(BOOL)customEditing
{
    if (_customEditing != customEditing) {
        _customEditing = customEditing;
        self.notificationTableView.scrollEnabled = !customEditing;
        if (customEditing) {
            if (!_overlayView) {
                _overlayView = [[DAOverlayView alloc] initWithFrame:self.view.bounds];
                
                NSLog(@"_overlayView = %@",_overlayView);
                _overlayView.backgroundColor = [UIColor clearColor];
                _overlayView.delegate = self;
            }
            self.overlayView.frame = self.view.bounds;
            [self.view addSubview:_overlayView];
            if (self.shouldDisableUserInteractionWhileEditing) {
                for (UIView *view in self.notificationTableView.subviews) {
                    if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                        view.userInteractionEnabled = NO;
                    }
                }
            }
        } else {
            self.cellDisplayingMenuOptions = nil;
            [self.overlayView removeFromSuperview];
            for (UIView *view in self.notificationTableView.subviews) {
                if ((view.gestureRecognizers.count == 0) && view != self.cellDisplayingMenuOptions && view != self.overlayView) {
                    view.userInteractionEnabled = YES;
                }
            }
        }
    }
}


- (void) deviceDidConnect
{
    NSLog(@"deviceDidConnect");
    //stop timer
    if(myTimer!= nil)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
    [connectingViewController.connectedLabel setHidden:NO];
    [connectingViewController.indicatorView stopAnimating];
    [connectingViewController.indicatorView setHidden:YES];

    [self performSelector:@selector(dismissPopView) withObject:nil afterDelay:2];
    
}

#pragma mark * DAContextMenuCell delegate

- (void)updateSilentStatus:(DAContextMenuCell *)cell
{
    NSLog(@"updateSilentStatus!!!!!!! %d = %d",[self.notificationTableView indexPathForCell:cell].row,[cell isSilent]);
    //change slient status
    if([cell isSilent])
    {
        notificationIsSilent[[self.notificationTableView indexPathForCell:cell].row] = @"1";
        [cell viewWithTag:99].alpha = 0.4;
        [cell viewWithTag:100].alpha = 0.4;
    }
    else
    {
        notificationIsSilent[[self.notificationTableView indexPathForCell:cell].row] = @"0";
        [cell viewWithTag:99].alpha = 1;
        [cell viewWithTag:100].alpha = 1;
    }
    
    //write
    [notificationIsSilent writeToFile:[FilePath notificationIsSilentFilePath] atomically:YES];
    
    [self hideMenuOptionsAnimated:YES];
    //[notificationTableView reloadData];
    
    [NotificationUtility singleNotificationSwitched:styleIndex notificationIndex:[self.notificationTableView indexPathForCell:cell].row mode:1];
    

    
}
- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    NSLog(@"contextMenuCellDidSelectMoreOption!!!!!");
}

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    //[super contextMenuCellDidSelectDeleteOption:cell];
    [cell.superview sendSubviewToBack:cell];
    self.customEditing = NO;

    //self.rowsCount -= 1;
    
    NSLog(@"cell index = %d",[self.notificationTableView indexPathForCell:cell].row);
    
    //disable the notification before deleting
    [NotificationUtility disableNotificationByTitle:[notificationTitles objectAtIndex:[self.notificationTableView indexPathForCell:cell].row]];
    
    [notificationTitles removeObjectAtIndex:[self.notificationTableView indexPathForCell:cell].row];
    [notificationImages removeObjectAtIndex:[self.notificationTableView indexPathForCell:cell].row];
    [notificationIsSilent removeObjectAtIndex:[self.notificationTableView indexPathForCell:cell].row];
    
    [notificationTitles writeToFile:[FilePath notificationTitleFilePath] atomically:YES];
    [notificationImages writeToFile:[FilePath notificationImageFilePath] atomically:YES];
    [notificationIsSilent writeToFile:[FilePath notificationIsSilentFilePath] atomically:YES];

    //if delete CALLS, also delete the plist file for callsNotification
    if([[notificationTitles objectAtIndex:[self.notificationTableView indexPathForCell:cell].row] rangeOfString:@"CALL"].length!=0)
    {
        NSFileManager *defaultManager;
        defaultManager = [NSFileManager defaultManager];
        
        [defaultManager removeItemAtPath:[FilePath callsNotificationTitleFilePath] error:nil];
        [defaultManager removeItemAtPath:[FilePath callsNotificationImageFilePath] error:nil];
        [defaultManager removeItemAtPath:[FilePath callsNotificationIsSilentFilePath] error:nil];
        
    }
    
    //also delete the info in the 
    [self.notificationTableView deleteRowsAtIndexPaths:@[[self.notificationTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


- (void)contextMenuDidHideInCell:(DAContextMenuCell *)cell
{
    self.customEditing = NO;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuDidShowInCell:(DAContextMenuCell *)cell
{
    self.cellDisplayingMenuOptions = cell;
    self.customEditing = YES;
    self.customEditingAnimationInProgress = NO;
}

- (void)contextMenuWillHideInCell:(DAContextMenuCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (void)contextMenuWillShowInCell:(DAContextMenuCell *)cell
{
    self.customEditingAnimationInProgress = YES;
}

- (BOOL)shouldShowMenuOptionsViewInCell:(DAContextMenuCell *)cell
{
    return self.customEditing && !self.customEditingAnimationInProgress;
}

#pragma mark * DAOverlayView delegate

- (UIView *)overlayView:(DAOverlayView *)view didHitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL shouldIterceptTouches = YES;
    CGPoint location = [self.view convertPoint:point fromView:view];
    CGRect rect = [self.notificationTableView convertRect:self.cellDisplayingMenuOptions.frame toView:self.view];
    
    //CGPoint convertLocation = [view convertPoint:location fromView:self.cellDisplayingMenuOptions];
    
    
    shouldIterceptTouches = CGRectContainsPoint(rect, location);
    
    if (!shouldIterceptTouches) {
        [self hideMenuOptionsAnimated:YES];
        NSLog(@"overlayView [self hideMenuOptionsAnimated:YES]!!!!!");
    }
    return (shouldIterceptTouches) ? [self.cellDisplayingMenuOptions hitTest:point withEvent:event] : view;
}


@end
