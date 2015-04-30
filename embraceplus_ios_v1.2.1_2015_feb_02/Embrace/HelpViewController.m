//
//  SettingsViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpContentViewController.h"
@implementation HelpViewController

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
    helpLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    
    CGRect chooseLabelFrame = helpLabel.frame;
    chooseLabelFrame.origin.y = 7 + deltaY;
    helpLabel.frame = chooseLabelFrame;

    helpTableView.contentInset = UIEdgeInsetsMake(0, 0, 90.0, 0);
    helpTitleArray =  [[NSArray alloc]  initWithObjects:
                       @"Welcome to Embrace+",
                       @"How to get started",
                       @"Mute notifications",
                       @"Configure light effects",
                       @"Configure calls feature",
                       @"Configure clock features",
                       @"Configure calendar",
                       @"Other info notifications",
                       @"Important iOS settings",
                       @"Important third-party app settings",
                       @"Themes",
                       @"Connecting a new band",
                       @"Troubleshooter",
                       nil];

    helpTableView.separatorColor = [UIColor clearColor];
    helpTableView.frame = CGRectMake(0, 52 + deltaY, 320, (59*7) + deltaY);
    if (iPhone5)
        helpTableView.frame = CGRectMake(0, 52 + deltaY, 320, (59*8) + deltaY);
    else if (iPhone6)
        helpTableView.frame = CGRectMake(0, 52 + deltaY, 320, (59*9) + deltaY);
        else if (iPhone6plus)
            helpTableView.frame = CGRectMake(0, 52 + deltaY, 320, (59*10) + deltaY);
    //    if (iPhone5) {
    //        helpTableView.frame = CGRectMake(0, 52 + deltaY, 320, 548 + deltaY - 52);
    //    }else
    //    {
    //        helpTableView.frame = CGRectMake(0, 52 + deltaY, 320, 548 + deltaY - 52);
    //    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backgroundImageView.image = appDelegate.backgroundImage;
    

}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    return 13;
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
        [[cell viewWithTag:101] removeFromSuperview];
    }
    
    // Configure the cell...
	cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:18];
    //[cell.textLabel setFont:[UIFont boldSystemFontOfSize:18]];
	cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.textLabel.text = [helpTitleArray objectAtIndex:indexPath.row];
	cell.indentationLevel = 2.0f;
	cell.indentationWidth = 30;
	
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.alpha = 1;
    
    UIImageView* accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notification_cell_arrow"]];
	accessoryView.frame = CGRectMake(290, 25-12, 13, 30);  // @ME
	[cell addSubview:accessoryView];
	[accessoryView release];
    
    
    UIImageView* cellLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separateLine"]];
    if (iPhone5) {
        cellLine.frame = CGRectMake(66, 57, 254, 2);
    }
    else
        cellLine.frame = CGRectMake(71, 56, 249, 2);
    cellLine.tag = 101;
    [cell addSubview:cellLine];
	//[cellLine release];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    currentHelpIndex = indexPath.row;
    [self performSegueWithIdentifier:@"helpcontent" sender:self];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"helpcontent"])
	{
        HelpContentViewController *helpContentViewController = segue.destinationViewController;
        helpContentViewController.currentHelpIndex = currentHelpIndex;
       
	}
    
}
@end
