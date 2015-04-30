//
//  ConnectingViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-13.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "ConnectingViewController.h"

@interface ConnectingViewController ()

@end

@implementation ConnectingViewController
@synthesize indicatorView;
@synthesize connectedLabel;
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
    // Do any additional setup after loading the view from its nib.
    scanLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:22];
    embraceLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:19];
    successLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:18];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
//    indicatorView = [[TFIndicatorView alloc]initWithFrame:CGRectMake(108, 100, 50, 50)];
    
    indicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(108, 100, 50, 50)];
    
    [indicatorView startAnimating];
    [self.view addSubview:indicatorView];

    [self.view setBackgroundColor:[UIColor colorWithRed:66.0/255.0 green:59.0/255.0 blue:81.0/255.0 alpha:1.0]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [indicatorView removeFromSuperview];
    //[indicatorView stopAnimating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
