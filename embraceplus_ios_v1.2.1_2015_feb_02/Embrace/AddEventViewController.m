//
//  AddEventViewController.m
//  Embrace
//
//  Created by s1 dred on 13-9-5.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "AddEventViewController.h"
#import "NotificationUtility.h"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (NSString *)notificationTitleFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"notificationTitle.plist"];
}


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
    
    NSLog(@"viewDidLoad!!!!!!!!!!!!!!!!!!!!");
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    
    if (iPhone5) {
        addEventTableView.frame = CGRectMake(0, 52+ deltaY, 320, 477);
    }else
    {
        addEventTableView.frame = CGRectMake(0, 52+ deltaY, 320, 425);
    }
   
    CGRect addEventLabelFarme = addEventLabel.frame;
    addEventLabelFarme.origin.y =7+ deltaY;
    addEventLabel.frame = addEventLabelFarme;
    
    notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[self notificationTitleFilePath]];
    
    viewControllers = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"  %@", callsNotificationString],[NSString stringWithFormat:@"  %@", textNotificationString],[NSString stringWithFormat:@"  %@", clockNotificationString],[NSString stringWithFormat:@"  %@", calendarNotificationString],[NSString stringWithFormat:@"  %@", batteryPhoneNotificationString],[NSString stringWithFormat:@"  %@", facebookNotificationString],[NSString stringWithFormat:@"  %@", twitterNotificationString],[NSString stringWithFormat:@"  %@", instagramNotificationString],[NSString stringWithFormat:@"  %@", tumblrNotificationString],[NSString stringWithFormat:@"  %@", skypeNotificationString],[NSString stringWithFormat:@"  %@", linkedinNotificationString],[NSString stringWithFormat:@"  %@", whatsappNotificationString],[NSString stringWithFormat:@"  %@", facetimeNotificationString],[NSString stringWithFormat:@"  %@", viberNotificationString],[NSString stringWithFormat:@"  %@", pinterestNotificationString],[NSString stringWithFormat:@"  %@", fourSquareNotificationString],[NSString stringWithFormat:@"  %@", emailNotificationString],[NSString stringWithFormat:@"  %@", phoneOutOfRangeNotificationString],[NSString stringWithFormat:@"  %@", batteryEmbraceNotificationString],nil];
    
    indexImages = [[NSArray alloc] initWithObjects:@"callIcon",@"smsIcon",@"clockIcon",@"calendarIcon",@"batteryIcon",@"facebook", @"twitter", @"instagram", @"tumblr", @"skype",
                   @"linkedin",@"whatsapp",@"facetime", @"viber", @"pinterest", @"foursquare", /*@"scrabble",*/@"email",@"phoneOutOfRange",@"batteryLowEmbrace",nil];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    
    addEventTableView.separatorColor = [UIColor clearColor];
    addEventLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    backgroundImageView.image = appDelegate.backgroundImage;

}


- (IBAction)backButton:(id)sender
{
   [self.navigationController popViewControllerAnimated:YES];
    //[self.delegate backNotificationViewController:self];
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
    
    //NSString *notificationTitle;
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIImageView* icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[indexImages objectAtIndex:indexPath.row]]];
    if (iPhone5)
        icon.frame = CGRectMake(18, 8, 43, 43);
    else
        icon.frame = CGRectMake(18, 7, 43, 43);
    
    //icon.opaque = 0.4;
    icon.tag = 100;
    
    cell.textLabel.alpha = 1;
    icon.alpha = 1;

    
    for(int i =0; i< [notificationTitles count]; i++)
    {
//        NSLog(@"%@",[notificationTitles objectAtIndex:i]);
//        NSLog(@"%@",viewControllers[indexPath.row]);
//        NSLog(@"%@",[viewControllers objectAtIndex:indexPath.row]);
        //去掉头尾空白后的字符串
        NSString *s2 = [viewControllers[indexPath.row] stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceCharacterSet]];
        
        NSString *s1 = [[notificationTitles objectAtIndex:i] stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
        //NSLog(@"%@",(NSString *)[notificationTitles objectAtIndex:i]);
        if([s1 isEqualToString:s2])
        {
            cell.textLabel.alpha = 0.4;
            icon.alpha = 0.4;
            
            break;
        }
        
    }
    
	[cell addSubview:icon];
	[icon release];
    
    UIImageView* cellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
    if (iPhone5) {
        cellLine.frame = CGRectMake(66, 57, 254, 2);
    }
    else
        cellLine.frame = CGRectMake(71, 56, 249, 2);
    cellLine.tag = 101;
    [cell addSubview:cellLine];
	[cellLine release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
    NSString *imageName;
    NSString *notificationTitle;
    
    notificationTitle = viewControllers[indexPath.row];
    imageName = indexImages[indexPath.row];
    
    
    NSLog(@"%@",notificationTitle);
    //if it is already added in the list, do nothing
    for(int i =0; i< [notificationTitles count]; i++)
    {
        NSString *s2 = [viewControllers[indexPath.row] stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
        
        NSString *s1 = [[notificationTitles objectAtIndex:i] stringByTrimmingCharactersInSet:
                        [NSCharacterSet whitespaceCharacterSet]];
        NSLog(@"%@",(NSString *)[notificationTitles objectAtIndex:i]);
        if([s1 isEqualToString:s2])
        {
            return;
        }
    }
    [self.delegate backNotificationViewControllerFromAddEvent:self iconImagePath:imageName notificationTitle:notificationTitle];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
    [addEventLabel release];
    [addEventTableView release];
    [backgroundImageView release];
    [backButton release];
    [line1 release];
    
    [viewControllers release];
    [indexImages release];
}
@end
