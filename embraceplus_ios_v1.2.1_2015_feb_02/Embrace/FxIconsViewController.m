//
//  FxIconsViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-20.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "FxIconsViewController.h"
#import "Cell.h"

NSString *iconCellID = @"iconCellID";
#define ICONSPACE 7
@interface FxIconsViewController ()

@end

@implementation FxIconsViewController
@synthesize delegate;
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
    fxIconLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];

    imageNameArray = [[NSMutableArray alloc] initWithObjects:@"Meeting", @"Workout", @"After Work", @"Chat", @"Heartbeat",
                      @"Sweet Life", @"Psychedelic", @"Bloodrush", @"Rasta", @"Electrifying", @"Nirvana",
                      @"Holy",@"Atomic", @"Outdoor", @"Nerdcore", @"Discreet", @"Toxic",
                      @"Prancing",@"Biohazard", @"Punky", @"Night Fever", @"Strobe", @"Fabulous",
                      @"Fugitive",nil];
    fxIconScrollView.delegate = self;
    fxIconScrollView.contentSize = CGSizeMake(fxIconScrollView.frame.size.width, 1130);
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    line1.frame = CGRectMake(0, 47+deltaY, 320, 2);
    //doneButton.frame = CGRectMake(248, 8, 55, 33);
    fxIconScrollView.frame = CGRectMake(0, 69, 320, 445);
    CGRect chooseLabelFarme = fxIconLabel.frame;
    chooseLabelFarme.origin.y += deltaY;
    fxIconLabel.frame = chooseLabelFarme;
    

    int iconTag = 50;
    for (int i = 0; i<24; i++) {
        UIButton *iconButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect titleButtonFrame;
        titleButtonFrame.origin.y = (i/3)*132 + ICONSPACE*((i/3) +1);
        titleButtonFrame.origin.x = (i%3) * 91 + ICONSPACE*(i%3) + 17;
        titleButtonFrame.size.width = 91;
        titleButtonFrame.size.height = 132;
        iconButton.frame = titleButtonFrame;
        iconButton.tag = iconTag +i;
        [iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [imageNameArray objectAtIndex:i]]] forState:UIControlStateNormal];
        [iconButton addTarget:self action:@selector(selectIcon:) forControlEvents:UIControlEventTouchUpInside];
        [fxIconScrollView addSubview:iconButton];
    }
    
}
static int iconIndex = 0;
- (void)selectIcon:(id)sender
{
    UIButton *colorButton = (UIButton *)sender;
    iconPickSelectImageView.hidden = NO;
    iconPickSelectImageView.center = CGPointMake(colorButton.center.x, colorButton.center.y + 66 - 4);
    iconIndex = colorButton.tag - 50;
    
    [self.delegate backFxmenuViewController:self Icon:[NSString stringWithFormat:@"%@",[imageNameArray objectAtIndex:iconIndex]]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    iconPickSelectImageView.hidden = NO;
    iconIndex = 0;
    CGPoint center = [self.view viewWithTag:50].center;
    iconPickSelectImageView.center = CGPointMake(center.x, center.y + 66 - 4);

    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    backgroundImageView.image = appDelegate.backgroundImage;
    
}

#pragma mark _
#pragma mark collectionviewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDragging = %f",scrollView.contentOffset.x);
    
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
- (void)dealloc
{
   
//    IBOutlet UIButton *backButton;
//    IBOutlet UIImageView *line1;
//    IBOutlet UILabel *fxIconLabel;
//    IBOutlet UIImageView *backgroundImageView;
//    IBOutlet UIScrollView *fxIconScrollView;
//    IBOutlet UIImageView *iconPickSelectImageView;
}

@end
