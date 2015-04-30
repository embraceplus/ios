//
//  addStyleViewController.h
//  Embrace
//
//  Created by s1 dred on 13-8-16.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class addStyleViewController;

@protocol addStyleDelegate <NSObject>
- (void)backStyleViewController:(addStyleViewController *)controller iconImagePath:(NSString *)imageName styleTitle:(NSString *)fxTitle isEdit:(BOOL)isEdit;

- (void)backStyleViewControllerWithoutDone;
@end

@interface addStyleViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *doneButton;
    
    IBOutlet UIButton *placeHolderButton;
    
    IBOutlet UILabel *addstyleLabel;
//    IBOutlet UILabel *cameraLabel;
//    IBOutlet UILabel *galleryLabel;
    IBOutlet UILabel *styleimageLabel;
    
//    IBOutlet UILabel *bgCameraLabel;
//    IBOutlet UILabel *bgGalleryLabel;
    
    IBOutlet UIButton *bgCameraButton;
    IBOutlet UIButton *bgGalleryButton;
    IBOutlet UIButton *styleCameraButton;
    IBOutlet UIButton *styleGalleryButton;
    
    IBOutlet UILabel *bgStyleimageLabel;

    IBOutlet UILabel *nameLabel;
    IBOutlet UIImageView *backgroundImageView;
    IBOutlet UIImageView *line1;
    IBOutlet UIImageView *line2;
    IBOutlet UIImageView *line3;
    IBOutlet UITextField *styleNameTextField;
    
    IBOutlet UIImageView *styleBackgroundImageView;

    NSMutableArray *styleTitleArray; 
    NSMutableArray *styleImages;
    
    UIImage *addImage;
    UIImage *addBgImage;
    
    int styleNum;   //已存在的style数目（含add style）
    
    int addImageStype;
    
    BOOL isStylePicSelected;
    BOOL isStyleBgPicSelected;
    
    AppDelegate *appDelegate;
    
    UIActivityIndicatorView* indicator;
}
@property (nonatomic, assign) id <addStyleDelegate> delegate;
@property int styleNum;
@property bool isEdit;
@end
