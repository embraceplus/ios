//
//  SettingsViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

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
    aboutLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    
    CGRect chooseLabelFarme = aboutLabel.frame;
    chooseLabelFarme.origin.y = 7 + deltaY;

    aboutLabel.frame = chooseLabelFarme;
    
    scroll=[[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //scroll.pagingEnabled=NO;
    scroll.bounces=YES;
    scroll.delegate=self;
    scroll.showsHorizontalScrollIndicator=NO;
    scroll.showsVerticalScrollIndicator=NO;
    scroll.frame = CGRectMake(0, 49+deltaY, 320, [[UIScreen mainScreen] bounds].size.height);
    scroll.contentInset = UIEdgeInsetsMake(0, 0, 40.0, 0);
    [self.view addSubview:scroll];
    
    UIImageView *imageView;
    imageView=[[UIImageView alloc]init];
    imageView.image=[UIImage imageNamed:@"UI_Help_AboutUs.png"];
    imageView.frame = CGRectMake(0, 0, imageView.image.size.width/2.0, imageView.image.size.height/2.0);
    
    scroll.contentSize= CGSizeMake(imageView.image.size.width/2.0, imageView.image.size.height/2.0);
    [scroll addSubview:imageView];

 
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  

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

@end
