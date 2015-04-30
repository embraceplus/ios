//
//  BaseFxMenuViewController.h
//  Embrace ios7
//
//  Created by 张达棣 on 14-1-8.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLayout.h"
#import "AddFxMenuViewController.h"

#import "AnimationParameter.h"
#import "EmulatorView.h"

@interface BaseFxMenuViewController : UIViewController<addFxmenuDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
{
    IBOutlet UIButton *actionsheetButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UICollectionView *fxMenuCollectionView;
    IBOutlet UIButton *backButton;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIButton *previewButton;
    IBOutlet UIImageView *line1;
    IBOutlet UILabel *fxLabel;
    IBOutlet UIPageControl *pageControl;
    
    NSMutableDictionary *fxForStyleDic;
    NSMutableDictionary *styleDictionary;
    NSMutableDictionary *notificationDictionary;
    NSMutableDictionary *fxMenuLightDataDic;
    
    NSMutableArray *titleArray;
    NSMutableArray *imageNameArray;
    
    NSMutableArray *notificationTitles;
    NSMutableArray *notificationIsSilent;
    NSMutableArray *callsNotificationIsSilent;
    
    AnimationParameter* animationParameter;
    EmulatorView* emulator;
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
    int isVibrate;
    int loop;
     */
    
    BOOL isEdit;
    int selectFxIndex;
    int cellNumPerPage;
    
    int defaultFxNum;
}

@property int styleIndex;
@property int notificationIndex;


#pragma mark -kane



- (IBAction)previewButtonClicked;
- (void)updatePageControl;

@end
