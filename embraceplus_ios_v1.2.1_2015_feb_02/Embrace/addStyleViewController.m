//
//  addStyleViewController.m
//  Embrace
//
//  Created by s1 dred on 13-8-16.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import "addStyleViewController.h"
#import "AppDelegate.h"
#import "FilePath.h"
@interface addStyleViewController ()

@end

@implementation addStyleViewController
@synthesize delegate;
@synthesize styleNum;
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
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
	// Do any additional setup after loading the view.
    nameLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    nameLabel.frame = CGRectMake(13, 68 + deltaY, 54, 21);
    
    styleNameTextField.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    styleimageLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    styleimageLabel.frame = CGRectMake(15, 125 + deltaY, 94, 32);
    
    
    addstyleLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    
    
    bgStyleimageLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:20];
    bgStyleimageLabel.frame = CGRectMake(15, 362 + deltaY, 100, 32);
    
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    doneButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    placeHolderButton.frame = CGRectMake(210, 128 + deltaY, 94, 204);
    placeHolderButton.backgroundColor = [UIColor clearColor];
    placeHolderButton.layer.borderWidth = 3.0;
    placeHolderButton.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.3].CGColor;
    styleBackgroundImageView.frame = CGRectMake(210+3, 128+ 3+ deltaY, 88, 198);
    styleCameraButton.frame = CGRectMake(127, 125 + deltaY, 70, 69);
    styleGalleryButton.frame = CGRectMake(127, 205 + deltaY, 70, 69);
    
    bgCameraButton.frame = CGRectMake(127, 374 + deltaY, 70, 69);
    bgGalleryButton.frame = CGRectMake(207, 374 + deltaY, 70, 69);
    
    
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    doneButton.frame = CGRectMake(248, 8 + deltaY, 55, 33);
    line3.frame = CGRectMake(0, 354 + deltaY, 320, 2);
    CGRect chooseLabelFrame = addstyleLabel.frame;
    chooseLabelFrame.origin.y = 7 + deltaY;
    addstyleLabel.frame = chooseLabelFrame;

    appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if(isEdit)
    {
        isStylePicSelected = YES;
        isStyleBgPicSelected = YES;
        backgroundImageView.image = appDelegate.backgroundImage;
    }
    else
    {
        isStylePicSelected = NO;
        isStyleBgPicSelected = NO;
        backgroundImageView.image = appDelegate.backgroundImage;
    }
    
    
    if(isEdit)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath styleFxmenuTitleFilePath]])
        {
            styleTitleArray = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath styleFxmenuTitleFilePath]];
            styleImages = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath styleFxmenuImageFilePath]];
        }
    }
    
    NSLog(@"viewWillAppear");
    NSString *filePath;
    NSArray *paths;
    NSString *documentsDirectory;
    
    if(isEdit)
    {
        styleNameTextField.text = [styleTitleArray objectAtIndex:styleNum];
        NSData *image = [NSData dataWithContentsOfFile:[styleImages objectAtIndex:styleNum]];
        [styleBackgroundImageView setImage:[UIImage imageWithData:image]];
        
        addImage = [UIImage imageWithData:image];
        [addImage retain];
        
        paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"styleBgImageView%d.png",styleNum-9]];
        
        [backgroundImageView setImage:[UIImage imageWithContentsOfFile:filePath]];
        addBgImage = [UIImage imageWithContentsOfFile:filePath];
        [addBgImage retain];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
       [super viewWillAppear:YES];
    
}
- (IBAction)backgroundSelect:(id)sender
{
    UIButton *button = (UIButton *)sender;
    UIImagePickerController *myPicker=[[UIImagePickerController alloc] init];
    myPicker.delegate=self;
    switch (button.tag) {
        case 22:     
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                //同樣檢查是否有相機功能，若沒有則不啟動
                myPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:myPicker animated:YES completion:nil];
                [myPicker release];
                
                addImageStype = 1;
            }
        }
            break;
        case 21:
        {
            //從相機取出圖片
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                //檢查是否有相機功能
                myPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:myPicker animated:YES completion:nil];
                [myPicker release];
                
                addImageStype = 1;
            }
        }
            break;
        case 32:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
                //同樣檢查是否有相機功能，若沒有則不啟動
                myPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:myPicker animated:YES completion:nil];
                [myPicker release];
                
                addImageStype = 0;
            }
        }
            break;
        case 31:
        {
            //從相機取出圖片
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                //檢查是否有相機功能
                myPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:myPicker animated:YES completion:nil];
                [myPicker release];
                
                addImageStype = 0;
            }
        }
            break;
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
 

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self showIndicator];
    NSLog(@"image !!!!! = %f x %f",image.size.width,image.size.height);
    [image retain];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
   
        if(addImageStype == 0)
        {
            float scale = 1.0;
            if(189.0/image.size.width > 409.0/image.size.height)
            {
                scale = 189.0/image.size.width;
            }
            else
            {
                scale = 409.0/image.size.height;
            }
            UIGraphicsBeginImageContext(CGSizeMake(189.0,409.0));
            [image drawInRect:CGRectMake(0, 0, image.size.width*scale, image.size.height*scale)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [scaledImage retain];
            addImage = scaledImage;
            
            //addImage = image;
            //NSData* imageData = UIImagePNGRepresentation(scaledImage);
            //[styleBackgroundImageView setImage:[UIImage imageWithData:imageData]];
            //styleBackgroundImageView.image = addImage;
            isStylePicSelected = YES;
            
//            if(addBgImage!=nil)
//                backgroundImageView.image =addBgImage;
        }
        else
        {
            CGSize winsize = [UIScreen mainScreen].bounds.size;
            float scale = 1.0;
            if((winsize.width*2)/image.size.width > (winsize.height*2)/image.size.height)
            {
                scale = (winsize.width*2)/image.size.width;
            }
            else
            {
                scale = (winsize.height*2)/image.size.height;
            }
            
            UIGraphicsBeginImageContext(CGSizeMake(640,1136));
            [image drawInRect:CGRectMake(0, 0, image.size.width*scale, image.size.height*scale)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSLog(@"image = %f x %f",scaledImage.size.width,scaledImage.size.height);
            [scaledImage retain];
            addBgImage = scaledImage;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:[NSNumber numberWithBool:YES] forKey:@"isChangeBg"];
            
            
            //backgroundImageView.image =addBgImage;
            isStyleBgPicSelected = YES;
            
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(addImageStype == 0)
            {
                styleBackgroundImageView.image = addImage;
                if(addBgImage!=nil)
                    backgroundImageView.image =addBgImage;
            }
            else
            {
                backgroundImageView.image =addBgImage;
            }
            
            [self hideIndicator];
        });

    });

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //若使用者在ImagePicker按下取消按鈕則關閉ImagePicker
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)back:(id)sender
{
    [self.delegate backStyleViewControllerWithoutDone];
    //[self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)doneButton:(id)sender
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if([styleNameTextField text].length == 0)
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"Style Name can not be empty"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if(!isStylePicSelected)
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"Please select a style image"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        
        return;

        
    }
    
    if(!isStyleBgPicSelected)
    {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                       message:@"Please select a style background image"
                                                      delegate:self
                                             cancelButtonTitle:@"ok"
                                             otherButtonTitles:nil];
        [alert show];
        
        return;
        
        
    }
    else
    {
        //[self showIndicator];
        NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"styleImageView%d.png",styleNum-10]];//styleImageView0开始
        
        NSData* imageData = UIImagePNGRepresentation(addImage);
        [imageData writeToFile:fullPathToFile atomically:YES];
        
        NSString* fullPathToFileBg = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"styleBgImageView%d.png",styleNum-10]];//styleImageView0开始
        
        
        imageData = UIImagePNGRepresentation(addBgImage);
        [imageData writeToFile:fullPathToFileBg atomically:YES];
        

        [self.delegate backStyleViewController:self iconImagePath:fullPathToFile styleTitle:styleNameTextField.text isEdit:isEdit];
    }

    
}

-(void) showIndicator
{
    
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 110, 50)];
    label.text =@"Saving";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    
    indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
    
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    [indicator setCenter:CGPointMake(winsize.width / 2, winsize.height / 2)];
    
    indicator.backgroundColor = [UIColor blackColor];
    [indicator addSubview:label];
    
    //indicator.alpha = 0.5;
    
    indicator.layer.cornerRadius = 6;
    //indicator.layer.masksToBuounds = YES;
    
    [self.view  addSubview:indicator];
    
    [indicator startAnimating];
}

-(void) hideIndicator
{
    [indicator stopAnimating];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [super dealloc];
    [backButton release];
    [doneButton release];
    [addstyleLabel release];
    [styleimageLabel release];
    
    [bgStyleimageLabel release];
 
    [nameLabel release];
    [backgroundImageView release];
    [line1 release];
    [line2 release];
    [line3 release];
    [styleNameTextField release];
    [styleBackgroundImageView release];
    
}
@end
