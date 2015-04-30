//
//  AddFxMenuViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-15.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FxIconsViewController.h"
#import "AppDelegate.h"
#import "AnimationParameter.h"
#import "EmulatorView.h"

@class AddFxMenuViewController;


@interface GrandfatherClockViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,fxIconDelegate,UIAlertViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *fxLabel;

    IBOutlet UILabel *colorPickerLabel;
    IBOutlet UIButton *previewButton;
    
    IBOutlet UILabel *startLabel;
    IBOutlet UISwitch *startSwitch;
    
    
    IBOutlet UICollectionView *colorCollectionView;
    IBOutlet UIPageControl *colorPageControl;

    IBOutlet UIImageView *colorPickSelectImageView;
    
    NSMutableArray *imageNameArray;
    NSArray *lightPatternArray;
    NSString *iconName;
    IBOutlet UIImageView *line1;
    IBOutlet UIImageView *line2;
    IBOutlet UIImageView *line3;
    
    IBOutlet UISegmentedControl *countSegment;
    IBOutlet UISegmentedControl *vibrateSegment;
    IBOutlet UISegmentedControl *halfHourSegment;
    
    IBOutlet UILabel *countLabel;
    IBOutlet UILabel *vibrationLabel;
    IBOutlet UILabel *halfhourLabel;
    
    AppDelegate *appDelegate;
    
    NSMutableArray *titleArray;
    
    int colorId;

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
    int isReversed;
    
    int hold;
    int pause;
     */
    
    ccColor3B colorTemp;
    
    BOOL isHourly;
    int  count;
    BOOL isVibration;
    BOOL isHalfHour;
    BOOL isStart;
    
    double timerStartValueInSecond;
    NSMutableDictionary *grandfatherClockConfigDic;
    
    EmulatorView* emulator;

}

@property (strong) AnimationParameter* animationParameter;

@property (nonatomic, retain) NSString *iconName;
@property int styleIndex;
@property int fxIndex;
@property bool isEdit;
- (IBAction)previewButtonClicked;
- (IBAction)vibrateSegmentValueChange:(UISegmentedControl *)Seg;
- (IBAction)countSegmentValueChange:(UISegmentedControl *)Seg;
- (IBAction)halfHourSegmentValueChange:(UISegmentedControl *)Seg;
- (IBAction)switchAction:(id)sender;

@end
