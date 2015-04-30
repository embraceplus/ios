//
//  FxIconsViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-20.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineLayout.h"
#import "AppDelegate.h"
@class FxIconsViewController;

@protocol fxIconDelegate <NSObject>
- (void)backFxmenuViewController:(FxIconsViewController *)controller Icon:(NSString *)imageName;
@end
@interface FxIconsViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UIImageView *line1;
    IBOutlet UILabel *fxIconLabel;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIScrollView *fxIconScrollView;
    IBOutlet UIImageView *iconPickSelectImageView;
    
    NSMutableArray *imageNameArray;
    AppDelegate *appDelegate;
}
@property (nonatomic, weak) id <fxIconDelegate> delegate;
@property(nonatomic,weak)NSArray *animationParameterArr;
@end
