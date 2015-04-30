//
//  Help1ContentViewController.h
//  Embrace ios7
//
//  Created by Jim on 14-5-10.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface HelpContentViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *nextButton;
    IBOutlet UILabel *helpLabel;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *line1;
    IBOutlet UITableView *helpTableView;
    
    UIScrollView *scrollView;
    AppDelegate *appDelegate;
    
    NSArray *helpContentName;
    NSArray *helpTitleArray;
}
@property int currentHelpIndex;

#pragma mark - 最后一个标签 kane
@property(nonatomic,assign)BOOL isLast;
@end
