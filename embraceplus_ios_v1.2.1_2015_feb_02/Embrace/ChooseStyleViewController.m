//
//  ChooseStyleViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-13.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "ChooseStyleViewController.h"
#import "NotificationsViewController.h"
//#import "EmbLayer.h"
#import "EmbColor.h"
#import "LeDiscovery.h"
#import "FilePath.h"
#import "UIViewController+MJPopupViewController.h"
#import "SettingsViewController.h"
#import "NotificationUtility.h"
#import "Factory.h"
#import "UserInfo.h"

@interface ChooseStyleViewController ()<LeEmbraceProtocol>
//@property (nonatomic, strong) NSMutableArray *styleImages;
@end

@implementation ChooseStyleViewController

extern int selectStyleIndex;
@synthesize pageControl = _pageControl;
@synthesize connectPeripheral;
@synthesize isConnected;
@synthesize selectImageTemp;
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
    //NSLog(@"ChooseStyleViewController");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    chooseStyleLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    selectButton.titleLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath styleFxmenuTitleFilePath]])
    {
        styleTitleArray = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath styleFxmenuTitleFilePath]];
        styleImages = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath styleFxmenuImageFilePath]];
    }
    else
    {
        styleImages = [[NSMutableArray alloc] initWithObjects:@"business.png", @"fashionista.png", @"vampire.png",@"clubber.png", @"student.png", @"magician.png", @"adventurer.png", @"athlete.png", @"entertainer.png",@"addTheme.png",nil];
        

        
        styleTitleArray = [[NSMutableArray alloc] initWithObjects:@"Business", @"Fashionista", @"Vampire", @"Clubber", @"Student", @"Magician", @"Adventurer", @"Athlete",@"Entertainer",@"Add theme",nil];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[FilePath customFxConfigFilePath]])
    {
        NSMutableDictionary *customFxConfigDic;
        customFxConfigDic = [[NSMutableDictionary alloc]initWithCapacity:6];
    
        
        for(int i = 0;i < [styleTitleArray count]; i++)
        {
            NSMutableArray *customFxConfigArray = [[NSMutableArray alloc] init];
            [customFxConfigDic setObject: customFxConfigArray forKey:[NSString stringWithFormat:@"style%d",i]] ;
        }
        [customFxConfigDic writeToFile:[FilePath customFxConfigFilePath] atomically:YES];
        
        [customFxConfigDic release];
    }

    
    
    fxForStyleDic = [[NSMutableDictionary alloc]init];
    fxMenuLightDataDic = [[NSMutableDictionary alloc]init];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
    }
    else
    {
        NSArray *busTitleArray = [NSArray arrayWithObjects:@"Meeting",@"Nirvana",@"After Work",@"Chat",@"Discreet",@"Workout", nil];
        NSArray *fasTitleArray = [NSArray arrayWithObjects:@"Fabulous",@"Heartbeat",@"Sweet Life",@"Chat",@"Night Fever",@"Holy", nil];
        NSArray *vamTitleArray = [NSArray arrayWithObjects:@"Heartbeat",@"Night Fever",@"Bloodrush",@"Electrifying",@"Fugitive",@"Strobe", nil];
        NSArray *cluTitleArray = [NSArray arrayWithObjects:@"Nerdcore",@"Electrifying",@"Heartbeat",@"Night Fever",@"Punky",@"Strobe", nil];
        NSArray *stuTitleArray = [NSArray arrayWithObjects:@"Chat",@"Discreet",@"Meeting",@"Fabulous",@"Night Fever",@"Strobe", nil];
        NSArray *magTitleArray = [NSArray arrayWithObjects:@"Fabulous",@"Nirvana",@"Electrifying",@"Psychedelic",@"Heartbeat",@"Atomic", nil];
        NSArray *advTitleArray = [NSArray arrayWithObjects:@"Outdoor",@"Atomic",@"Biohazard",@"Toxic",@"Heartbeat",@"Prancing", nil];
        NSArray *athTitleArray = [NSArray arrayWithObjects:@"After Work",@"Workout",@"Heartbeat",@"Outdoor",@"Electrifying",@"Toxic", nil];
        NSArray *entTitleArray = [NSArray arrayWithObjects:@"Fabulous",@"Strobe",@"Night Fever",@"Prancing",@"Punky",@"Rasta", nil];
        NSArray *totalTitleArray = [NSArray arrayWithObjects:busTitleArray,fasTitleArray,vamTitleArray,cluTitleArray,stuTitleArray,magTitleArray,advTitleArray,athTitleArray,entTitleArray, nil];
        
        NSArray *busImageArray = [NSArray arrayWithObjects:@"Meeting",@"Nirvana",@"After Work",@"Chat",@"Discreet",@"Workout", nil];
        NSArray *fasImageArray = [NSArray arrayWithObjects:@"Fabulous",@"Heartbeat",@"Sweet Life",@"Chat",@"Night Fever",@"Holy", nil];
        NSArray *vamImageArray = [NSArray arrayWithObjects:@"Heartbeat",@"Night Fever",@"Bloodrush",@"Electrifying",@"Fugitive",@"Strobe", nil];
        NSArray *cluImageArray = [NSArray arrayWithObjects:@"Nerdcore",@"Electrifying",@"Heartbeat",@"Night Fever",@"Punky",@"Strobe", nil];
        NSArray *stuImageArray = [NSArray arrayWithObjects:@"Chat",@"Discreet",@"Meeting",@"Fabulous",@"Night Fever",@"Strobe", nil];
        NSArray *magImageArray = [NSArray arrayWithObjects:@"Fabulous",@"Nirvana",@"Electrifying",@"Psychedelic",@"Heartbeat",@"Atomic", nil];
        NSArray *advImageArray = [NSArray arrayWithObjects:@"Outdoor",@"Atomic",@"Biohazard",@"Toxic",@"Heartbeat",@"Prancing", nil];
        NSArray *athImageArray = [NSArray arrayWithObjects:@"After Work",@"Workout",@"Heartbeat",@"Outdoor",@"Electrifying",@"Toxic", nil];
        NSArray *entImageArray = [NSArray arrayWithObjects:@"Fabulous",@"Strobe",@"Night Fever",@"Prancing",@"Punky",@"Rasta", nil];
        NSArray *totalImageArray = [NSArray arrayWithObjects:busImageArray,fasImageArray,vamImageArray,cluImageArray,stuImageArray,magImageArray,advImageArray,athImageArray,entImageArray, nil];
        
        
        for (int i = 0; i < 9; i++) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
            [dictionary setObject:[totalTitleArray objectAtIndex:i] forKey:@"title"];
            [dictionary setObject:[totalImageArray objectAtIndex:i] forKey:@"image"];
            [fxForStyleDic setObject:dictionary forKey:[NSString stringWithFormat:@"%d",i]];
            
            
            //set default notification effect index!!!!!!!!!!!!!
            //the default fx index is not 0????????????
            NSMutableDictionary *notificationDictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
            
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",200]];
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",201]];
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",200]];
            
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",100]];
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",101]];
            
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",1]];
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",2]];
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",3]];
            [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",4]];
            
            
            
            [fxForStyleDic setObject:notificationDictionary forKey:[NSString stringWithFormat:@"style%d",i]];
        }
        [fxForStyleDic writeToFile:[FilePath fxForStyleFilePath] atomically:YES];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }
    else
    {
        //r =256 stands for transparent 
        //frome/to L: R,G,B,    frome/to R: R,G,B  duration1 dutation2  blackout random hold pause vibrate loop
        NSArray *afterworkLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],@"256",@"0",@"0",@"256",@"0",@"0",[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],@"1500", @"1500",@"0",@"0",@"0",@"0",@"1",@"1",nil];  //after work
        
        NSArray *atomicLight = [NSArray arrayWithObjects:[EmbColor getColor:emOrange.r],[EmbColor getColor:emOrange.g],[EmbColor getColor:emOrange.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emOrange.r],[EmbColor getColor:emOrange.g],[EmbColor getColor:emOrange.b],@"2000",@"2000",@"0",@"0",@"0",@"0",@"1",@"1", nil];
        
        NSArray *bioLight = [NSArray arrayWithObjects:[EmbColor getColor:emGreen_Acid.r],[EmbColor getColor:emGreen_Acid.g],[EmbColor getColor:emGreen_Acid.b],@"256",@"0",@"0",[EmbColor getColor:emGreen_Acid.r],[EmbColor getColor:emGreen_Acid.g],[EmbColor getColor:emGreen_Acid.b],@"256",@"0",@"0", @"500",@"0",@"0",@"0",@"0",@"0",@"1",@"6",nil];
        
        NSArray *bloodrushLight = [NSArray arrayWithObjects:[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b],[EmbColor getColor:emPink_red.r],[EmbColor getColor:emPink_red.g],[EmbColor getColor:emPink_red.b],[EmbColor getColor:emPink_red.r],[EmbColor getColor:emPink_red.g],[EmbColor getColor:emPink_red.b],[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b], @"200",@"200",@"0",@"0",@"0",@"0",@"1",@"8", nil];
        
        NSArray *chatLight = [NSArray arrayWithObjects:[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],@"256",@"0",@"0",[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],@"256",@"0",@"0", @"600",@"0",@"0", @"0",@"0",@"0",@"1",@"5",nil];
        
        NSArray *discreetLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue_Sky.r],[EmbColor getColor:emBlue_Sky.g],[EmbColor getColor:emBlue_Sky.b],@"256",@"0",@"0",[EmbColor getColor:emBlue_Sky.r],[EmbColor getColor:emBlue_Sky.g],[EmbColor getColor:emBlue_Sky.b],@"256",@"0",@"0", @"1000",@"0",@"0",@"0",@"0",@"0",@"1",@"3",nil];
        
        NSArray *electrifyingLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue_Sky.r],[EmbColor getColor:emBlue_Sky.g],[EmbColor getColor:emBlue_Sky.b],[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b],[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b],[EmbColor getColor:emBlue_Sky.r],[EmbColor getColor:emBlue_Sky.g],[EmbColor getColor:emBlue_Sky.b],@"100",@"100",@"0", @"0",@"0",@"0",@"1",@"10",nil];

        NSArray *fabulousLight = [NSArray arrayWithObjects:[EmbColor getColor:emGold.r],[EmbColor getColor:emGold.g],[EmbColor getColor:emGold.b],[EmbColor getColor:emPink_light.r],[EmbColor getColor:emPink_light.g],[EmbColor getColor:emPink_light.b],[EmbColor getColor:emPink_light.r],[EmbColor getColor:emPink_light.g],[EmbColor getColor:emPink_light.b],[EmbColor getColor:emGold.r],[EmbColor getColor:emGold.g],[EmbColor getColor:emGold.b], @"1000",@"1000",@"0",@"0",@"0", @"0",@"1",@"3",nil];
        
        
        NSArray *fugitiveLight = [NSArray arrayWithObjects:[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b],[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b], @"300",@"300",@"0",@"0",@"0",@"0",@"1",@"10",nil];
        
        NSArray *heartbeatLight = [NSArray arrayWithObjects:[EmbColor getColor:emRed_Blood.r],[EmbColor getColor:emRed_Blood.g],[EmbColor getColor:emRed_Blood.b],@"256",@"0",@"0",[EmbColor getColor:emRed_Blood.r],[EmbColor getColor:emRed_Blood.g],[EmbColor getColor:emRed_Blood.b],@"256",@"0",@"0", @"400",@"0",@"0",@"0",@"0",@"0",@"1",@"7",nil];

        NSArray *holyLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b],[EmbColor getColor:emWHITE.r],[EmbColor getColor:emWHITE.g],[EmbColor getColor:emWHITE.b],[EmbColor getColor:emWHITE.r],[EmbColor getColor:emWHITE.g],[EmbColor getColor:emWHITE.b],[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b], @"2000",@"2000",@"0",@"0",@"0",@"0",@"1",@"1",nil];
        
        NSArray *meetingLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],@"256",@"0",@"0",[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],@"256",@"0",@"0", @"2000",@"0",@"0", @"0",@"0",@"0",@"1",@"1",nil];
        
        NSArray *nerdcoreLight = [NSArray arrayWithObjects:[EmbColor getColor:emPurple.r],[EmbColor getColor:emPurple.g],[EmbColor getColor:emPurple.b],@"256",@"0",@"0",[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b],@"256",@"0",@"0", @"100",@"0",@"0",@"0",@"0",@"0",@"1",@"30",nil];
        
        NSArray *nightfeverLight = [NSArray arrayWithObjects:[EmbColor getColor:emPink.r],[EmbColor getColor:emPurple.g],[EmbColor getColor:emPurple.b],@"256",@"0",@"0",[EmbColor getColor:emPurple.r],[EmbColor getColor:emPurple.g],[EmbColor getColor:emPurple.b],@"256",@"0",@"0", @"500",@"0",@"0",@"0",@"0",@"0",@"1",@"6",nil];
        
        NSArray *nirvanaLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b],@"256",@"0",@"0",@"256",@"0",@"0",[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b], @"1500",@"1500",@"0",@"0",@"0",@"0",@"1",@"1",nil];

        NSArray *outdoorLight = [NSArray arrayWithObjects:[EmbColor getColor:emGreen.r],[EmbColor getColor:emGreen.g],[EmbColor getColor:emGreen.b],[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b],[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.b],[EmbColor getColor:emGreen.r],[EmbColor getColor:emGreen.g],[EmbColor getColor:emGreen.b], @"1000",@"1000",@"0",@"0",@"0",@"0",@"1",@"1",nil];
        
        NSArray *prancingLight = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", @"500",@"0",@"0",@"1",@"0",@"0",@"1",@"6",nil];//prancing
        
        NSArray *psychedelicLight = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", @"2000",@"0",@"0",@"1",@"0",@"0",@"1",@"2", nil];//psychedelic
        
        NSArray *punkLight = [NSArray arrayWithObjects:[EmbColor getColor:emOrange.r],[EmbColor getColor:emOrange.g],[EmbColor getColor:emOrange.b],[EmbColor getColor:emPurple.r],[EmbColor getColor:emPurple.g],[EmbColor getColor:emPurple.b],[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b],[EmbColor getColor:emBlue_Light.r],[EmbColor getColor:emBlue_Light.g],[EmbColor getColor:emBlue_Light.r], @"200",@"0",@"0", @"0",@"0",@"0",@"1",@"10",nil];
        
        NSArray *rastaLight = [NSArray arrayWithObjects:[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b],[EmbColor getColor:emGreen.r],[EmbColor getColor:emGreen.g],[EmbColor getColor:emGreen.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b], @"1500",@"0",@"0",@"0",@"0",@"0",@"1",@"2",nil];
        
        NSArray *strobeLight = [NSArray arrayWithObjects:[EmbColor getColor:emWHITE.r],[EmbColor getColor:emWHITE.g],[EmbColor getColor:emWHITE.b],@"256",@"0",@"0",[EmbColor getColor:emWHITE.r],[EmbColor getColor:emWHITE.g],[EmbColor getColor:emWHITE.b],@"256",@"0",@"0", @"100",@"0",@"0", @"0",@"0",@"0",@"1",@"30",nil];
        
        NSArray *sweetlifeLight = [NSArray arrayWithObjects:[EmbColor getColor:emPink.r],[EmbColor getColor:emPink.g],[EmbColor getColor:emPink.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emPink.r],[EmbColor getColor:emPink.g],[EmbColor getColor:emPink.b], @"1000",@"1000",@"0",@"0",@"0",@"0",@"1",@"2",nil];
        
        NSArray *toxicLight = [NSArray arrayWithObjects:[EmbColor getColor:emGreen.r],[EmbColor getColor:emGreen.g],[EmbColor getColor:emGreen.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emYellow.r],[EmbColor getColor:emYellow.g],[EmbColor getColor:emYellow.b],[EmbColor getColor:emGreen.r],[EmbColor getColor:emGreen.g],[EmbColor getColor:emGreen.b], @"1500",@"1500",@"0",@"0",@"0",@"0",@"1",@"1",nil];

        NSArray *workoutLight = [NSArray arrayWithObjects:[EmbColor getColor:emBlue.r],[EmbColor getColor:emBlue.g],[EmbColor getColor:emBlue.b],[EmbColor getColor:emPurple.r],[EmbColor getColor:emPurple.g],[EmbColor getColor:emPurple.b],[EmbColor getColor:emOrange.r],[EmbColor getColor:emOrange.g],[EmbColor getColor:emOrange.b],[EmbColor getColor:emRed.r],[EmbColor getColor:emRed.g],[EmbColor getColor:emRed.b], @"800",@"0",@"0", @"0",@"0",@"0",@"1",@"4",nil];
        
        NSMutableArray *lightForFxMenuArray = [NSMutableArray arrayWithObjects:afterworkLight,atomicLight,bioLight,bloodrushLight,chatLight,discreetLight,electrifyingLight,fabulousLight,fugitiveLight,heartbeatLight,holyLight,meetingLight,nerdcoreLight,nightfeverLight, nirvanaLight,outdoorLight,prancingLight,psychedelicLight,punkLight,rastaLight,strobeLight,sweetlifeLight,toxicLight,workoutLight,nil];
        
        
        NSMutableArray *fxMenuArray = [NSMutableArray arrayWithObjects:@"After Work",@"Atomic",@"Biohazard",@"Bloodrush", @"Chat",@"Discreet",@"Electrifying",@"Fabulous",@"Fugitive",@"Heartbeat",@"Holy",@"Meeting",@"Nerdcore",@"Night Fever",@"Nirvana",@"Outdoor",@"Prancing",@"Psychedelic",@"Punky",@"Rasta",@"Strobe",@"Sweet Life",@"Toxic",@"Workout",nil];

        for (int i = 0; i < 24; i++) {
            [fxMenuLightDataDic setObject:[lightForFxMenuArray objectAtIndex:i] forKey:[fxMenuArray objectAtIndex:i]];
        }
        [fxMenuLightDataDic writeToFile:[FilePath fxMenuLightDataFilePath] atomically:YES];
    }
    
    swipeView.alignment = SwipeViewAlignmentCenter;
    swipeView.pagingEnabled = YES;
    swipeView.scrollEnabled = YES;
    swipeView.wrapEnabled = NO;
    swipeView.itemsPerPage = 3;
    swipeView.truncateFinalPage = YES;
    swipeView.delegate = self;
    
    //configure page control
    _pageControl.numberOfPages = swipeView.numberOfPages;
    _pageControl.defersCurrentPageDisplay = YES;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btConnect:)  name:@"btConnectNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(btDisconnect:)  name:@"btDisconnectNotification" object:nil];
    
#pragma mark - kane
//    [FilePath initTitleDic:styleTitleArray];
//    [FilePath initImageDic:styleTitleArray];
//    [FilePath initCallsDic:styleTitleArray];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
    CGRect chooseLabelFarme = chooseStyleLabel.frame;
    chooseLabelFarme.origin.y = 2 + deltaY;
    chooseStyleLabel.frame = chooseLabelFarme;
    
    connectButton.frame = CGRectMake(18, 8 + deltaY, 34, 34);
    connectButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
    
    doneButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    doneButton.frame = CGRectMake(248, 8 + deltaY, 55, 33);
    
    actionsheetButton.frame = CGRectMake(268, 8 + deltaY, 34, 34);
    
    settingButton.frame = CGRectMake(268, 8 + deltaY, 34, 34);
    
    if([swipeView currentPage]>=3)
    {
        editStatus = 1;
        actionsheetButton.hidden = NO;
        settingButton.hidden = YES;
        doneButton.hidden = YES;
        
    }
    else
    {
        editStatus = 0;
        actionsheetButton.hidden = YES;
        settingButton.hidden = NO;
        doneButton.hidden = YES;
    }
    
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    CGRect frame = _pageControl.frame;
    
    if (iPhone5) {
        
        selectButton.frame = CGRectMake(115, 480+deltaY, 90, 30);
        swipeView.frame = CGRectMake(16, 86 + deltaY, 288, 207);
        line2.frame = CGRectMake(0, 330 + deltaY, 320, 2);
        frame.origin.y = 300 + deltaY;
        _pageControl.frame = frame;
    }
    else {
        
        selectButton.frame = CGRectMake(115, 390+deltaY, 90, 30);
        swipeView.frame = CGRectMake(16, 66 + deltaY, 288, 207);
        line2.frame = CGRectMake(0, 300 + deltaY, 320, 2);
        frame.origin.y = 270 + deltaY;
        _pageControl.frame = frame;
    }

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //get the saved "selectStyleIndex"
    NSLog(@"selectStyleIndex = %d",selectStyleIndex);
    //selectStyleIndex = 0;

    
    if([[[LeDiscovery sharedInstance] connectedServices] count] != 0)
    {
        [connectButton setImage:[UIImage imageNamed:@"btConnect.png"] forState:UIControlStateNormal];
    }
    else {
        [connectButton setImage:[UIImage imageNamed:@"btDisconnect.png"] forState:UIControlStateNormal];
    }
    

    NSMutableArray *titleArray;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
   
        NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",selectStyleIndex]];
        titleArray = [dictionary objectForKey:@"title"];
        
    }
    
    
    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:0]];
    
    /*
    int lFromR;
    int lFromG;
    int lFromB;
    
    int lToR;
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
    
    
    [EmbLayer SetEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause isSetAnimation:true];
    
    
    
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [EmbLayer switchPicture:1];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        
        [director startAnimation];
        
    }
    else
    {
        [director runWithScene:[EmbLayer scene:1]];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        
    }
     */
    
    AnimationParameter* animationParameter = [AnimationParameter createFromArray:lightDataArray];
    emulator = [EmulatorView bigEmulator:animationParameter];
    [emulator showInView:self.view];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [emulator removeFromSuperview];
    [emulator stopRuning];
//    [emulator release];
    emulator = nil;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return ceil([styleTitleArray count]/3.0)*3;
    
}
- (void)backStyleViewController:(addStyleViewController *)controller iconImagePath:(NSString *)imageName styleTitle:(NSString *)fxTitle isEdit:(BOOL)isEdit
{
    NSLog(@"array length = %d, Title = %@,imageName =%@",[styleTitleArray count],fxTitle,imageName);
    
    
    if(!isEdit)
    {
        [styleTitleArray insertObject:[NSString stringWithFormat:@"  %@",fxTitle] atIndex:[styleTitleArray count]-1];
        [styleImages insertObject:[NSString stringWithFormat:@"%@",imageName] atIndex:[styleImages count]-1];
    }
    else
    {
        [styleTitleArray replaceObjectAtIndex:selectStyleIndex withObject:[NSString stringWithFormat:@"  %@",fxTitle]];
        [styleImages replaceObjectAtIndex:selectStyleIndex withObject:[NSString stringWithFormat:@"%@",imageName]];
    }
    
    editStatus = 1;
    [styleTitleArray writeToFile:[FilePath styleFxmenuTitleFilePath] atomically:YES];
    
#pragma mark - kane
//    [FilePath addThems:[styleTitleArray objectAtIndex:styleTitleArray.count-2]];
    [styleImages writeToFile:[FilePath styleFxmenuImageFilePath] atomically:YES];
    [swipeView reloadData];
    
    swipeView.currentPage = 3;
    //add the default fx into the custom style

    NSMutableDictionary *totalDictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    
    NSMutableArray *totalTitleArray = [[NSMutableArray alloc]initWithCapacity:2];
    NSMutableArray *totalImageArray = [[NSMutableArray alloc]initWithCapacity:2];
    
    
    NSArray *effectArray = [NSArray arrayWithObjects:@"After Work",@"Atomic",@"Biohazard",@"Bloodrush", @"Chat",@"Discreet",@"Electrifying",@"Fabulous",@"Fugitive",@"Heartbeat",@"Holy",@"Meeting",@"Nerdcore",@"Night Fever",@"Nirvana",@"Outdoor",@"Prancing",@"Psychedelic",@"Punky",@"Rasta",@"Strobe",@"Sweet Life",@"Toxic",@"Workout",nil];

    
    for (int i = 0; i < 24; i++)
    {

        [totalTitleArray addObject:[effectArray objectAtIndex:i]];
        [totalImageArray addObject:[effectArray objectAtIndex:i]];
        
    }
    [totalDictionary setObject:totalImageArray forKey:@"image"];
    [totalDictionary setObject:totalTitleArray forKey:@"title"];
    
    [fxForStyleDic setObject:totalDictionary forKey:[NSString stringWithFormat:@"%d",[styleTitleArray count]-2]];

    
    NSMutableDictionary *notificationDictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    
    NSMutableArray *notificationTitles;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
    {
        
        notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
    }
    for(int i =0;i < [notificationTitles count];i++)
    {
        [notificationDictionary setObject:[NSNumber numberWithInt:0x0] forKey:[NSString stringWithFormat:@"%d",i]];
    }
    [fxForStyleDic setObject:notificationDictionary forKey:[NSString stringWithFormat:@"style%d",[styleTitleArray count]-2]];
    
    [fxForStyleDic writeToFile:[FilePath fxForStyleFilePath] atomically:YES];
	[self.navigationController popViewControllerAnimated:YES];
    
#pragma mark - kane
//    [FilePath addThems:styleTitleArray];
}

- (void)backStyleViewControllerWithoutDone
{
    editStatus = 1;
    [swipeView reloadData];
    swipeView.currentPage = ceil([styleTitleArray count]/3.0) -1;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionSheetButton:(id)sender
{
    UIActionSheet *actionSheet;
    if ([styleTitleArray count]>6) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Edit",nil];
        actionSheet.tag = 101;
        
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];

 
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {
        switch (buttonIndex) {
                NSLog(@"buttonindex = %d",buttonIndex);
            case 0:
            {
  
                if([styleTitleArray count] > 10)
                {
                    editStatus = 2;
                    [swipeView reloadData];
                    swipeView.currentPage = 3;
                    doneButton.hidden = NO;
                    actionsheetButton.hidden = YES;
                }
            }
                break;
            default:
                break;
        }
    }
}

- (IBAction)doneButton:(id)sender
{
    editStatus = 0;
    [swipeView reloadData];
    swipeView.currentPage =3;
    doneButton.hidden = YES;
    settingButton.hidden = NO;
    
    //[self updatePageControl];
}

- (void)deleteSelectItem:(UITapGestureRecognizer*)sender
{
    int index;
    UIImageView *button = (UIImageView *)sender.view;
    index = [swipeView indexOfItemViewOrSubview:button];
    [styleTitleArray removeObjectAtIndex:index];
    [styleImages removeObjectAtIndex:index];
    [styleTitleArray writeToFile:[FilePath styleFxmenuTitleFilePath] atomically:YES];
    [styleImages writeToFile:[FilePath styleFxmenuImageFilePath] atomically:YES];

    if(selectStyleIndex == [styleTitleArray count] -1)
    {
        selectStyleIndex = selectStyleIndex -1;
    }
    [self setBgWithSelectedStyle:selectStyleIndex];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES] forKey:@"isChangeBg"];
    [ud setInteger:selectStyleIndex forKey:@"styleIndex"];
    [ud synchronize];//take effect right away
    
    
    [swipeView reloadData];
    swipeView.currentPage = 3;
    //delete the background pic and style pic
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"styleImageView%d.png",index-9]];
    
    [fileManager removeItemAtPath:fullPathToFile error:nil];
    fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"styleBgImageView%d.png",index-9]];
    
    [fileManager removeItemAtPath:fullPathToFile error:nil];
    
    if([styleTitleArray count] == 10)
    {
        editStatus = 1;
        doneButton.hidden = YES;
        actionsheetButton.hidden = NO;
    }
    
    NSLog(@"deleteSelectItem!!!!!= %d",index);
    
}
- (UIView *)swipeView:(SwipeView *)swipeView1 viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIButton *styleImageView = (UIButton *)view;
    UILabel *styleTitleLabel ;
    UILabel *selectImageHl;
    
    UIImageView *delButton;
 
    if(index < [styleTitleArray count])
    {
        styleImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        styleImageView.frame = CGRectMake(0, 0, 96, 206);
        styleTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 170, 96, 40)];
        styleTitleLabel.backgroundColor = [UIColor clearColor];
        styleTitleLabel.textColor = [UIColor whiteColor];
        styleTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        styleTitleLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:15];
        [styleImageView addSubview:styleTitleLabel];
    
        [delButton = [UIImageView alloc]initWithFrame:CGRectMake(0, 0, 26, 26)];
        delButton.image = [UIImage imageNamed:@"delButton.png"];
        if(editStatus == 2)
        {
            if(index>=9 && index!=[styleTitleArray count]-1 )
            {
                delButton.hidden = NO;
                
                delButton.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap =           [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteSelectItem:)];
                [delButton addGestureRecognizer:singleTap];
                [singleTap release];
            }
            else
            {
                delButton.hidden = YES;
            }
        }
        else
        {
            delButton.hidden =  YES;
        }
        [styleImageView addSubview:delButton];
        
        selectImageHl = [[UILabel alloc]initWithFrame:CGRectMake(0, 203, 95, 2)];
        [selectImageHl setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];
        selectImageHl.tag = 11;
        [styleImageView addSubview:selectImageHl];
        
        if (index == selectStyleIndex) {
            selectImageHl.hidden = NO;
        }
        else
            selectImageHl.hidden = YES;
        view = styleImageView;
        
        //configure view
        styleTitleLabel.text = [styleTitleArray objectAtIndex:index];
        [[styleImageView imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [styleImageView setAdjustsImageWhenHighlighted:NO];
        
        if(index == [styleTitleArray count]-1)
        {
            [styleImageView setImage:[UIImage imageNamed:@"addTheme.png"] forState:UIControlStateNormal];
            
        }else if(index < 9)
        {
            
            [styleImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[styleImages objectAtIndex:index]]] forState:UIControlStateNormal];
        }
        else
        {
            
            NSData *image = [NSData dataWithContentsOfFile:[styleImages objectAtIndex:index]];
            
            [styleImageView setImage:[UIImage imageWithData:image] forState:UIControlStateNormal];
        }
            
        [styleImageView addTarget:self action:@selector(selectStyle:) forControlEvents:UIControlEventTouchUpInside];
        
        [styleTitleLabel release];
        [selectImageHl release];
    }
    else
    {
        styleImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        styleImageView.frame = CGRectMake(0, 0, 96, 206);
        styleImageView.hidden = YES;
        view = styleImageView;
        //view = nil;
    }
    
    
    return view;
}

NSString *m_filePath = nil;
- (IBAction)selectStyle:(id)sender
{
    
    if(editStatus ==2)
    {
        if([swipeView indexOfItemViewOrSubview:sender] < [styleTitleArray count]-1)
        {
            selectStyleIndex = [swipeView indexOfItemViewOrSubview:sender];
            [self performSegueWithIdentifier:@"addstyle" sender:self];
            
        }

        return;
    }
    NSLog(@"select %d.[styleTitleArray count]=%d",[swipeView indexOfItemViewOrSubview:sender],[styleTitleArray count]);
    
    if([swipeView indexOfItemViewOrSubview:sender] >= [styleTitleArray count])
        return;
    
    if ([swipeView indexOfItemViewOrSubview:sender] == [styleTitleArray count]-1) {
        [self performSegueWithIdentifier:@"addstyle" sender:self];
    }
    else {
        
        UIButton *iView;
        iView = (UIButton *)sender;

        for (int i= 0; i < [[iView subviews] count]; i++)
        {
            UIView *subView = [[iView subviews] objectAtIndex:i];
            if ([subView isKindOfClass:[UILabel class]])
            {
                if (subView.tag == 11) {
                    subView.hidden = NO;
                }
            }
        }
        
        selectStyleIndex = [swipeView indexOfItemViewOrSubview:sender];
        [self setBgWithSelectedStyle:selectStyleIndex];

        NSMutableArray *titleArray;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
        {

            NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",selectStyleIndex]];
            titleArray = [dictionary objectForKey:@"title"];

            
        }
       
        
        NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:0]];
        
        /*
        int lFromR;
        int lFromG;
        int lFromB;
        
        int lToR;
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

        
        [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
         */
        
        AnimationParameter* animationParameter = [AnimationParameter createFromArray:lightDataArray];
        emulator.animationParameter = animationParameter;

        
        for (int j = 0; j < [styleTitleArray count]; j++)
        {
            if (j != selectStyleIndex)
            {
                UIView *itemView = [swipeView itemViewAtIndex:j];
                for (int i= 0; i < [[itemView subviews] count]; i++)
                {
                    UIView *subView = [[itemView subviews] objectAtIndex:i];
                    if ([subView isKindOfClass:[UILabel class]])
                    {
                        if (subView.tag == 11) {
                            subView.hidden = YES;
                        }
                    }
                }
            }
        }
    }
}

-(void)setBgWithSelectedStyle:(int)selectedStyle
{
    NSString *filePath;
    NSArray *paths;
    NSString *documentsDirectory;
    
    switch (selectedStyle) {
        case 0:
            
            //get background image
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Business" ofType:@"png"];
            
            break;
        case 1:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Fashionista" ofType:@"png"];
            
            break;
        case 2:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Vampire" ofType:@"png"];
            
            break;
        case 3:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Clubber" ofType:@"png"];
            
            break;
        case 4:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Student" ofType:@"png"];
            
            break;
        case 5:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Magician" ofType:@"png"];
            
            break;
        case 6:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Adventurer" ofType:@"png"];
            
            break;
        case 7:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Athlete" ofType:@"png"];
            
            break;
        case 8:
            filePath = [[NSBundle mainBundle] pathForResource:@"bg_Entertainer" ofType:@"png"];
            
            break;
        default:
            //get the background from the custom background files
            
            paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            documentsDirectory = [paths objectAtIndex:0];
            filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"styleBgImageView%d.png",selectStyleIndex-9]];
            
            break;
    }
    
    appDelegate.backgroundImageTemp = [UIImage imageWithContentsOfFile:filePath];
    
    
    /*
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        CCScene * scene = [director runningScene];
        EmbLayer *layer = [scene.children objectAtIndex:0];
        [layer SetBackground];
        
    }
     */
    [emulator setBackgroundImage:appDelegate.backgroundImageTemp];

}

- (void)swipeViewCurrentItemIndexDidChange:(SwipeView *)swipeView1
{
    //update page control page
    _pageControl.currentPage = swipeView1.currentPage;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    int currentPage = [swipeView currentPage];
    
    if(currentPage >=3)
    {
        if(editStatus == 0)
        {
            editStatus = 1;
            actionsheetButton.hidden = NO;
            settingButton.hidden = YES;
        }
    }
    else
    {
        if(editStatus == 1)
        {
            editStatus = 0;
            actionsheetButton.hidden = YES;
            settingButton.hidden = NO;
        }

    }

}
- (IBAction)pageControlTapped
{
    //update swipe view page
    [swipeView scrollToPage:_pageControl.currentPage duration:1.0];
}

- (IBAction)reConnectButtonClicked
{
    if([[[LeDiscovery sharedInstance] connectedServices] count] != 0)
    {
        
        return;
    }
    connectingViewController = [[ConnectingViewController alloc] initWithNibName:@"ConnectingViewController" bundle:nil];
    [self presentPopupViewController:connectingViewController animationType:0 dismissed:nil];
    //[self presentPopupViewController:connectingViewController animationType:0];
    [connectingViewController.connectedLabel setHidden:YES];
    [connectingViewController.indicatorView startAnimating];
    [connectingViewController.indicatorView setHidden:NO];
    
     [[LeDiscovery sharedInstance] setPeripheralDelegate:self];
    
    //start a timer
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
        NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:kEmbraceServiceUUIDString], nil];
        
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

- (IBAction)select:(id)sender
{
    UIImage *newImg = appDelegate.backgroundImageTemp;
    appDelegate.backgroundImage = newImg;
    
    NSData *pngData = UIImagePNGRepresentation(newImg);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"backgroundImageView.png"]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:[NSNumber numberWithBool:YES] forKey:@"isChangeBg"];
    NSLog(@"selectStyleIndex= %d", selectStyleIndex);
  
    [ud setInteger:selectStyleIndex forKey:@"styleIndex"];
#pragma mark - kane 
    [ud setObject:[styleTitleArray objectAtIndex:selectStyleIndex] forKey:@"styletitle"];
    [UserInfo sharedInstance].isChangeText = YES;
    [UserInfo sharedInstance].isChangeCalendar = YES;
    [UserInfo sharedInstance].isChangeBattery = YES;
    [ud synchronize];//take effect right away
    
    [self showIndicator];
    
    [NotificationUtility configAllNotification:selectStyleIndex];
    
    [self hideIndicator];
    
    [self performSegueWithIdentifier:@"notifications" sender:self];
    
#pragma mark - kane
    [UserInfo sharedInstance].userThems = [styleTitleArray objectAtIndex:selectStyleIndex];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"notifications"])
	{
        NotificationsViewController *notificationsViewController = segue.destinationViewController;
        notificationsViewController.styleIndex = selectStyleIndex;
        notificationsViewController.connectPeripheral = connectPeripheral;
	}
    if ([segue.identifier isEqualToString:@"addstyle"])
	{
        addStyleViewController *addStyleView = segue.destinationViewController;
        addStyleView.delegate = self;
        if(editStatus ==2)
        {
            addStyleView.isEdit = true;
            addStyleView.styleNum = selectStyleIndex;
        }
        else
        {
            addStyleView.styleNum = [styleTitleArray count];
            addStyleView.isEdit = false;
        }
      
	}
    else if ([segue.identifier isEqualToString:@"setting"])
	{
        SettingsViewController *settingsViewController = segue.destinationViewController;
        settingsViewController.styleIndex = selectStyleIndex;
        
    }

}
//uint8_t data[14];

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissPopView
{
    [self dismissPopupViewControllerWithanimationType:0];
    
}

#pragma mark - 蓝牙未发现弹出框
-(void) btDidnotFound
{
    if(myTimer)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
    [self dismissPopView];
    //pop up a dialog
#pragma mark - kane
//    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
//                                                   message:@"Embrace+ not found"
//                                                  delegate:self
//                                         cancelButtonTitle:@"ok"
//                                         otherButtonTitles:nil];
//    [alert show];
//    [alert release];
    [Factory dispanchTimerWithTime:BuleToothScanInterval Block:^
     {
         [[LeDiscovery sharedInstance] reConnect];
     }];
    
    
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

- (void) deviceDidConnect
{
    NSLog(@"deviceDidConnect");
    //stop timer
    if(myTimer)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
    [connectingViewController.connectedLabel setHidden:NO];
    [connectingViewController.indicatorView stopAnimating];
    [connectingViewController.indicatorView setHidden:YES];
    
    [self performSelector:@selector(dismissPopView) withObject:nil afterDelay:2];
    
}

-(void) showIndicator
{
    
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 110, 50)];
    label.text =@"Updating Embrace+";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [indicator setCenter:CGPointMake(winsize.width / 2, winsize.height / 2)];
    
    indicator.backgroundColor = [UIColor blackColor];
    [indicator addSubview:label];
    
    
    indicator.layer.cornerRadius = 6;
    [self.view  addSubview:indicator];
    [indicator startAnimating];
}

-(void) hideIndicator
{
    [indicator stopAnimating];
}

-(void)dealloc
{
    [super dealloc];
    
    [chooseStyleLabel release];
    [selectButton release];
    [connectButton release];
    [settingButton release];
    [line1 release];
    [line2 release];
    [swipeView release];

    
    [fxForStyleDic release];
    [fxMenuLightDataDic release];
    
    [connectingViewController release];
    
}

@end
