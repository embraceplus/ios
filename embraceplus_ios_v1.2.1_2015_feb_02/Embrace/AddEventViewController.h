//
//  AddEventViewController.h
//  Embrace
//
//  Created by s1 dred on 13-9-5.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class AddEventViewController;
@protocol addEventViewDelegate <NSObject>
- (void)backNotificationViewControllerFromAddEvent:(AddEventViewController*)controller iconImagePath:(NSString *)imageName notificationTitle:(NSString *)notificationTitle;
@end

@interface AddEventViewController : UIViewController
{
    IBOutlet UILabel *addEventLabel;
    IBOutlet UITableView *addEventTableView;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIButton *backButton;
    IBOutlet UIImageView *line1;
    NSArray* viewControllers;
	NSArray* indexImages;
    
    
    NSMutableArray *notificationTitles;
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) id <addEventViewDelegate> delegate;

@end
