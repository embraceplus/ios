//
//  CallsNotificationsViewController.m
//  Embrace ios7
//
//  Created by jie on 13-10-6.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//
#import "CallsNotificationsViewController.h"
#import "FxMenuViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "DAContextMenuCell.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
#import "DAOverlayView.h"
#import "FilePath.h"
#import "NotificationUtility.h"

@interface CallsNotificationsViewController (ABPeoplePickerNavigationControllerDelegate)<DAOverlayViewDelegate>

- (void)displayPerson:(ABRecordRef)person;

@end



@implementation CallsNotificationsViewController
@synthesize styleIndex;
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
	// Do any additional setup after loading the view.
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);

    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    
    if (iPhone5) {
        notificationTableView.frame = CGRectMake(0, 48.5+ deltaY, 320, 477);
    }else
    {
        notificationTableView.frame = CGRectMake(0, 48.5+ deltaY, 320, 425);
    }
    actionsheetButton.frame = CGRectMake(268, 8 + deltaY, 34, 34);

    CGRect chooseLabelFrame = notificationsLabel.frame;
    chooseLabelFrame.origin.y += deltaY;
    notificationsLabel.frame = chooseLabelFrame;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationImageFilePath]])
    {
        notificationImages = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationImageFilePath]];
        
    }


    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationTitleFilePath]])
    {
        
        notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationTitleFilePath]];
 #pragma mark - kane
//        notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath getThemesCallsFilePath:[UserInfo sharedInstance].userThems]];
    }

    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
    }

    
    [notificationIsSilent writeToFile:[FilePath callsNotificationIsSilentFilePath] atomically:YES];
    
    [notificationTitles writeToFile:[FilePath callsNotificationTitleFilePath] atomically:YES];
    [notificationImages writeToFile:[FilePath callsNotificationImageFilePath] atomically:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    notificationTableView.separatorColor = [UIColor clearColor];
    notificationsLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backgroundImageView.image = appDelegate.backgroundImage;
    
    selectNotiIndex = 0;
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, notificationTableView.frame.size.width, 50)] autorelease];
    return footerView;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CallsNotificationCell";
    
    
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
    //
    cell.delegate = self;
    
    if(indexPath.row <2)
    {
        cell.isAllowDelete = NO;
    }
    else
    {
        cell.isAllowDelete = YES;

    }
    
    if([notificationIsSilent[indexPath.row] intValue] == 0)
    {
        cell.isSilent = NO;
    }
    else
    {
        cell.isSilent = YES;
    }
    
    cell.isSwipeOn = YES;
    
#if 1
   
	
    UILabel *label = [[UILabel alloc] init];
    if (iPhone5)
        label.frame = CGRectMake(80, 8, 150, 43);
    else
        label.frame = CGRectMake(80, 7, 150, 43);
    
    label.tag = 99;
    label.font = [UIFont fontWithName:@"Avenir Next Condensed" size:18];
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
    
#if 1
    
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
    
#endif
    UIImageView* cellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
    if (iPhone5) {
        cellLine.frame = CGRectMake(66, 57, 254, 2);
    }
    else
        cellLine.frame = CGRectMake(71, 56, 249, 2);
    
    cellLine.tag = 2;
    [cell.actualContentView addSubview:cellLine];
	[cellLine release];
    
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
#endif
    
    return cell;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectNotiIndex = indexPath.row+100;
    
    [self performSegueWithIdentifier:@"fxmenu" sender:self];

}


- (IBAction)actionSheetButton:(id)sender
{
    UIActionSheet *actionSheet;
           actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles: @"Add",nil];
        actionSheet.tag = 102;
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 102)
    {
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];

        switch (buttonIndex)
        {
            case 0:
            
                picker.peoplePickerDelegate = self;
                [self presentViewController:picker animated:YES completion:nil];
                break;
                
            case 1:
                //cancel
                break;
                
        }
        
       

    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"fxmenu"])
	{
		FxMenuViewController *fxViewController = segue.destinationViewController;
		//fxViewController.delegate = self;
        NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
        
        fxViewController.styleIndex = styleIndex;
        fxViewController.notificationIndex = selectNotiIndex;
        
        
    }
}
- (void)backNotificationViewController:(FxMenuViewController*)controller
{
	[self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [super dealloc];
    [fxForStyleDic release];
    [fxMenuLightDataDic release];
    
    [notificationsLabel release];
    [notificationTableView release];
    [backgroundImageView release];
    [backButton release];
    [line1 release];
    [actionsheetButton release];
}

#pragma - Display person

- (void)displayPerson:(ABRecordRef)person
{
    NSString* firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonFirstNameProperty);
    
    NSString* lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person,kABPersonLastNameProperty);
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
   
    NSString *name;
    if(firstName == nil && lastName != nil)
    {
        name = lastName;
    }
    else if(firstName != nil && lastName == nil)
    {
        name = firstName;
    }
    else if(firstName != nil && lastName != nil)
    {
        name = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@",lastName]];
    }
    else if(firstName == nil && lastName == nil)
    {
        return;
    }

    
    NSLog(@"name = %@",name);
    
    //search to see whether it is already added into the list
    for(NSString *string in notificationTitles)
    {
        if([string rangeOfString:name].length!=0)
            return;
    }
    
    [notificationTitles insertObject:[NSString stringWithFormat:@"  %@",name] atIndex:[notificationTitles count]];
    
    [notificationImages insertObject:[NSString stringWithFormat:@"%@",@"callIcon"] atIndex:[notificationImages count]];
    [notificationIsSilent insertObject:@"0" atIndex:[notificationIsSilent count]];

    [notificationTitles writeToFile:[FilePath callsNotificationTitleFilePath] atomically:YES];
#pragma mark - kane
//    [notificationTitles writeToFile:[FilePath getThemesCallsFilePath:[UserInfo sharedInstance].userThems] atomically:YES];
    
    
    [notificationImages writeToFile:[FilePath callsNotificationImageFilePath] atomically:YES];
    [notificationIsSilent writeToFile:[FilePath callsNotificationIsSilentFilePath] atomically:YES];
    
    [notificationTableView reloadData];
	

}

#pragma - Contacts delegate


// Called after the user has pressed cancel
// The delegate is responsible for dismissing the peoplePicker
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Called after a person has been selected by the user.
// Return YES if you want the person to be displayed.
// Return NO  to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self displayPerson:person];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

// Called after a value has been selected by the user.
// Return YES if you want default action to be performed.
// Return NO to do nothing (the delegate is responsible for dismissing the peoplePicker).
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0){
    NSLog(@"didSelectPerson");
    [self displayPerson:person];
}
#pragma mark - Private

- (void)hideMenuOptionsAnimated:(BOOL)animated
{
    __block CallsNotificationsViewController *weakSelf = self;
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

#pragma mark * DAContextMenuCell delegate

- (void)updateSilentStatus:(DAContextMenuCell *)cell
{
    NSLog(@"updateSilentStatus!!!!!!!%d= %d",[self.notificationTableView indexPathForCell:cell].row,[cell isSilent]);
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
    
    NSLog(@"callsnotificationIsSilent=%@",notificationIsSilent);
    //write
    [notificationIsSilent writeToFile:[FilePath callsNotificationIsSilentFilePath] atomically:YES];
    
    [self hideMenuOptionsAnimated:YES];
    //[notificationTableView reloadData];
    
    [NotificationUtility singleNotificationSwitched:styleIndex notificationIndex:[self.notificationTableView indexPathForCell:cell].row+100 mode:1];
    
    
}
- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    NSLog(@"contextMenuCellDidSelectMoreOption!!!!!");
    
    //update the config
    
    NSMutableArray *fxTitleArray;
    int selectFxIndex;
    int rowIndex;
    
    rowIndex = [self.notificationTableView indexPathForCell:cell].row;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
        NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
        fxTitleArray = [dictionary objectForKey:@"title"];
        
         NSMutableDictionary *notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d", rowIndex+ 100]]intValue];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }
    
    NSLog(@"FX name =%@",[fxTitleArray objectAtIndex:selectFxIndex]);
    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[fxTitleArray objectAtIndex:selectFxIndex]];
    
    
    int lFromR;
    int lFromG;
    int lFromB;
    
    int16_t lToR;
    int lToG;
    int lToB;
    
    int rFromR;
    int rFromG;
    int rFromB;
    
    int rToR;
    int rToG;
    int rToB;
    
    int durationTime1;
    int durationTime2;
    int isBlackout;
    int isRandom;
    
    int hold;
    int pause;
    int isVibrate;
    int loop;
    
    lFromR = [[lightDataArray objectAtIndex:0] intValue];    //L灯 R  (From)
    lFromG= [[lightDataArray objectAtIndex:1] intValue];    //L灯 G  (From)
    lFromB = [[lightDataArray objectAtIndex:2] intValue];    //L灯 B  (From)
    
    lToR = [[lightDataArray objectAtIndex:3] intValue];    //L灯 R  (To)
    lToG = [[lightDataArray objectAtIndex:4] intValue];    //L灯 G  (To)
    lToB = [[lightDataArray objectAtIndex:5] intValue];    //L灯 B  (To)
    
    
    rFromR= [[lightDataArray objectAtIndex:6] intValue];    //R灯 R  (From)
    rFromG= [[lightDataArray objectAtIndex:7] intValue];    //R灯 G  (From)
    rFromB= [[lightDataArray objectAtIndex:8] intValue];    //R灯 B  (From)
    
    rToR = [[lightDataArray objectAtIndex:9] intValue];    //R灯 R  (To)
    rToG = [[lightDataArray objectAtIndex:10] intValue];    //R灯 G  (To)
    rToB = [[lightDataArray objectAtIndex:11] intValue];    //R灯 B  (To)
    
    durationTime1 = [[lightDataArray objectAtIndex:12] intValue];    //duration
    durationTime2 = [[lightDataArray objectAtIndex:13] intValue];    //duration
    
    isBlackout = [[lightDataArray objectAtIndex:14] intValue];
    isRandom = [[lightDataArray objectAtIndex:15] intValue];
    hold = [[lightDataArray objectAtIndex:16] intValue];
    pause = [[lightDataArray objectAtIndex:17] intValue];
    isVibrate = [[lightDataArray objectAtIndex:18] intValue];
    loop = [[lightDataArray objectAtIndex:19] intValue];
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    
    //set update configuration
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    
    int appId = 0;
    
    if(rowIndex == 0)
    {
        appId = 0x1;
    }
    else if(rowIndex == 1)
    {
        appId = 0x1;
    }
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
    }
    
    NSLog(@"callsNotificationIsSilent=%@",notificationIsSilent);
    
    int silent;
    
    silent = [notificationIsSilent[rowIndex] intValue];

    
    NSLog(@"appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
//    [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:loop];

    
}

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    //[super contextMenuCellDidSelectDeleteOption:cell];
    [cell.superview sendSubviewToBack:cell];
    self.customEditing = NO;
    
    //self.rowsCount -= 1;
    
    NSLog(@"cell index = %d",[self.notificationTableView indexPathForCell:cell].row);
    [notificationTitles removeObjectAtIndex:[self.notificationTableView indexPathForCell:cell].row];
    [notificationImages removeObjectAtIndex:[self.notificationTableView indexPathForCell:cell].row];
    [notificationIsSilent removeObjectAtIndex:[self.notificationTableView indexPathForCell:cell].row];
    
    [notificationTitles writeToFile:[FilePath callsNotificationTitleFilePath] atomically:YES];
    [notificationImages writeToFile:[FilePath callsNotificationImageFilePath] atomically:YES];
    [notificationIsSilent writeToFile:[FilePath callsNotificationIsSilentFilePath] atomically:YES];
    
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
