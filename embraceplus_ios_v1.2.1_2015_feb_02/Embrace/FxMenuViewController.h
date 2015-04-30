//
//  FxMenuViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FxmenuItem.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "AppDelegate.h"
#import "BaseFxMenuViewController.h"

#define TI_KEYFOB_PROXIMITY_ALERT_UUID                      0x1802
#define stepper   0x2A06
@class FxMenuViewController;



@interface FxMenuViewController :BaseFxMenuViewController
{

    IBOutlet UIImageView *line2;
    
    
    NSTimer *sendTimer;
    
    
    //int selectFxIndex;    //记住所选的fx序号
    //AppDelegate *appDelegate;
}


//@property (nonatomic, strong) id <fxmenuDelegate> delegate;





@end
