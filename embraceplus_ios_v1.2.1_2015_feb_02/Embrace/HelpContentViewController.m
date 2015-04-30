//
//  Help1ContentViewController.m
//  Embrace ios7
//
//  Created by Jim on 14-5-10.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import "HelpContentViewController.h"

@interface HelpContentViewController ()

@end


@implementation HelpContentViewController
@synthesize currentHelpIndex;
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
    
	// Do any additional setup after loading the view.
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    helpLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    
    nextButton.frame = CGRectMake(248, 8 + deltaY, 65, 34);
    nextButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];


    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    
    CGRect chooseLabelFrame = helpLabel.frame;
    chooseLabelFrame.origin.y = 7 + deltaY;
    chooseLabelFrame.size.width = self.view.bounds.size.width - backButton.frame.size.width - nextButton.frame.size.width - 15;
    chooseLabelFrame.origin.x = backButton.frame.origin.x + backButton.frame.size.width + 5;
    
    helpLabel.frame = chooseLabelFrame;
    helpLabel.textAlignment = NSTextAlignmentCenter;
    
    helpContentName = [[NSArray alloc]initWithObjects:
                       @"UI_Help_Welcome-to-embraceplus.png" ,
                       @"UI_Help_HowToGetStarted.png" ,
                       @"UI_Help_Mute-notifications.png" ,
                       @"UI_Help_Configure-light-effects.png",
                       @"UI_Help_Configure-calls-features.png",
                       @"UI_Help_Configure-clock-features.png",
                       @"UI_Help_Configure-calendar.png",
                       @"UI_Help_Other-info-notifications.png",
                       @"UI_Help_Important-iOS-Settings.png",
                       @"UI_Help_Important-thirdparty-settings.png",
                       @"UI_Help_Themes.png" ,
                       @"UI_Help_Connecting-a-new-band.png" ,
                       @"UI_Help_Troubleshooter.png" ,
                       nil];
    
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
    
    scrollView=[[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //scroll.pagingEnabled=NO;
    scrollView.bounces=YES;
    scrollView.delegate=self;
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.frame = CGRectMake(0, 49+deltaY, 320, [[UIScreen mainScreen] bounds].size.height-49-deltaY);
    [self.view addSubview:scrollView];
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 40.0, 0);

    UIImageView *imageView;
    imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:[helpContentName objectAtIndex:currentHelpIndex]];
    
    imageView.frame = CGRectMake(0, 0, imageView.image.size.width/2.0, imageView.image.size.height/2.0);
    scrollView.contentSize=CGSizeMake(imageView.image.size.width/2.0, imageView.image.size.height/2.0);
    [scrollView addSubview:imageView];
    
#pragma mark - kane
    if(self.currentHelpIndex == helpTitleArray.count-1)
    {
        self.isLast = YES;
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backgroundImageView.image = appDelegate.backgroundImage;

    helpLabel.text = [helpTitleArray objectAtIndex:currentHelpIndex];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)next:(id)sender
{
    if(self.isLast)
    {
        [self back:nil];
        return;
    }
    if(currentHelpIndex == helpTitleArray.count-1)
    {
        [self back:nil];
        return;
    }
    
    else
        currentHelpIndex ++;
    
    NSArray *viewsToRemove = [scrollView subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];

    UIImageView *imageView;
    imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:[helpContentName objectAtIndex:currentHelpIndex]];
    imageView.frame = CGRectMake(0, 0, imageView.image.size.width/2.0, imageView.image.size.height/2.0);
    scrollView.contentSize=CGSizeMake(imageView.image.size.width/2.0, imageView.image.size.height/2.0);
    [scrollView addSubview:imageView];
    
    helpLabel.text = [helpTitleArray objectAtIndex:currentHelpIndex];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
