//
//  ConnectingViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-13.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFIndicatorView.h"
@interface ConnectingViewController : UIViewController
{
    //TFIndicatorView *indicatorView;
    UIActivityIndicatorView *indicatorView;
    
    IBOutlet UIView *connectedLabel;
    IBOutlet UILabel *scanLabel;
    IBOutlet UILabel *embraceLabel;
    IBOutlet UILabel *successLabel;
}
//@property (nonatomic, retain) TFIndicatorView *indicatorView;
@property (nonatomic, retain) UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) UIView *connectedLabel;
@end
