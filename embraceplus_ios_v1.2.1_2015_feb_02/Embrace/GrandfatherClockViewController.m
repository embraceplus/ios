//
//  AddFxMenuViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "GrandfatherClockViewController.h"
#import "ColorCell.h"
//#import "EmbLayer.h"
#import "EmbColor.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
#import "FilePath.h"
#import "PresetEffect.h"
#import "ColorCellBoardView.h"

NSString *grandfatherColorCellID = @"grandfatherColorCellID";

//static const ccColor3B emColor1 = {0xff,0xff,0xff};
//
//static const ccColor3B emColor3 = {0x0,0x0,0xff};
//static const ccColor3B emColor4 = {0x0,0xff,0x0};
//
//static const ccColor3B emColor5 = {0x33,0x99,0xff};
//static const ccColor3B emColor6 = {0x99,0xff,0x00};
//
//static const ccColor3B emColor7 = {0xcc,0xff,0xff};
//static const ccColor3B emColor8 = {0xff,0xff,0x0};
//
//static const ccColor3B emColor9 = {0xff,0x0,0x0};
//static const ccColor3B emColor10 = {0xff,0xcc,0x33};
//
//static const ccColor3B emColor11 = {0xff,0x33,0x33};
//static const ccColor3B emColor12 = {0xff,0x99,0x0};
//
//static const ccColor3B emColor13 = {0xff,0x0,0xff};
//static const ccColor3B emColor14 = {0xff,0x99,0xff};
//
//static const ccColor3B emColor15 = {0x99,0x0,0xff};
//static const ccColor3B emColor16 = {0xff,0x0,0xff};


@interface GrandfatherClockViewController ()

#pragma mark - kane
@property(nonatomic,strong)ColorCellBoardView *colorCellBoardView;

@end

@implementation GrandfatherClockViewController

@synthesize iconName;
@synthesize styleIndex;
@synthesize fxIndex;
@synthesize isEdit;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animationParameter = [AnimationParameter create];
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
	// Do any additional setup after loading the view.
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    
    fxLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    
    colorPickerLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    previewButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    
    startLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:25];
    [startLabel setFrame:CGRectMake(18, 52 + deltaY, 60, 34)];
   
    countLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:20];
    [countLabel setFrame:CGRectMake(18, 110 + deltaY, 60, 34)];
    vibrationLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:20];
    [vibrationLabel setFrame:CGRectMake(18, 114 +38+ deltaY, 90, 34)];
    halfhourLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:20];
    [halfhourLabel setFrame:CGRectMake(18, 118 +76+ deltaY, 90, 34)];

    countSegment.frame = CGRectMake(141, 110 + deltaY, 157, 29);
    vibrateSegment.frame = CGRectMake(141, 114 + 38+ deltaY, 157, 29);
    halfHourSegment.frame = CGRectMake(141, 118 + 76+ deltaY, 157, 29);
    
    CGRect frame;
    frame = startSwitch.frame;
    frame.origin.x = 245;
    frame.origin.y = 52+deltaY;
    startSwitch.frame = frame;

    
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    
    colorPageControl.frame = CGRectMake(141, 351 + deltaY, 39, 37);
    
    line2.frame = CGRectMake(0, 87 + deltaY, 320, 2);
    
    line3.frame = CGRectMake(0, 243 + deltaY, 320, 2);
    
    colorCollectionView.frame = CGRectMake(16, 260 + deltaY, 278, 91);
    
    
    CGRect chooseLabelFarme = fxLabel.frame;
    chooseLabelFarme.origin.y = 7+ deltaY;
    NSLog(@"Y = %f",chooseLabelFarme.origin.y);
    fxLabel.frame = chooseLabelFarme;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath grandfatherClockConfigFilePath]])
    {
        grandfatherClockConfigDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath grandfatherClockConfigFilePath]];
        colorId = [[grandfatherClockConfigDic objectForKey:@"clolorIndex"] intValue];
        isHalfHour = [[grandfatherClockConfigDic objectForKey:@"halfhour"] boolValue];
        isVibration = [[grandfatherClockConfigDic objectForKey:@"vibration"] boolValue];
        count = [[grandfatherClockConfigDic objectForKey:@"count"] intValue];
        isStart = [[grandfatherClockConfigDic objectForKey:@"isStart"] boolValue];
        
        switch (colorId) {
            case 0:
                
                colorTemp = emColor1;
                break;
                
                //            case 1:
                //                colorTemp = emSilver;//random
                //
                //                break;
                
            case 1:
                colorTemp = emColor4;
                break;
                
            case 2:
                colorTemp = emColor3;
                break;
                
            case 3:
                colorTemp = emColor6;
                break;
                
            case 4:
                colorTemp = emColor5;
                break;
                
            case 5:
                colorTemp = emColor8;
                break;
                
            case 6:
                colorTemp = emColor7;
                break;
                
            case 7:
                colorTemp = emColor10;
                break;
                
            case 8:
                colorTemp = emColor9;
                break;
                
            case 9:
                colorTemp = emColor12;
                break;
                
            case 10:
                colorTemp = emColor11;
                break;
                
            case 11:
                colorTemp = emColor15;
                break;
                
            case 12:
                colorTemp = emColor13;
                break;
                
            case 13:
                colorTemp = emColor14;
                break;
                
            case 14:
                colorTemp = emColor15;
                break;
                
            default:
                break;
        }
        
        
//        lToR = colorTemp.r;
//        lToG = colorTemp.g;
//        lToB = colorTemp.b;
//        
//        rToR = colorTemp.r;
//        rToG = colorTemp.g;
//        rToB = colorTemp.b;

        
        self.animationParameter.lToR = colorTemp.r;
        self.animationParameter.lToG = colorTemp.g;
        self.animationParameter.lToB = colorTemp.b;
        
        self.animationParameter.rToR = colorTemp.r;
        self.animationParameter.rToG = colorTemp.g;
        self.animationParameter.rToB = colorTemp.b;
    }
    else
    {
        grandfatherClockConfigDic = [[NSMutableDictionary alloc] init];
        
        colorId = 0;
        isHalfHour = NO;
        isVibration = NO;
        count = 0;
        isStart = NO;
        
        [grandfatherClockConfigDic setObject:[NSNumber numberWithBool:isVibration] forKey:@"vibration"];
        [grandfatherClockConfigDic setObject:[NSNumber numberWithBool:colorId] forKey:@"clolorIndex"];
        [grandfatherClockConfigDic setObject:[NSNumber numberWithBool:isHalfHour] forKey:@"halfhour"];
        [grandfatherClockConfigDic setObject:[NSNumber numberWithBool:count] forKey:@"count"];
         [grandfatherClockConfigDic setObject:[NSNumber numberWithBool:isStart] forKey:@"isStart"];
        
        //init the default status
        colorTemp = emWHITE;
        
//        lToR = colorTemp.r;
//        lToG = colorTemp.g;
//        lToB = colorTemp.b;
//
//        rToR = colorTemp.r;
//        rToG = colorTemp.g;
//        rToB = colorTemp.b;

        self.animationParameter.lToR = colorTemp.r;
        self.animationParameter.lToG = colorTemp.g;
        self.animationParameter.lToB = colorTemp.b;
        
        self.animationParameter.rToR = colorTemp.r;
        self.animationParameter.rToG = colorTemp.g;
        self.animationParameter.rToB = colorTemp.b;
    }
    
//    lFromR = 256;
//    lFromG = 0;
//    lFromB = 0;
//    rFromR = 256;
//    rFromG = 0;
//    rFromB = 0;
//    
//    durationTime1 = emPatternLongBeat2.durationTime1;
//    durationTime2 = emPatternLongBeat2.durationTime2;
//    isRandom = 0;
//    isReversed = emPatternLongBeat2.isReversed;
//    pause = emPatternLongBeat2.pause;
//    isBlackout = 1;
//    hold = emPatternLongBeat2.hold;
//    isRandom = 0;
    
  self.animationParameter.lFromR = 256;
    self.animationParameter.lFromG = 0;
    self.animationParameter.lFromB = 0;
    self.animationParameter.rFromR = 256;
    self.animationParameter.rFromG = 0;
    self.animationParameter.rFromB = 0;
    
    self.animationParameter.durationTime1 = emPatternLongBeat2.durationTime1;
    self.animationParameter.durationTime2 = emPatternLongBeat2.durationTime2;
    self.animationParameter.isRandom = 0;
//    isReversed = emPatternLongBeat2.isReversed; //TODO:
    self.animationParameter.pause = emPatternLongBeat2.pause;
    self.animationParameter.isBlackout = 1;
    self.animationParameter.hold = emPatternLongBeat2.hold;
    self.animationParameter.isRandom = 0;
    self.animationParameter.loop = emPatternLongBeat2.loop;
    self.animationParameter.isVibrate = isVibration;  
#pragma mark -kane
    [self p_createColorBoareView];

}

#pragma mark - kane
- (void)p_createColorBoareView
{
    self.colorCellBoardView = [[ColorCellBoardView alloc] initWithFrame:CGRectMake(0,0,63, 39)];
    self.colorCellBoardView.backgroundColor = [UIColor clearColor];
    [colorCollectionView addSubview:self.colorCellBoardView];
    self.colorCellBoardView.hidden = YES;
}

static int lightPatternTag = 40;
- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"AddFxMenuViewController");
    [super viewWillAppear:animated];
    
    /*
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [EmbLayer switchPicture:0];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        //[director startAnimation];
        
    }
    else
    {
        [director runWithScene:[EmbLayer scene:0]];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        //[director startAnimation];
        
    }
     */

    colorPickSelectImageView.hidden = NO;
    CGRect frame1 = CGRectMake(0, 443, 320, 2);
    for (int i = 0; i < 11; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = frame1;
        imageView.image = [UIImage imageNamed:@"separateLine.png"];
        CGRect imageFrame = imageView.frame;
        imageFrame.size.width = 320;
        imageFrame.size.height = 2.0;
        
        imageFrame.origin.x = 0;
        imageView.frame = imageFrame;
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect titleButtonFrame = titleButton.frame;
        titleButtonFrame.origin.y = imageFrame.origin.y - 50;
        titleButtonFrame.origin.x = 0;
        titleButtonFrame.size.width = 320;
        titleButtonFrame.size.height = 49;
        titleButton.frame = titleButtonFrame;
        
        [titleButton setTitle:[lightPatternArray objectAtIndex:i] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:17];
        if (i != 0) {
            [titleButton setBackgroundImage:[UIImage imageNamed:@"lightpatternhighlight.png"] forState:UIControlStateHighlighted];
            [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(5, 50, 5, 0.0)];
        }
        else
        {
            [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        }

        [titleButton addTarget:self action:@selector(lightPatternSelect:) forControlEvents:UIControlEventTouchUpInside];
        titleButton.titleLabel.textColor = [UIColor whiteColor];
        titleButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        titleButton.tag = lightPatternTag;
        
        
        frame1.origin.y += 52;
        //imageFrame.origin.y = frame1.origin.y + 52;
        lightPatternTag++;

        
    }

    [startSwitch setOn:isStart];
    [countSegment setSelectedSegmentIndex:count];
    [vibrateSegment setSelectedSegmentIndex:isVibration];
    [halfHourSegment setSelectedSegmentIndex:isHalfHour];
    
    [colorCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:colorId inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [countSegment setSelectedSegmentIndex:([[grandfatherClockConfigDic objectForKey:@"count"] intValue])];
    [vibrateSegment setSelectedSegmentIndex:([[grandfatherClockConfigDic objectForKey:@"vibration"] intValue])];
    [halfHourSegment setSelectedSegmentIndex:([[grandfatherClockConfigDic objectForKey:@"halfhour"] intValue])];
    
    
    colorPageControl.numberOfPages = 2;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.animationParameter.isVibrate = isVibration;
    emulator = [EmulatorView emulator:self.animationParameter];
    [emulator showInView:self.view];
//    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
    
    
   
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [director startAnimation];
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 0)
    {
        int page = scrollView.contentOffset.x > 280 ? 1:0;
        //NSLog(@"scrollViewDidScroll   1 = %f",scrollView.contentOffset.x);
        colorPageControl.currentPage = page;
    }
    
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    for (UIView *_currentView in alertView.subviews) {
        
        if( [_currentView isKindOfClass:[UILabel class]] )
        {
            UILabel* label = (UILabel*) _currentView;
            label.font=[UIFont fontWithName:@"Avenir" size:18];
        }
        if ( [_currentView isKindOfClass:[UIButton class]] )
        {
            ((UIButton *)_currentView).titleLabel.font = [UIFont fontWithName:@"Avenir" size:18];
        }
    }
}

- (IBAction)backButton:(id)sender
{
    
    //[grandfatherClockConfigDic setObject:[NSString stringWithFormat:@"%d",colorId] forKey:@"clolorIndex"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)vibrateSegmentValueChange:(UISegmentedControl *)Seg
{
    
    if(Seg.selectedSegmentIndex == 0)
    {
        [grandfatherClockConfigDic setObject:@"0" forKey:@"vibration"];
        isVibration = NO;
    }
    else
    {
        [grandfatherClockConfigDic setObject:@"1" forKey:@"vibration"];
        isVibration = YES;
    }
    
   [grandfatherClockConfigDic writeToFile:[FilePath grandfatherClockConfigFilePath] atomically:YES];
}

- (IBAction)countSegmentValueChange:(UISegmentedControl *)Seg
{
    if(Seg.selectedSegmentIndex == 0)
    {
        [grandfatherClockConfigDic setObject:@"0" forKey:@"count"];
    }
    else
    {
        [grandfatherClockConfigDic setObject:@"1" forKey:@"count"];
    }

    [grandfatherClockConfigDic writeToFile:[FilePath grandfatherClockConfigFilePath] atomically:YES];
}

- (IBAction)halfHourSegmentValueChange:(UISegmentedControl *)Seg
{
//    double timerNextValueInSecond;
//    timerStartValueInSecond = [[NSDate date] timeIntervalSince1970];
    
    if(Seg.selectedSegmentIndex == 0)
    {
        [grandfatherClockConfigDic setObject:@"0" forKey:@"halfhour"];
//        timerNextValueInSecond = timerStartValueInSecond + 60*60;
    }
    else
    {
        [grandfatherClockConfigDic setObject:@"1" forKey:@"halfhour"];
  //      timerNextValueInSecond = timerStartValueInSecond + 30*60;
    }
    
//    [grandfatherClockConfigDic setObject:[NSNumber numberWithDouble:timerNextValueInSecond] forKey:@"endTime"];

    [grandfatherClockConfigDic writeToFile:[FilePath grandfatherClockConfigFilePath] atomically:YES];
}

- (IBAction)switchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    if(isButtonOn)
    {
//        timerStartValueInSecond = [[NSDate date] timeIntervalSince1970];
//
//        double timerNextValueInSecond;
        
        if(halfHourSegment.selectedSegmentIndex == 0)
        {
            [grandfatherClockConfigDic setObject:@"0" forKey:@"halfhour"];
//            timerNextValueInSecond = timerStartValueInSecond + 60*60;
        }
        else
        {
            [grandfatherClockConfigDic setObject:@"1" forKey:@"halfhour"];
 //           timerNextValueInSecond = timerStartValueInSecond + 30*60;//
        }
//        [grandfatherClockConfigDic setObject:[NSNumber numberWithDouble:timerNextValueInSecond] forKey:@"endTime"];
        [grandfatherClockConfigDic setObject:@"1" forKey:@"isStart"];

    }
    else
    {
        [grandfatherClockConfigDic setObject:@"0" forKey:@"isStart"];
    }
    
    [grandfatherClockConfigDic writeToFile:[FilePath grandfatherClockConfigFilePath] atomically:YES];
}


- (IBAction)previewButtonClicked
{
    NSLog(@"previewButtonClicked");
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;

    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    
    self.animationParameter.isVibrate = isVibration;
    [service writeEffectCommand:self.animationParameter silent:0];
//    [service writeEffectCommand:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:0 VIBRATE:vibrateSegment.selectedSegmentIndex LOOP:1];
    
}

- (void)backFxmenuViewController:(FxIconsViewController *)controller Icon:(NSString *)imageName
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"fxicons"])
	{
//        CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
//        
//        NSLog(@"find hello retain count before= %d",[director.view retainCount]);
//        if([director.view retainCount]>0)
//            [director end];
//        
//        NSLog(@"find hello retain count after= %d",[director.view retainCount]);
        
		FxIconsViewController *fxIconsViewController = segue.destinationViewController;
		fxIconsViewController.delegate = self;
	}
}
#pragma mark _
#pragma mark collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    {
        return 16-1;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    ColorCell *colorCell;
    
       {
        colorCell = [cv dequeueReusableCellWithReuseIdentifier:grandfatherColorCellID forIndexPath:indexPath];
        NSLog(@"index = %d",indexPath.row);
        switch (indexPath.row)
        {
            case 0:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor1.r/255.0 green:emColor1.g/255.0   blue:emColor1.b/255.0   alpha:0.5]];

                
                break;
                
//            case 1:
//
//                
//                [colorCell.colorButton setBackgroundColor:[UIColor clearColor]];
//                [colorCell.colorButton setImage:[UIImage imageNamed:@"btn_customFX-col-Random"]  forState:UIControlStateNormal];
//
//                [colorCell.colorButton setOpaque:NO];
                
//                break;
                
            case 1:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor4.r/255.0   green:emColor4.g/255.0  blue:emColor4.b/255.0   alpha:1]];
                break;
                
                
            case 2:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor3.r/255.0  green:emColor3.g/255.0  blue:emColor3.b/255.0   alpha:1]];
                break;
                
            case 3:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor6.r/255.0  green:emColor6.g/255.0  blue:emColor6.b/255.0   alpha:1]];

                break;
                
            case 4:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor5.r/255.0  green:emColor5.g/255.0  blue:emColor5.b/255.0   alpha:1]];

                break;
                
            case 5:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor8.r/255.0  green:emColor8.g/255.0  blue:emColor8.b/255.0   alpha:1]];

                break;
                
            case 6:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor7.r/255.0  green:emColor7.g/255.0  blue:emColor7.b/255.0   alpha:1]];

                break;
                
            case 7:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor10.r/255.0  green:emColor10.g/255.0  blue:emColor10.b/255.0   alpha:1]];

                break;
                
            case 8:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor9.r/255.0  green:emColor9.g/255.0  blue:emColor9.b/255.0   alpha:1]];
                break;
                
            case 9:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor12.r/255.0  green:emColor12.g/255.0  blue:emColor12.b/255.0   alpha:1]];
                break;
                
            case 10:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor11.r/255.0  green:emColor11.g/255.0  blue:emColor11.b/255.0   alpha:1]];
                break;
                
            case 11:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor15.r/255.0  green:emColor15.g/255.0  blue:emColor15.b/255.0   alpha:1]];
                
                break;
                
            case 12:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor13.r/255.0  green:emColor13.g/255.0  blue:emColor13.b/255.0   alpha:1]];
                break;
                
            case 13:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor14.r/255.0  green:emColor14.g/255.0  blue:emColor14.b/255.0   alpha:1]];
                break;
                
            case 14:
                  [colorCell.colorButton setBackgroundColor:[UIColor clearColor]];
                break;
                
        }
        
        if(indexPath.row!= 1)
        {
            [colorCell.colorButton setImage:nil  forState:UIControlStateNormal];
        }
        [colorCell.colorButton setEnabled:NO];
        //[colorCell.image setHidden:YES];
        
           if(indexPath.row == colorId)
           {
               colorCell.colorButton.layer.borderWidth = 2.0;
               colorCell.colorButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.5].CGColor;
               
           }
           else
           {
               colorCell.colorButton.layer.borderWidth = 2.0;
               colorCell.colorButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2].CGColor;
           }
           
           if(indexPath.row == 14)
           {
               colorCell.colorButton.layer.borderWidth = 0.0;
           }

        return colorCell;

    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int selectFxIndex = indexPath.row;
    NSLog(@"selectIndex %d",selectFxIndex);
    
    ColorCell *colorCell;

        
        colorCell = (ColorCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
        colorCell.colorButton.layer.borderWidth = 2.0;
        colorCell.colorButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.5].CGColor;
        
    
        colorId = indexPath.row;
    
        switch (colorId) {
            case 0:
                
                colorTemp = emColor1;
                break;
                
//            case 1:
//                colorTemp = emSilver;//random
//                
//                break;
                
            case 1:
                colorTemp = emColor4;
                break;
                
            case 2:
                colorTemp = emColor3;
                break;
                
            case 3:
                colorTemp = emColor6;
                break;
                
            case 4:
                colorTemp = emColor5;
                break;
                
            case 5:
                colorTemp = emColor8;
                break;
                
            case 6:
                colorTemp = emColor7;
                break;
                
            case 7:
                colorTemp = emColor10;
                break;
                
            case 8:
                colorTemp = emColor9;
                break;
                
            case 9:
                colorTemp = emColor12;
                break;
                
            case 10:
                colorTemp = emColor11;
                break;
                
            case 11:
                colorTemp = emColor15;
                break;
                
            case 12:
                colorTemp = emColor13;
                break;
                
            case 13:
                colorTemp = emColor14;
                break;
                
            case 14:
                colorTemp = emColor15;
                break;
                
            default:
                break;
        }
    
    
#pragma mark - kane
    if(colorId != 15 && colorId != 14)
    {
        self.colorCellBoardView.center = colorCell.center;
        if(self.colorCellBoardView.hidden == YES)
        {
            self.colorCellBoardView.hidden = NO;
        }
    }
    
//    if(colorId == 1)
//    {
//        isRandom = 1;
//    }
//    else
//    {
//        isRandom = 0;
//    }
    

//    lToR = colorTemp.r;
//    lToG = colorTemp.g;
//    lToB = colorTemp.b;
//    
//    rToR = colorTemp.r;
//    rToG = colorTemp.g;
//    rToB = colorTemp.b;
//  
//    [grandfatherClockConfigDic setObject:[NSString stringWithFormat:@"%d",colorId] forKey:@"clolorIndex"];
//    [grandfatherClockConfigDic writeToFile:[FilePath grandfatherClockConfigFilePath] atomically:YES];
//
//     [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
    self.animationParameter.lToR = colorTemp.r;
    self.animationParameter.lToG = colorTemp.g;
    self.animationParameter.lToB = colorTemp.b;
    
    self.animationParameter.rToR = colorTemp.r;
    self.animationParameter.rToG = colorTemp.g;
    self.animationParameter.rToB = colorTemp.b;
  
    [grandfatherClockConfigDic setObject:[NSString stringWithFormat:@"%d",colorId] forKey:@"clolorIndex"];
    [grandfatherClockConfigDic writeToFile:[FilePath grandfatherClockConfigFilePath] atomically:YES];
    
    emulator.animationParameter = self.animationParameter;
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    int selectIndex = indexPath.row;
    ColorCell *colorCell;
    

        colorCell = (ColorCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    NSLog(@"viewWillDisappear");
    
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    [director stopAnimation];
    
    
}
- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
  
//        CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
//    
//        NSLog(@"find hello retain count before= %d",[director.view retainCount]);
//        if([director runningScene] != nil)
//            [director end];
//    
//        NSLog(@"find hello retain count after= %d",[director.view retainCount]);
    
}

@end
