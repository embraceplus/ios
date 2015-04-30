//
//  AddFxMenuViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "AddFxMenuViewController.h"
#import "PatternCell.h"
#import "ColorCell.h"
//#import "EmbLayer.h"
#import "EmbColor.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
#import "CustomEffectConfig.h"
#import "FilePath.h"
#import "PresetEffect.h"

#import "ColorCellBoardView.h"

NSString *colorCellID = @"colorCellID";
NSString *pattenCellID = @"patternCellID"; // UICollectionViewCell storyboard id

@interface AddFxMenuViewController ()

#pragma mark - kane
@property(nonatomic,strong)ColorCellBoardView *colorCellBoardView;
@property(nonatomic,assign)BOOL isBack;
@end

@implementation AddFxMenuViewController
@synthesize delegate;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isBack = YES;
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
	// Do any additional setup after loading the view.
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    fxLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    

    nameLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    nameLabel.frame = CGRectMake(19, 66 + deltaY, 54, 21);
    nameTextField.borderStyle = UITextBorderStyleNone;//UITextField的边框
    nameTextField.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];

    
    iconLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    previewButton.titleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    
    ledLeftButton.titleLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:13];
    ledRightButton.titleLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:13];
    
    doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    doneButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);

    patternPageControl.frame = CGRectMake(141, 192 + deltaY, 39, 37);
    colorPageControl.frame = CGRectMake(141, 321 + deltaY, 39, 37);

    previewButton.frame = CGRectMake(122, 538 + deltaY, 77, 30);
    doneButton.frame = CGRectMake(248, 8 + deltaY, 55, 33);
    
    line2.frame = CGRectMake(0, 353 + deltaY, 320, 2);
    
    line3.frame = CGRectMake(0, 222 + deltaY, 320, 2);
    
    colorCollectionView.frame = CGRectMake(16, 230 + deltaY, 278, 91);
    patternCollectionView.frame = CGRectMake(19, 109 + deltaY, 283, 91);
    
    if (iPhone5) {
        previewButton.frame = CGRectMake(122, 538, 77, 30);
        line2.frame = CGRectMake(0, 414, 320, 2);
        
        ledLeftButton.frame = CGRectMake(47, 457, 69, 48);
        ledRightButton.frame = CGRectMake(199, 457, 69, 48);
        ledBothButton.frame = CGRectMake(116, 457, 83, 48);
        vibrateButton.frame = CGRectMake(270, 466, 40, 40);
        
    }
    else {

        previewButton.frame = CGRectMake(122, 450, 77, 30);
        
        ledLeftButton.frame = CGRectMake(47, 373, 69, 48);
        ledRightButton.frame = CGRectMake(199, 373, 69, 48);
        ledBothButton.frame = CGRectMake(116, 373, 83, 48);
        vibrateButton.frame = CGRectMake(270, 384, 40, 40);
        CGRect chooseLabelFarme = fxLabel.frame;
        chooseLabelFarme.origin.y = 27;
        
        fxLabel.frame = chooseLabelFarme;

    }

    patternCollectionView.tag = 0;
    colorCollectionView.tag = 1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0] ;
    [patternCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [colorCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All-on"] forState:UIControlStateNormal];
    isVibrateOn = YES;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath customFxConfigFilePath]])
    {
        customFxConfigDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath customFxConfigFilePath]];
        
    }
    
    if(isEdit)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
        {
            NSMutableDictionary *fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
            NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
            
            NSLog(@"select style = %d",styleIndex);
            
            titleArray = [dictionary objectForKey:@"title"];
            imageNameArray = [dictionary objectForKey:@"image"];
            
            NSString *imageToLoad = [NSString stringWithFormat:@"%@.png", [imageNameArray objectAtIndex:fxIndex]];
            [nameTextField setText:titleArray[fxIndex]];
            [iconButton setImage:[UIImage imageNamed:imageToLoad] forState:UIControlStateNormal];
            NSLog(@"edit fx name = %@",titleArray[fxIndex]);
            self.iconName  = [imageNameArray objectAtIndex:fxIndex];
        }
        
        NSMutableArray *customFxConfigArray;
        
        customFxConfigArray = [customFxConfigDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        
        NSData *data;
        if(fxIndex>23)
        {
            data = [customFxConfigArray objectAtIndex:fxIndex -24];
        }
        else
        {
            data = [customFxConfigArray objectAtIndex:fxIndex -6];
        }
        
        CustomEffectConfig *customFxConfig = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        [self setLeftRightButtonStatus:customFxConfig.leftRightValue];
        [self setVibrateButtonStatus:customFxConfig.isVibrateOn];

        
        patternId = customFxConfig.patternIndex;
        colorId = customFxConfig.colorIndex;
        lColorId = customFxConfig.lColorId;
        rColorId = customFxConfig.rColorId;
        

        [self useColor];
        
        isFxIconSelected = YES;
        
        /*
        NSMutableDictionary *fxMenuLightDataDic;
        if([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
        {
            fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
        }
        
        NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:fxIndex]];
        
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
        isVibrateOn = [[lightDataArray objectAtIndex:18] intValue];
        loop = [[lightDataArray objectAtIndex:19] intValue];
         */
        
        NSString* file = [FilePath fxMenuLightDataFilePath];
        NSString* title = [titleArray objectAtIndex:fxIndex];
        
        _animationParameter = [AnimationParameter createFromFile:file title:title];
    }
    else
    {
        //default icon
        [iconButton setImage:[UIImage imageNamed:@"btn-image.png"] forState:UIControlStateNormal];
        isFxIconSelected = NO;
        //init the default status
        patternId = 0;
        colorId = 0;
        LeftRight = 2;//both
        lColorId = 0;
        rColorId = 0;
        
        [self useColor];
        
//        durationTime1 = emPatternLongBeat.durationTime1;
//        durationTime2 = emPatternLongBeat.durationTime2;
//        isBlackout = emPatternLongBeat.isBlackout;
//        isRandom = 0;
//        hold = emPatternLongBeat.hold;
//        pause = emPatternLongBeat.pause;
//        loop = emPatternLongBeat.loop;
//        isVibrateOn = 1;
        
        
        [self setLeftRightButtonStatus:2];
        [self setVibrateButtonStatus:1];
    }

    
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
    [super viewWillAppear:animated];

    CGRect frame1 = CGRectMake(0, 443, 320, 2);
    for (int i = 0; i < 11; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect titleButtonFrame = titleButton.frame;
        titleButtonFrame.size.width = 320;
        titleButtonFrame.size.height = 49;
        titleButton.frame = titleButtonFrame;
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
        lightPatternTag++;
    }

    patternPageControl.numberOfPages = 2;
    colorPageControl.numberOfPages = 2;
    
    [patternCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:patternId inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    /*
  
    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
    
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        
        [director startAnimation];
    }
    else
    {
        
        [director runWithScene:[EmbLayer scene:0]];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        
    }
     */
    if(self.isBack)
    {
        _animationParameter = [AnimationParameter create];
        //        animationParameter.durationTime1
        
        //        animationParameter.lFromR = 255;
        //        animationParameter.lFromB = 255;
        //        animationParameter.lFromG = 255;
        //        animationParameter.rFromR = 255;
        //        animationParameter.rFromB = 255;
        //        animationParameter.rFromG = 255;
        //
        _animationParameter.lToR = 255;
        _animationParameter.lToG = 255;
        _animationParameter.lToB = 255;
        _animationParameter.rToR = 255;
        _animationParameter.rToG = 255;
        _animationParameter.rToB = 255;
        
        _animationParameter.durationTime1 = emPatternLongBeat.durationTime1;
        _animationParameter.durationTime2 = emPatternLongBeat.durationTime2;
        _animationParameter.isBlackout = emPatternLongBeat.isBlackout;
        _animationParameter.isRandom = 0;
        _animationParameter.hold = emPatternLongBeat.hold;
        _animationParameter.pause = emPatternLongBeat.pause;
        _animationParameter.loop = emPatternLongBeat.loop;
        _animationParameter.isVibrate = 1;
        
        emulator = [EmulatorView emulator:_animationParameter];
        [emulator showInView:self.view];
    }
    else
    {
        _animationParameter = [AnimationParameter create];
        //        animationParameter.durationTime1
        
        _animationParameter.lFromR = [self.animationParameterArr[0] intValue];
        _animationParameter.lFromG = [self.animationParameterArr[1] intValue];
        _animationParameter.lFromB = [self.animationParameterArr[2] intValue];
        
        _animationParameter.lToR = [self.animationParameterArr[3] intValue];
        _animationParameter.lToG = [self.animationParameterArr[4] intValue];
        _animationParameter.lToB = [self.animationParameterArr[5] intValue];
        
        
        _animationParameter.rFromR = [self.animationParameterArr[6] intValue];
        _animationParameter.rFromG = [self.animationParameterArr[7] intValue];
        _animationParameter.rFromB = [self.animationParameterArr[8] intValue];
        
        
        _animationParameter.rToR = [self.animationParameterArr[9] intValue];
        _animationParameter.rToG = [self.animationParameterArr[10] intValue];
        _animationParameter.rToB = [self.animationParameterArr[11] intValue];
        
        _animationParameter.durationTime1 = [self.animationParameterArr[12] intValue];
        _animationParameter.durationTime2 = [self.animationParameterArr[13] intValue];
        _animationParameter.isBlackout = [self.animationParameterArr[14] intValue];
        _animationParameter.isRandom = [self.animationParameterArr[15] intValue];
        _animationParameter.hold = [self.animationParameterArr[16] intValue];
        _animationParameter.pause = [self.animationParameterArr[17] intValue];
        _animationParameter.isVibrate = [self.animationParameterArr[18] intValue];
        _animationParameter.loop = [self.animationParameterArr[19] intValue];
        
        emulator = [EmulatorView emulator:_animationParameter];
        [emulator showInView:self.view];

    }
    
    
}
/*
- (void)viewDidAppear:(BOOL)animated
{
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [director startAnimation];
    }
    
   
}
*/
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    if(self.isBack == YES)
//    {
        [emulator removeFromSuperview];
        [emulator stopRuning];
        //    [emulator release];
        emulator = nil;
//    }
  
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 0)
    {

        int page = scrollView.contentOffset.x > 180 ? 1:0;
        //NSLog(@"scrollViewDidScroll   0 = %f",scrollView.contentOffset.x);
        patternPageControl.currentPage = page;

    }
    else
    {
        int page = scrollView.contentOffset.x > 280 ? 1:0;
        //NSLog(@"scrollViewDidScroll   1 = %f",scrollView.contentOffset.x);
        colorPageControl.currentPage = page;
        
//        self.colorCellBoardView.frame = CGRectMake(self.colorCellBoardView.frame.origin.x-scrollView.contentOffset.x,self.colorCellBoardView.frame.origin.y,67,43);
//        if(self.colorCellBoardView.hidden == YES)
//        {
//            self.colorCellBoardView.hidden = NO;
//        }

    }
    
}


- (IBAction)doneButton:(id)sender
{
    //save the custom fx config
    
    NSMutableArray *customFxConfigArray;
    
    customFxConfigArray = [customFxConfigDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
    
    CustomEffectConfig *customFxConfig = [[CustomEffectConfig alloc] init];
    
    customFxConfig.leftRightValue = LeftRight;
    customFxConfig.isVibrateOn = isVibrateOn;
    customFxConfig.colorIndex = colorId;
    customFxConfig.lColorId = lColorId;
    customFxConfig.rColorId = rColorId;
    customFxConfig.patternIndex = patternId;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:customFxConfig];
    
    if(!isEdit)
    {
        [customFxConfigArray addObject:data];
    }
    else
    {
        if(fxIndex > 23)
        {
            [customFxConfigArray replaceObjectAtIndex:fxIndex - 24 withObject:data];
        }
        else
        {
            [customFxConfigArray replaceObjectAtIndex:fxIndex - 6 withObject:data];
        }
    }
    
    
    [customFxConfigDic setObject:customFxConfigArray forKey:[NSString stringWithFormat:@"style%d",styleIndex]];
    
    [customFxConfigDic writeToFile:[FilePath customFxConfigFilePath] atomically:YES];
    
    NSLog(@"backButton imagename:%@,title:%@",self.iconName,nameTextField.text);
    if ([nameTextField.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please input fx name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    if (isFxIconSelected == NO) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please select a image" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        return;
    }
    
   
    [self backNotificationViewController];
//    [self.delegate backNotificationViewController:self iconImageName:iconName fxTitle:nameTextField.text lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause VIBRATE:isVibrateOn LOOP:loop];
    
    [customFxConfigArray release];
    [customFxConfig release];

   
}
- (void)backNotificationViewController{
    [self.delegate backNotificationViewController:self
                                    iconImageName:iconName
                                          fxTitle:nameTextField.text
                                           lFromR:_animationParameter.lFromR
                                           lFromG:_animationParameter.lFromG
                                           lFromB:_animationParameter.lFromB
                                             lToR:_animationParameter.lToR
                                             lToG:_animationParameter.lToG
                                             lToB:_animationParameter.lToB
                                           rFromR:_animationParameter.rFromR
                                           rFromG:_animationParameter.rFromG
                                           rFromB:_animationParameter.rFromB
                                             rToR:_animationParameter.rToR
                                             rToG:_animationParameter.rToG
                                             rToB:_animationParameter.rToB
                                         DURATION:_animationParameter.durationTime1
                                        DURATION2:_animationParameter.durationTime2
                                         BLACKOUT:_animationParameter.isBlackout
                                           RANDOM:_animationParameter.isRandom
                                             HOLD:_animationParameter.hold
                                            PAUSE:_animationParameter.pause
                                          VIBRATE:_animationParameter.isVibrate
                                             LOOP:_animationParameter.loop];
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

- (IBAction)ledLeftButton:(id)sender
{
    
    lColorId = colorId;
    [self useColor];

    [ledLeftButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-L-on"] forState:UIControlStateNormal];
    
    [ledRightButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-R"] forState:UIControlStateNormal];
    
    [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All"] forState:UIControlStateNormal];
    
    LeftRight = 0;
    
    //[self startAnimation];
#pragma mark - kane
//    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
}

- (IBAction)ledRightButton:(id)sender
{
    rColorId = colorId;
    [self useColor];
    

    [ledLeftButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-L"] forState:UIControlStateNormal];
    
    [ledRightButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-R-on"] forState:UIControlStateNormal];
    
    [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All"] forState:UIControlStateNormal];
    
    
    LeftRight = 1;
    //[self startAnimation];
#pragma mark - kane
//    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
}

- (IBAction)ledBothButton:(id)sender
{
    lColorId = colorId;
    rColorId = colorId;
    [self useColor];
    
    [ledLeftButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-L"] forState:UIControlStateNormal];
    
    [ledRightButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-R"] forState:UIControlStateNormal];
    
    [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All-on"] forState:UIControlStateNormal];
    
    LeftRight = 2;
  
    emulator.animationParameter = _animationParameter;
//    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
}

- (IBAction)vibrateButton:(id)sender
{

    if(isVibrateOn)
    {
        [vibrateButton setImage:[UIImage imageNamed:@"btn_vibrate_OFF"] forState:UIControlStateNormal];
        isVibrateOn = NO;
    }
    else{
        
        [vibrateButton setImage:[UIImage imageNamed:@"btn_vibrate"] forState:UIControlStateNormal];
        isVibrateOn = YES;
        
    }
    
    
}

-(void) setLeftRightButtonStatus:(int)leftRightValue
{
    if(leftRightValue == 0)
    {
        [ledLeftButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-L-on"] forState:UIControlStateNormal];
        
        [ledRightButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-R"] forState:UIControlStateNormal];
        
        [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All"] forState:UIControlStateNormal];
    }
    else if(leftRightValue == 1)
    {
        [ledLeftButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-L"] forState:UIControlStateNormal];
        
        [ledRightButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-R-on"] forState:UIControlStateNormal];
        
        [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All"]forState:UIControlStateNormal];
    }
    else if(leftRightValue == 2)
    {
        [ledLeftButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-L"] forState:UIControlStateNormal];
        
        [ledRightButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-R"] forState:UIControlStateNormal];
        
        [ledBothButton setBackgroundImage:[UIImage imageNamed:@"btn_customFX-led-All-on"]forState:UIControlStateNormal];
    }

}
-(void) setVibrateButtonStatus:(BOOL)isVibrateOn
{
    if(isVibrateOn)
    {
        [vibrateButton setImage:[UIImage imageNamed:@"btn_vibrate"] forState:UIControlStateNormal];
    }
    else{
        
        [vibrateButton setImage:[UIImage imageNamed:@"btn_vibrate_OFF"] forState:UIControlStateNormal];

    }

}

-(void) setSelectedPattern:(int)patternId
{
    
    PatternCell * cell;
    
    for(int i = 0;i < 9;i ++)
    {
        cell = (PatternCell *)[patternCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        if(i == patternId)
        {
            cell.patternButton.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2];
            cell.patternButton.layer.borderWidth = 2.0;
            cell.patternButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.5].CGColor;
        }
        else
        {
            cell.patternButton.backgroundColor = [UIColor clearColor];
            cell.patternButton.layer.borderWidth = 2.0;
            cell.patternButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2].CGColor;
        }
    }
    
    
}

-(void) setSelectedColor:(int)colorId
{
    
}
- (IBAction)backButton:(id)sender
{
    self.isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];

}


- (IBAction)previewButtonClicked
{
    NSLog(@"previewButtonClicked");
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;

    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];

    //写
//    [service writeEffectCommand:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:0 VIBRATE:isVibrateOn LOOP:loop];
    _animationParameter.isVibrate = isVibrateOn;
    [service writeEffectCommand:_animationParameter silent:0];
    
}

- (void)backFxmenuViewController:(FxIconsViewController *)controller Icon:(NSString *)imageName
{

    [self.navigationController popViewControllerAnimated:YES];
    [iconButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]] forState:UIControlStateNormal];
    self.iconName = imageName;
    isFxIconSelected = YES;
    [nameTextField resignFirstResponder];
    NSLog(@"backFxmenuViewController imagename:%@,title:%@",self.iconName,nameTextField.text);
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"fxicons"])
	{
		FxIconsViewController *fxIconsViewController = segue.destinationViewController;
        int lFromR = _animationParameter.lFromR;
        int lFromG = _animationParameter.lFromG;
        int lFromB = _animationParameter.lFromB;
        int lToR = _animationParameter.lToR;
        int lToG = _animationParameter.lToG;
        int lToB = _animationParameter.lToB;
        int rFromR = _animationParameter.rFromR;
        int rFromG = _animationParameter.rFromG;
        int rFromB = _animationParameter.rFromB;
        int rToR = _animationParameter.rToR;
        int rToG = _animationParameter.rToG;
        int rToB = _animationParameter.rToB;
        int durationTime1 = _animationParameter.durationTime1;
        int durationTime2 = _animationParameter.durationTime2;
        int isBlackout = _animationParameter.isBlackout;
        int isRandom = _animationParameter.isRandom;
        int hold = _animationParameter.hold;
        int pause = _animationParameter.pause;
        int isVibrate = _animationParameter.isVibrate;
        int loop = _animationParameter.loop;
        
        self.animationParameterArr = @[[NSNumber numberWithInt:lFromR],[NSNumber numberWithInt:lFromG],[NSNumber numberWithInt:lFromB],[NSNumber numberWithInt:lToR],[NSNumber numberWithInt:lToG],[NSNumber numberWithInt:lToB],[NSNumber numberWithInt:rFromR],[NSNumber numberWithInt:rFromG],[NSNumber numberWithInt:rFromB],[NSNumber numberWithInt:rToR],[NSNumber numberWithInt:rToG],[NSNumber numberWithInt:rToB],[NSNumber numberWithInt:durationTime1],[NSNumber numberWithInt:durationTime2],[NSNumber numberWithInt:isBlackout],[NSNumber numberWithInt:isRandom],[NSNumber numberWithInt:hold],[NSNumber numberWithInt:pause],[NSNumber numberWithInt:isVibrate],[NSNumber numberWithInt:loop]];
        self.isBack = NO;
		fxIconsViewController.delegate = self;
	}
}
#pragma mark _
#pragma mark collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    if(view.tag == 0)
    {
        return 12;
    }
    else
    {
        return 16;
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
    PatternCell *cell;
    ColorCell *colorCell;
    
    if(cv.tag == 0)
    {
        cell = [cv dequeueReusableCellWithReuseIdentifier:pattenCellID forIndexPath:indexPath];
        
        NSString *title;
        switch (indexPath.row) {
            case 0:
                title = @"Long beat";
                break;
                
            case 1:
                title = @"Short beat";
                break;
                
            case 2:
                title = @"Lightning";
                break;
                
            case 3:
                title = @"Flicker";
                break;
                
            case 4:
                title = @"Oscillate";
                break;
                
            case 5:
                title = @"Twinkle";
                break;
                
            case 6:
                title = @"Sirens";
                break;
                
            case 7:
                title = @"Bomb";
                break;
                
            case 8:
                title = @"Pulse";
                break;
                
            case 9:
                title = @"Shimmering";
                break;
                
            case 10:
                title = @"3 Beat";
                break;
                
            case 11:
                title = @"Shine";
                
                break;
        }
        
        
        [cell.patternButton setTitle:title forState:UIControlStateNormal];
        
        cell.patternButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        NSLog(@"%d+++++++%@",indexPath.row,title);
        cell.patternButton.backgroundColor = [UIColor clearColor];
        cell.patternButton.titleLabel.font=[UIFont fontWithName:@"Avenir Next Condensed" size:10];
        [cell.patternButton setEnabled:NO];
        
        cell.patternButton.tag = 10;
#pragma mark - kane
        [cell.patternButton setFont:[UIFont fontWithName:@"Avenir Next Condensed" size:13]];
        cell.patternButton.titleLabel.text = title;
        
        
        
        if(indexPath.row == patternId)
        {
            cell.patternButton.backgroundColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2];
            cell.patternButton.layer.borderWidth = 2.0;
            cell.patternButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:1].CGColor;
            
        }
        else
        {
            cell.patternButton.backgroundColor = [UIColor clearColor];
            cell.patternButton.layer.borderWidth = 2.0;
            cell.patternButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2].CGColor;
        }
        
        
    }
    else
    {
        colorCell = [cv dequeueReusableCellWithReuseIdentifier:colorCellID forIndexPath:indexPath];
        colorCell.colorButton.tag = 11;
        switch (indexPath.row)
        {
            case 0:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor1.r/255.0 green:emColor1.g/255.0   blue:emColor1.b/255.0   alpha:0.5]];

                
                break;
                
            case 1:
                
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_customFX-col-Random01"]]];
                
                [colorCell.colorButton setOpaque:NO];
                
                break;
                
            case 2:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor3.r/255.0   green:emColor3.g/255.0  blue:emColor3.b/255.0   alpha:1]];
                break;
                
                
            case 3:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor4.r/255.0  green:emColor4.g/255.0  blue:emColor4.b/255.0   alpha:1]];
                break;
                
            case 4:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor5.r/255.0  green:emColor5.g/255.0  blue:emColor5.b/255.0   alpha:1]];

                break;
                
            case 5:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor6.r/255.0  green:emColor6.g/255.0  blue:emColor6.b/255.0   alpha:1]];

                break;
                
            case 6:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor7.r/255.0  green:emColor7.g/255.0  blue:emColor7.b/255.0   alpha:1]];

                break;
                
            case 7:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor8.r/255.0  green:emColor8.g/255.0  blue:emColor8.b/255.0   alpha:1]];

                break;
                
            case 8:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor9.r/255.0  green:emColor9.g/255.0  blue:emColor9.b/255.0   alpha:1]];

                break;
                
            case 9:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor10.r/255.0  green:emColor10.g/255.0  blue:emColor10.b/255.0   alpha:1]];
                break;
                
            case 10:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor11.r/255.0  green:emColor11.g/255.0  blue:emColor11.b/255.0   alpha:1]];
                break;
                
            case 11:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor12.r/255.0  green:emColor12.g/255.0  blue:emColor12.b/255.0   alpha:1]];
                break;
                
            case 12:
                [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor13.r/255.0  green:emColor13.g/255.0  blue:emColor13.b/255.0   alpha:1]];
                
                break;
                
            case 13:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor14.r/255.0  green:emColor14.g/255.0  blue:emColor14.b/255.0   alpha:1]];
                break;
                
            case 14:
                  [colorCell.colorButton setBackgroundColor:[UIColor colorWithRed:emColor15.r/255.0  green:emColor15.g/255.0  blue:emColor15.b/255.0   alpha:1]];
                break;
                
            case 15:
                  [colorCell.colorButton setBackgroundColor:[UIColor clearColor]];
                break;
                
            default:
                break;
                
        }
        
        
        colorCell.colorButton.layer.borderWidth = 2.0;
        colorCell.colorButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.3].CGColor;
        
        if(indexPath.row == 15)
        {
            colorCell.colorButton.layer.borderWidth = 0.0;
        }
        
        if(indexPath.row!= 1)
        {
            [colorCell.colorButton setImage:nil  forState:UIControlStateNormal];
        }
        [colorCell.colorButton setEnabled:NO];

        return colorCell;

    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    int selectFxIndex = indexPath.row;
    NSLog(@"selectIndex %d",selectFxIndex);
    
    PatternCell *cell;
    ColorCell *colorCell;
    
    if(collectionView.tag == 0)
    {
        cell = (PatternCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
        cell.patternButton.layer.borderWidth = 2.0;
        cell.patternButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.5].CGColor;
        cell.patternButton.backgroundColor =[UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2];

        patternId = indexPath.row;
        presetPattern presetPatternTemp;
        
        switch (patternId) {
            case 0://Long Beat
                
                presetPatternTemp = emPatternLongBeat;
                break;
                
            case 1://Short Beat
                presetPatternTemp = emPatternShortBeat;
                break;
                
            case 2://Lightning
                
                presetPatternTemp = emPatternLighting;
                break;
                
            case 3://Flicker
                presetPatternTemp = emPatternFlicker;
                
                break;
                
            case 4://Oscillate
                presetPatternTemp = emPatternOscillate;
                break;
                
            case 5://Twinkle
                presetPatternTemp = emPatternTwinkle;
                break;
                
            case 6://Sirens
                presetPatternTemp = emPatternSirens;
                break;
                
            case 7://Bomb
                presetPatternTemp = emPatternBomb;
                break;
                
            case 8://Pulse
                presetPatternTemp = emPatternPulse;
                break;
                
            case 9://Shimmering
                presetPatternTemp = emPatternShimmering;
                break;
                
            case 10://Tree Beat
                presetPatternTemp = emPatternTreeBeat;
                break;
                
            case 11://Shine
                presetPatternTemp = emPatternShine;
                break;
                
            default:
                break;
        }
        isReversed = presetPatternTemp.isReversed;
//        durationTime1 = presetPatternTemp.durationTime1;
//        durationTime2 = presetPatternTemp.durationTime2;
//        pause = presetPatternTemp.pause;
//        hold = presetPatternTemp.hold;
//        isBlackout = presetPatternTemp.isBlackout;
//        loop = presetPatternTemp.loop;

        _animationParameter.durationTime1 = presetPatternTemp.durationTime1;
        _animationParameter.durationTime2 = presetPatternTemp.durationTime2;
        _animationParameter.pause = presetPatternTemp.pause;
        _animationParameter.hold = presetPatternTemp.hold;
        _animationParameter.isBlackout = presetPatternTemp.isBlackout;
        _animationParameter.loop = presetPatternTemp.loop;
        
        /*
        durationTime1 = presetPatternTemp.durationTime1;
        durationTime2 = presetPatternTemp.durationTime2;
        isReversed = presetPatternTemp.isReversed;
        pause = presetPatternTemp.pause;
        hold = presetPatternTemp.hold;
        isBlackout = presetPatternTemp.isBlackout;
        loop = presetPatternTemp.loop;
        
        NSLog(@"durationTime1=%d,hold=%d,durationTime2=%d,pause=%d,loop=%d,isBlackout=%d,isReversed=%d",durationTime1,hold,durationTime2,pause,loop,isBlackout,isReversed);
         */

    }
    else
    {
        
        colorCell = (ColorCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        
#pragma mark - kane
        NSLog(@"%f=======%f",colorCell.frame.size.height,colorCell.frame.size.width);
        NSLog(@"%f=======%f",colorCell.frame.origin.x,colorCell.frame.origin.y);
        
        colorId = indexPath.row;
        
//        CGPoint zxkpoint = [colorCell convertPoint:CGPointMake(0,0) toView:self.view];
//        self.colorCellBoardView.frame = CGRectMake(zxkpoint.x, zxkpoint.y,67,43);
        if(colorId != 15)
        {
            self.colorCellBoardView.center = colorCell.center;
            if(self.colorCellBoardView.hidden == YES)
            {
                self.colorCellBoardView.hidden = NO;
            }
        }
        

        if(LeftRight == 0)
        {
            
            lColorId = colorId;
        }
        else if(LeftRight == 1)
        {
            rColorId = colorId;
        }
        else if(LeftRight == 2)
        {
            lColorId = colorId;
            rColorId = colorId;
        }
        
    }
    
    [self useColor];
//     NSLog(@"lFromR=%d,lFromG=%d,lFromB=%d,lToR=%d,lToG=%d,lToB=%d,rFromR=%d,rFromG=%d,rFromB=%d,rToR=%d,rToG=%d,rToB=%d",lFromR,lFromG,lFromB,lToR,lToG,lToB,rFromR,rFromG,rFromB,rToR,rToG,rToB);
    
    if(colorId != 15)
    {
        emulator.animationParameter = _animationParameter;
//        [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    
    NSLog(@"didDeselectItemAtIndexPath = %d",indexPath.row);
    int selectIndex = indexPath.row;
    PatternCell *cell;
    ColorCell *colorCell;
    
    if(collectionView.tag == 0)
    {
        cell = (PatternCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
        
        cell.patternButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2].CGColor;
        cell.patternButton.backgroundColor = [UIColor clearColor];
    }
    else
    {
        colorCell = (ColorCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
        
    }

}

-(ccColor3B)getColorWithColorId:(int)colorId
{
    ccColor3B colorTemp;
    
    switch (colorId) {
        case 0:
            
            colorTemp = emColor1;
            break;
            
        case 1:
            colorTemp = emSilver;//random
            
            break;
            
        case 2:
            colorTemp = emColor3;
            break;
            
        case 3:
            colorTemp = emColor4;
            break;
            
        case 4:
            colorTemp = emColor5;
            break;
            
        case 5:
            colorTemp = emColor6;
            break;
            
        case 6:
            colorTemp = emColor7;
            break;
            
        case 7:
            colorTemp = emColor8;
            break;
            
        case 8:
            colorTemp = emColor9;
            break;
            
        case 9:
            colorTemp = emColor10;
            break;
            
        case 10:
            colorTemp = emColor11;
            break;
            
        case 11:
            colorTemp = emColor12;
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
            
        case 15:
            colorTemp = emColor16;
            break;
            
        default:
            break;
    }
    
    if(colorId == 1)
    {
        _animationParameter.isRandom = 1;
//        isRandom = 1;
    }
    else
    {
        _animationParameter.isRandom = 0;
//        isRandom = 0;
    }

    return colorTemp;
}

-(void)useColor
{
    lColorTemp = [self getColorWithColorId:lColorId];
    rColorTemp = [self getColorWithColorId:rColorId];
    
    /*
    if(isReversed == 0)
    {
        lToR = lColorTemp.r;
        lToG = lColorTemp.g;
        lToB = lColorTemp.b;

        lFromR = 256;
        lFromG = 0;
        lFromB = 0;

        rToR = rColorTemp.r;
        rToG = rColorTemp.g;
        rToB = rColorTemp.b;

        rFromR = 256;
        rFromG = 0;
        rFromB = 0;
    
    }
    else
    {
        lToR = lColorTemp.r;
        lToG = lColorTemp.g;
        lToB = lColorTemp.b;
        
        lFromR = 256;
        lFromG = 0;
        lFromB = 0;
        
        rFromR = rColorTemp.r;
        rFromG = rColorTemp.g;
        rFromB = rColorTemp.b;
        
        rToR = 256;
        rToG = 0;
        rToB = 0;
    }
    */
    if(isReversed == 0)
    {
        
        _animationParameter.lToR = lColorTemp.r;
        _animationParameter.lToG = lColorTemp.g;
        _animationParameter.lToB = lColorTemp.b;
        
        _animationParameter.lFromR = 256;
        _animationParameter.lFromG = 0;
        _animationParameter.lFromB = 0;
        
        _animationParameter.rToR = rColorTemp.r;
        _animationParameter.rToG = rColorTemp.g;
        _animationParameter.rToB = rColorTemp.b;
        
        _animationParameter.rFromR = 256;
        _animationParameter.rFromG = 0;
        _animationParameter.rFromB = 0;
        
    }
    else
    {
        _animationParameter.lToR = lColorTemp.r;
        _animationParameter.lToG = lColorTemp.g;
        _animationParameter.lToB = lColorTemp.b;
        
        _animationParameter.lFromR = 256;
        _animationParameter.lFromG = 0;
        _animationParameter.lFromB = 0;
        
        _animationParameter.rFromR = rColorTemp.r;
        _animationParameter.rFromG = rColorTemp.g;
        _animationParameter.rFromB = rColorTemp.b;
        
        _animationParameter.rToR = 256;
        _animationParameter.rToG = 0;
        _animationParameter.rToB = 0;
    }
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{

    
    
}
//- (void)viewDidDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
//{
//    NSLog(@"AddFx viewDidDisappear");
//
//    
//}
- (void) dealloc
{
    [super dealloc];
    
    [backButton release];
    [fxLabel release];
    [cancelButton release];
    [iconButton release];
    [nameLabel release];
    [nameTextField release];
    [iconLabel release];
    
    [previewButton release];
    [patternCollectionView release];
    [colorCollectionView release];
    [patternPageControl release];
    [colorPageControl release];
    
    [line1 release];
    [line2 release];
    [line3 release];
    
    [doneButton release];
    [ledLeftButton release];
    [ledRightButton release];
    [ledBothButton release];
    [vibrateButton release];
  
}
@end
