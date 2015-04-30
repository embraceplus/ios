//
//  SettingsViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "SettingsViewController.h"
#import "ChooseStyleViewController.h"
#import "LeEmbraceService.h"
#import "LeDiscovery.h"
#import "NotificationUtility.h"
extern bool isNoChooseStyleViewController;
bool isFromSettingView;
@interface SettingsViewController ()<LeEmbraceBatteryProtocol>

@end

// int batteryLevelTable[12]  = {300,345,368,374,377,379,382,387,392,398,406,420};

@implementation SettingsViewController
@synthesize styleIndex;
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
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
	// Do any additional setup after loading the view.
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    settingLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    notificationTableView.separatorColor = [UIColor clearColor];
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    notificationTableView.frame = CGRectMake(0, 52 + deltaY, 320, 477);
    
    
    CGRect chooseLabelFarme = settingLabel.frame;
    chooseLabelFarme.origin.y += 20;
    
    settingLabel.frame = chooseLabelFarme;

    isFromSettingView = true;
    
    viewControllers = [[NSArray alloc] initWithObjects:@"  Themes", /*@"  LANGUAGES",*/ @"  Notifications",
                       @"  Embrace+ battery",@"  About", @"  Help", nil];
    
    indexImages = [[NSArray alloc] initWithObjects:@"styleIcon", /*@"languageIcon",*/ @"notificationIcon",@"icon-batteryStateEmbrace", @"aboutIcon", @"helpIcon",nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEmbraceBatteryInfo:)  name:@"batteryLevelNotification" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backgroundImageView.image = appDelegate.backgroundImage;
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    
    [service getBatteryLevel];

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
    return [viewControllers count];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, notificationTableView.frame.size.width, 50)] autorelease];
    return footerView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier: CellIdentifier] autorelease];
        
    }
    else
    {
        [[cell viewWithTag:100] removeFromSuperview];
        [[cell viewWithTag:101] removeFromSuperview];
        [[cell viewWithTag:102] removeFromSuperview];
    }
    
    // Configure the cell...
	cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:18];
    //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
	cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = [viewControllers objectAtIndex:indexPath.row];
	cell.indentationLevel = 2.0f;
	cell.indentationWidth = 30;
	

    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[indexImages objectAtIndex:indexPath.row]]];
    icon.tag = 102;
    if (iPhone5)
        icon.frame = CGRectMake(18, 8, 43, 43);
    else
        icon.frame = CGRectMake(18, 7, 43, 43);
	[cell addSubview:icon];
	[icon release];
    
	UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification_cell_arrow"]];
	accessoryView.frame = CGRectMake(290, 25-12, 13, 30); // @ME
	[cell addSubview:accessoryView];
	[accessoryView release];
    
    
    if (indexPath.row == 1) {
        UISwitch *notificationSwitch = [[UISwitch alloc]init];
        [notificationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        CGRect frame = notificationSwitch.frame;
        frame.origin.x = 248.0;
        frame.origin.y = 10.0;
        notificationSwitch.frame = frame;
        notificationSwitch.on = YES;
        accessoryView.hidden = YES;
        notificationSwitch.tag  = 101;
        [cell.contentView addSubview:notificationSwitch];
        [notificationSwitch release];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
        NSNumber *globleNotificationSwitchStatus = [ud objectForKey:@"globleNotificationSwitchStatus"];
        
        if(globleNotificationSwitchStatus!=nil)
        {
            [notificationSwitch setOn:[globleNotificationSwitchStatus boolValue]];
        }
        else
        {
            [notificationSwitch setOn:YES];
        }
    }
    else if (indexPath.row == 2)
    {
        UILabel *batteryLevelLabel = [[UILabel alloc]init];
        batteryLevelLabel.frame = CGRectMake(194.0f, 10.0f, 100.0f, 44.0f);;
        [batteryLevelLabel setBackgroundColor:[UIColor whiteColor]];
        accessoryView.hidden = YES;
        if(batteryLevel!=0)
            batteryLevelLabel.text = [NSString stringWithFormat:@"%d%%",[self convertVoltageToPercentage:batteryLevel]];
        batteryLevelLabel.textColor = [UIColor whiteColor];
        batteryLevelLabel.textAlignment = UITextAlignmentRight;
        batteryLevelLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
        batteryLevelLabel.backgroundColor = [UIColor clearColor];
        batteryLevelLabel.tag  = 100;
        [cell.contentView addSubview:batteryLevelLabel];
        [batteryLevelLabel release];

        
    }
	UIImageView* cellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
    if (iPhone5) {
        cellLine.frame = CGRectMake(66, 57, 254, 2);
    }
    else
        cellLine.frame = CGRectMake(71, 56, 249, 2);
    [cell addSubview:cellLine];
	[cellLine release];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}


- (IBAction)switchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:isButtonOn] forKey:@"globleNotificationSwitchStatus"];
    
    //turn on/off the default effect if there is any
    [NotificationUtility allNotificationSwitched:styleIndex status:isButtonOn];
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	//UIViewController* viewController = nil;
    switch (indexPath.row) {
        case 0:
        {
            UIViewController * viewController;
            
            viewController = [self.navigationController.viewControllers objectAtIndex:1];
            
            if([viewController isKindOfClass:[ChooseStyleViewController class]])
            {
                NSLog(@"ChooseStyleViewController");
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]
                                                      animated:YES];
            }
            else
            {
                //pop up all the controller
                [self.navigationController popToRootViewControllerAnimated:NO];
                 
                appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                
                appDelegate.isNoChooseStyleViewController = true;

                NSLog(@"not ChooseStyleViewController");
            }
            
        }
    
            break;
            
        case 3:
            
            [self performSegueWithIdentifier:@"about" sender:self];

            break;
        case 4:
            
            [self performSegueWithIdentifier:@"help" sender:self];

            break;
            

        default:
            break;
    }
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{


}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateEmbraceBatteryInfo:(NSNotification *)notification
{
    //NSLog(@"reveived battery level");
    NSNumber *batteryNum = [notification object];
    
    batteryLevel = [batteryNum intValue];
    [notificationTableView reloadData];
}

-(int)convertVoltageToPercentage:(int)value
{
    NSLog(@"Battery Volt: %d",value);
    int batteryValue = 0;

    if (value>=400) { batteryValue = 100;
    } else if (value>=395){ batteryValue = 90;
    } else if (value>=390) { batteryValue = 80;
    } else if (value>=385){ batteryValue = 70;
    } else if (value>=380){ batteryValue = 60;
    } else if (value>=375){ batteryValue = 50;
    } else if (value>=370){ batteryValue = 40;
    } else if (value>=365){ batteryValue = 30;
    } else if (value>=360){ batteryValue = 20;
    } else if (value>=355){ batteryValue = 10;
    } else if (value>=350) { batteryValue = 3;
    }
    
    return batteryValue;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
