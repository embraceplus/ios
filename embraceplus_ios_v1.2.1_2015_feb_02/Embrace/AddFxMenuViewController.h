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

@protocol addFxmenuDelegate <NSObject>

- (void)backNotificationViewController:(AddFxMenuViewController *)controller iconImageName:(NSString *)imageName fxTitle:(NSString *)fxTitle lFromR:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause VIBRATE:(int)vibrate LOOP:(int)loop;

@end
@interface AddFxMenuViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,/*UITableViewDataSource,UITableViewDelegate,*/UITextFieldDelegate,/*UIScrollViewDelegate,*/fxIconDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UILabel *fxLabel;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *iconButton;
    IBOutlet UILabel *nameLabel;
    IBOutlet UITextField *nameTextField;
    IBOutlet UILabel *iconLabel;
    IBOutlet UILabel *colorPickerLabel;
    IBOutlet UIButton *previewButton;
 
    IBOutlet UICollectionView *patternCollectionView;
    IBOutlet UICollectionView *colorCollectionView;
    
    IBOutlet UIPageControl *patternPageControl;
    IBOutlet UIPageControl *colorPageControl;

    //IBOutlet UIImageView *colorPickSelectImageView;
    NSMutableArray *imageNameArray;
    //NSArray *lightPatternArray;
    NSString *iconName;
    IBOutlet UIImageView *line1;
    IBOutlet UIImageView *line2;
    IBOutlet UIImageView *line3;
    
    IBOutlet UIButton *doneButton;

    IBOutlet UIButton *ledLeftButton;
    IBOutlet UIButton *ledRightButton;
    IBOutlet UIButton *ledBothButton;
    IBOutlet UIButton *vibrateButton;
    BOOL isVibrateOn;
    
    AppDelegate *appDelegate;
    
    NSMutableArray *titleArray;
    
    NSMutableDictionary *customFxConfigDic;
    
    int patternId;
    
    int colorId;
    int lColorId;
    int rColorId;
    
    int LeftRight; //0 Left 1 Right 2 Both
    
    
    EmulatorView* emulator;
    
//    int lFromR;
//    int lFromG;
//    int lFromB;
//    int lToR;
//    int lToG;
//    int lToB;
//    int rFromR;
//    int rFromG;
//    int rFromB;
//    int rToR;
//    int rToG;
//    int rToB;
//    int durationTime1;
//    int durationTime2;
//    int isBlackout;
//    int isRandom;
//    int hold;
//    int pause;
//    int loop;
    
    int isReversed;
    
    ccColor3B lColorTemp;
    ccColor3B rColorTemp;
    
    BOOL isFxIconSelected;

}
@property (nonatomic, assign) id <addFxmenuDelegate> delegate;
@property(nonatomic,copy)AnimationParameter* animationParameter;
@property(nonatomic,copy)NSArray* animationParameterArr;
@property (nonatomic, retain) NSString *iconName;
@property int styleIndex;
@property int fxIndex;
@property bool isEdit;
- (IBAction)previewButtonClicked;

//-(void) startAnimation;
-(void) setLeftRightButtonStatus:(int)leftRightValue;
-(void) setVibrateButtonStatus:(BOOL)isVibrateOn;
-(void) setSelectedPattern:(int)patternId;
-(void) setSelectedColor:(int)colorId;

@end
