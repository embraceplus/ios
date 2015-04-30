//
//  BaseFxMenuViewController.m
//  Embrace ios7
//
//  Created by 张达棣 on 14-1-8.
//  Copyright (c) 2014年 d-red puma. All rights reserved.
//

#import "BaseFxMenuViewController.h"
//#import "EmbLayer.h"
#import "LeDiscovery.h"
#import "LeEmbraceService.h"
#import "Cell.h"
#import "FilePath.h"
#import "NotificationUtility.h"
NSString *kCellID = @"cellID";
@interface BaseFxMenuViewController ()

@end


@implementation BaseFxMenuViewController



@synthesize notificationIndex;
@synthesize styleIndex;

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
	// Do any additional setup after loading the view.
    
    float iosVersion;
    float deltaY = 0;
    iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(iosVersion>=7.0)
        deltaY = 20;
    
    
    
    backButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    backButton.frame = CGRectMake(15, 8 + deltaY, 56, 34);
    
    previewButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    
    doneButton.titleLabel.font=[UIFont fontWithName:@"Avenir" size:15];
    doneButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    doneButton.frame = CGRectMake(248, 8 + deltaY, 55, 33);
    doneButton.hidden = YES;
    actionsheetButton.frame = CGRectMake(268, 8 + deltaY, 34, 34);
    
    line1.frame = CGRectMake(0, 47 + deltaY, 320, 2);
    //fxMenuCollectionView.frame = CGRectMake(19, 86, 286, 273);
    
    fxLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:25];
    CGRect chooseLabelFarme = fxLabel.frame;
    chooseLabelFarme.origin.y = 10+ deltaY;
    fxLabel.frame = chooseLabelFarme;
    
    if (iPhone5)
    {
        previewButton.frame = CGRectMake(122, 514+deltaY, 77, 30);
        
    }
    else
    {
        previewButton.frame = CGRectMake(122, 514-88+deltaY, 77, 30);
        
    }

    NSLog(@"BaseFxMenuViewController = %d",notificationIndex);
    
    if(styleIndex<9)
    {
        defaultFxNum = 6;
    }
    else
    {
        defaultFxNum = 24;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
    {
        fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
        styleDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",styleIndex]];
        
        notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        
        NSLog(@"select style = %d",styleIndex);
        
        titleArray = [styleDictionary objectForKey:@"title"];
        imageNameArray = [styleDictionary objectForKey:@"image"];
        
        selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",notificationIndex]] intValue];
       
        
#pragma mark - kane
        if([UserInfo sharedInstance].isChangeText == YES)
        {
            if([UserInfo sharedInstance].isText == YES)
            {
                [UserInfo sharedInstance].isChangeText = NO;
                [UserInfo sharedInstance].isText = NO;
                [self collectionView:fxMenuCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2]];
            }
            
        }
        if ([UserInfo sharedInstance].isChangeCalendar == YES)
        {
            if([UserInfo sharedInstance].isCalendar == YES)
            {
                [UserInfo sharedInstance].isChangeCalendar = NO;
                [UserInfo sharedInstance].isCalendar = NO;
                [self collectionView:fxMenuCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            }
        }
        if ([UserInfo sharedInstance].isChangeBattery == YES)
        {
            if([UserInfo sharedInstance].isBattery == YES)
            {
                [UserInfo sharedInstance].isChangeBattery = NO;
                [UserInfo sharedInstance].isBattery = NO;
                [self collectionView:fxMenuCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            }
        }
        
    }
    
    NSString *notificationTitle;
    if(notificationIndex<100)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
        {
            
            notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
            
        }
        
        if(notificationIndex > 0 && notificationIndex < [notificationTitles count]-1)
        {
            notificationTitle = [notificationTitles objectAtIndex:notificationIndex];
            [fxLabel setText:notificationTitle];
            //[notificationTitle release];
        }
        
    }
    else if(notificationIndex<200)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationTitleFilePath]])
        {
            
            notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationTitleFilePath]];
            
        }
        
        notificationTitle = [notificationTitles objectAtIndex:notificationIndex-100];
        [fxLabel setText:notificationTitle];
        
        
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationIsSilentFilePath]])
    {
        
        notificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationIsSilentFilePath]];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
    {
        
        callsNotificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
    {
        fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updatePageControl];
    
    /*
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        [EmbLayer switchPicture:0];
        [director startAnimation];
        
    }
    else
    {
        
        [director runWithScene:[EmbLayer scene:0]];
        [self.view addSubview:director.view];
        [self.view sendSubviewToBack:director.view];
        
    }
     */
    
    
    LineLayout* lineLayout = [[LineLayout alloc] init];
    [fxMenuCollectionView setCollectionViewLayout:lineLayout];
    [lineLayout release];
    
    isEdit = NO;
    doneButton.hidden = YES;
    actionsheetButton.hidden = NO;
    [fxMenuCollectionView reloadData];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectFxIndex inSection:0];
    [fxMenuCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    
    ////////////////
    
    NSLog(@"FX name =%@",[titleArray objectAtIndex:selectFxIndex]);
    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
    
    /*
    lFromR = [[lightDataArray objectAtIndex:0] intValue];    //L灯 R  (From)
    lFromG= [[lightDataArray objectAtIndex:1] intValue];    //L灯 G  (From)
    lFromB = [[lightDataArray objectAtIndex:2] intValue];    //L灯 B  (From)
    
    lToR = [[lightDataArray objectAtIndex:3] intValue];    //L灯 R  (To)
    lToG = [[lightDataArray objectAtIndex:4] intValue];    //L灯 G  (To)
    lToB = [[lightDataArray objectAtIndex:5] intValue];    //L灯 B  (To)
    
    
    rFromR= [[lightDataArray objectAtIndex:6] intValue];    //R灯 R  (From)
    rFromG= [[lightDataArray objectAtIndex:7] intValue];    //R灯 G  (From)
    rFromB= [[lightDataArray objectAtIndex:8] intValue];    //R灯 B  (From)
    
    rToR = [[lightDataArray objectAtIndex:9] intValue];    //R灯 R  (To)
    rToG = [[lightDataArray objectAtIndex:10] intValue];    //R灯 G  (To)
    rToB = [[lightDataArray objectAtIndex:11] intValue];    //R灯 B  (To)
    
    durationTime1 = [[lightDataArray objectAtIndex:12] intValue];    //duration
    durationTime2 = [[lightDataArray objectAtIndex:13] intValue];    //duration
    
    isBlackout = [[lightDataArray objectAtIndex:14] intValue];
    isRandom = [[lightDataArray objectAtIndex:15] intValue];
    hold = [[lightDataArray objectAtIndex:16] intValue];
    pause = [[lightDataArray objectAtIndex:17] intValue];
    isVibrate = [[lightDataArray objectAtIndex:18] intValue];
    loop = [[lightDataArray objectAtIndex:19] intValue];
    
    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
    
    NSLog(@"%@",self.navigationController.title);
     */
    NSString* file = [FilePath fxMenuLightDataFilePath];
    NSString* title = [titleArray objectAtIndex:selectFxIndex];

    animationParameter = [AnimationParameter createFromFile:file title:title];
//    [EmbLayer SelectEffect:animationParameter];
    emulator = [EmulatorView emulator:animationParameter];
    [emulator showInView:self.view];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
//    if([director runningScene] != nil)
//    {
//        [director startAnimation];
//    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [emulator removeFromSuperview];
    [emulator stopRuning];
    emulator = nil;
}

- (IBAction)actionSheetButton:(id)sender
{
    UIActionSheet *actionSheet;
    if ([titleArray count] > defaultFxNum) {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles:@"Edit", @"Add",nil];
        actionSheet.tag = 101;
    }
    else {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:nil
                       delegate:self
                       cancelButtonTitle:@"Cancel"
                       destructiveButtonTitle:nil
                       otherButtonTitles: @"Add",nil];
        actionSheet.tag = 102;
    }
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    //[actionSheet release];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
            {
                isEdit = YES;
                [fxMenuCollectionView reloadData];
                //选择Edit模式后跳到fx 可编辑页 jump to editable item
                //[fxMenuCollectionView setContentOffset:CGPointMake(fxMenuCollectionView.frame.size.width, 0)];
                
                //scroll to the right
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[titleArray count]-1 inSection:0];
                [fxMenuCollectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                
                doneButton.hidden = NO;
                actionsheetButton.hidden = YES;
            }
                break;
            case 1:
            {
                //                CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
                //                [director end];
                
                [self performSegueWithIdentifier:@"addFx" sender:self];
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (buttonIndex) {
            case 0:
            {
                
                //                CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
                //                 NSLog(@"fx menu retain count before= %d",[director.view retainCount]);
                //
                //                //if([director runningScene] != nil)
                //                    [director end];
                //
                //                 NSLog(@"fx menu retain count after= %d",[director.view retainCount]);
                
                [self performSegueWithIdentifier:@"addFx" sender:self];
            }
                break;
            default:
                break;
        }
    }
}

- (IBAction)doneButton:(id)sender
{
    isEdit = NO;
    doneButton.hidden = YES;
    actionsheetButton.hidden = NO;
    
    [fxMenuCollectionView reloadData];
    
    [self updatePageControl];
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)previewButtonClicked
{
    NSLog(@"previewButtonClicked");
    
    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
        return;
    
    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
    
    [service writeEffectCommand:animationParameter silent:0];
//    [service writeEffectCommand:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:0 VIBRATE:isVibrate LOOP:loop];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollViewDidEndDragging = %f",scrollView.contentOffset.x);
    CGFloat width = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x-width)/width)+1;
    pageControl.currentPage = page;
    if (scrollView.contentOffset.x>((([titleArray count]/6)-1) * width)) {
        pageControl.currentPage = page + 1;
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"addFx"])
	{
        
        if(isEdit)
        {
            AddFxMenuViewController *addFxMenuViewController = segue.destinationViewController;
            addFxMenuViewController.styleIndex = styleIndex;
            addFxMenuViewController.delegate = self;
            addFxMenuViewController.fxIndex = selectFxIndex;
            addFxMenuViewController.isEdit = true;
        }
        else
        {
            AddFxMenuViewController *addFxMenuViewController = segue.destinationViewController;
            addFxMenuViewController.styleIndex = styleIndex;
            addFxMenuViewController.delegate = self;
            addFxMenuViewController.fxIndex = selectFxIndex;
            addFxMenuViewController.isEdit = false;
            
        }
	}
    
}

#pragma mark _
#pragma mark collectionviewDelegate
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [titleArray count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    //
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
#pragma mark - kane
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 2.0;
    cell.layer.borderColor = [UIColor colorWithRed:255.0f green:255.0f blue:255.0f alpha:0.2].CGColor;

    
    if (indexPath.row < [titleArray count]) {
        // make the cell's title the actual NSIndexPath value
        cell.label.text = [NSString stringWithFormat:@"%@", [titleArray objectAtIndex:indexPath.row]];
        cell.label.font=[UIFont fontWithName:@"Avenir" size:13];
        // load the image for this cell
        NSString *imageToLoad = [NSString stringWithFormat:@"%@.png", [imageNameArray objectAtIndex:indexPath.row]];
        cell.image.image = [UIImage imageNamed:imageToLoad];
        cell.delButton.tag = indexPath.row;
        [cell.delButton addTarget:self action:@selector(deleteSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        if (isEdit && indexPath.row >= defaultFxNum) {
            cell.delButton.hidden = NO;
        }
        else {
            cell.delButton.hidden = YES;
        }
    }
    
    else {
        cell.label.text = @"";
        cell.label.font=[UIFont fontWithName:@"Avenir" size:13];
        cell.image.image = nil;
        cell.delButton.tag = indexPath.row;
        if (isEdit) {
            cell.delButton.hidden = YES;
        }
        else {
            cell.delButton.hidden = YES;
        }
    }
    
    return cell;
}
- (void)deleteSelectItem:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag inSection:0];
    NSLog(@"index section = %d,%d",indexPath.row,indexPath.section);
    NSArray *selectedItemsIndexPaths = [NSArray arrayWithObject:indexPath];
    [titleArray removeObjectAtIndex:button.tag];
    [imageNameArray removeObjectAtIndex:button.tag];
    [fxMenuCollectionView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
    
    NSMutableArray *indexArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [titleArray count];i ++)
    {
        NSIndexPath *indexPathTemp = [NSIndexPath indexPathForRow:i inSection:0];
        [indexArray addObject:indexPathTemp];
        
    }
    
    [self updatePageControl];
    [fxMenuCollectionView reloadItemsAtIndexPaths:indexArray];
    
    [styleDictionary setObject:titleArray forKey:@"title"];
    [styleDictionary setObject:imageNameArray forKey:@"image"];
    [fxForStyleDic setObject:styleDictionary forKey:[NSString stringWithFormat:@"%d",styleIndex]];
    [fxForStyleDic writeToFile:[FilePath fxForStyleFilePath] atomically:YES];
    
    
    //delete the custom config
    NSMutableDictionary *customFxConfigDic;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath customFxConfigFilePath]])
    {
        customFxConfigDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[FilePath customFxConfigFilePath]];
        
    }
    NSMutableArray *customFxConfigArray;
    customFxConfigArray = [customFxConfigDic objectForKey:[NSString stringWithFormat:@"style%d",styleIndex]];
    [customFxConfigArray removeObjectAtIndex:indexPath.row - defaultFxNum];
    [customFxConfigDic setObject:customFxConfigArray forKey:[NSString stringWithFormat:@"style%d",styleIndex]];
    [customFxConfigDic writeToFile:[FilePath customFxConfigFilePath] atomically:YES];
    
    if(indexPath.row == selectFxIndex)
    {
        [styleDictionary setObject:[NSNumber numberWithInt:0] forKey:[NSString stringWithFormat:@"%d",notificationIndex]];
        [fxForStyleDic setObject:styleDictionary forKey:[NSString stringWithFormat:@"style%d",styleIndex]];
        [fxForStyleDic writeToFile:[FilePath fxForStyleFilePath] atomically:YES];

    }
    //    [fxMenuCollectionView performBatchUpdates:^{
    //        NSArray *selectedItemsIndexPaths = [fxMenuCollectionView indexPathsForSelectedItems];
    //        // Now delete the items from the collection view.
    //        [fxMenuCollectionView deleteItemsAtIndexPaths:selectedItemsIndexPaths];
    //
    //    } completion:^(BOOL finished){
    //        [fxMenuCollectionView reloadData];
    //    }];
    
    //if all is deleted
    if([titleArray count] == defaultFxNum)
    {
        isEdit = NO;
        doneButton.hidden = YES;
        actionsheetButton.hidden = NO;
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (isEdit && indexPath.row<defaultFxNum) {
        return NO;
    }
    else
        return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectFxIndex = indexPath.row;
    NSLog(@"notification:%d +selectFxIndex %d",notificationIndex,selectFxIndex);
    
    if(indexPath.row > [titleArray count]-1)
        return;
    
    if (selectFxIndex < defaultFxNum && isEdit) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectFxIndex inSection:0];
        [fxMenuCollectionView deselectItemAtIndexPath:indexPath animated:YES];
    }
    if (selectFxIndex >= defaultFxNum && isEdit) {
        
        [self performSegueWithIdentifier:@"addFx" sender:self];
        
        return;
    }
    
    [styleDictionary setObject:[NSNumber numberWithInt:selectFxIndex] forKey:[NSString stringWithFormat:@"%d",notificationIndex]];
    [fxForStyleDic setObject:styleDictionary forKey:[NSString stringWithFormat:@"style%d",styleIndex]];
    [fxForStyleDic writeToFile:[FilePath fxForStyleFilePath] atomically:YES];
    
    [NotificationUtility singleNotificationSwitched:styleIndex notificationIndex:notificationIndex mode:0];
    
    /*
    NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[titleArray objectAtIndex:selectFxIndex]];
    
    lFromR = [[lightDataArray objectAtIndex:0] intValue];    //L灯 R  (From)
    lFromG= [[lightDataArray objectAtIndex:1] intValue];    //L灯 G  (From)
    lFromB = [[lightDataArray objectAtIndex:2] intValue];    //L灯 B  (From)
    
    lToR = [[lightDataArray objectAtIndex:3] intValue];    //L灯 R  (To)
    lToG = [[lightDataArray objectAtIndex:4] intValue];    //L灯 G  (To)
    lToB = [[lightDataArray objectAtIndex:5] intValue];    //L灯 B  (To)
    
    
    rFromR= [[lightDataArray objectAtIndex:6] intValue];    //R灯 R  (From)
    rFromG= [[lightDataArray objectAtIndex:7] intValue];    //R灯 G  (From)
    rFromB= [[lightDataArray objectAtIndex:8] intValue];    //R灯 B  (From)
    
    rToR = [[lightDataArray objectAtIndex:9] intValue];    //R灯 R  (To)
    rToG = [[lightDataArray objectAtIndex:10] intValue];    //R灯 G  (To)
    rToB = [[lightDataArray objectAtIndex:11] intValue];    //R灯 B  (To)
    
    durationTime1 = [[lightDataArray objectAtIndex:12] intValue];    //duration
    durationTime2 = [[lightDataArray objectAtIndex:13] intValue];    //duration
    
    isBlackout = [[lightDataArray objectAtIndex:14] intValue];
    isRandom = [[lightDataArray objectAtIndex:15] intValue];
    hold = [[lightDataArray objectAtIndex:16] intValue];
    pause = [[lightDataArray objectAtIndex:17] intValue];
    isVibrate = [[lightDataArray objectAtIndex:18] intValue];
    loop = [[lightDataArray objectAtIndex:19] intValue];
    
//    [EmbLayer SelectEffect:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause];
     */
    
    NSString* file = [FilePath fxMenuLightDataFilePath];
    NSString* title = [titleArray objectAtIndex:selectFxIndex];
    
    animationParameter = [AnimationParameter createFromFile:file title:title];
//    [EmbLayer SelectEffect:animationParameter];
    emulator.animationParameter = animationParameter;
    
//
//    
//    if([[[LeDiscovery sharedInstance] connectedServices] count] == 0)
//        return;
//    
//    //set update configuration
//    LeEmbraceService *service = [[[LeDiscovery sharedInstance] connectedServices] objectAtIndex:0];
//    
//    int appId = 0;
//    
//    if(notificationIndex <100)
//    {
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"CALL"].length!=0)
//        {
//            appId = 0x1;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"TEXT"].length!=0)
//        {
//            appId = 0x2;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Email"].length!=0)
//        {
//            appId = 0x3;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"CALENDAR"].length!=0)
//        {
//            appId = 0x4;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Facebook"].length!=0)
//        {
//            appId = 0x5;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Twitter"].length!=0)
//        {
//            appId = 0x6;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Tumblr"].length!=0)
//        {
//            appId = 0x7;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Skype"].length!=0)
//        {
//            appId = 0x8;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Instagram"].length!=0)
//        {
//            appId = 0x9;
//        }
//        
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"LinkedIn"].length!=0)
//        {
//            appId = 10;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"WhatsApp"].length!=0)
//        {
//            appId = 11;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"FaceTime"].length!=0)
//        {
//            appId = 12;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Viber"].length!=0)
//        {
//            appId = 13;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Pinterest"].length!=0)
//        {
//            appId = 14;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"FourSquare"].length!=0)
//        {
//            appId = 15;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"CandyCrush"].length!=0)
//        {
//            appId = 16;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Phone out of Range"].length!=0)
//        {
//            appId = 17;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Low Battery Embrace"].length!=0)
//        {
//            appId = 18;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"BATTERY"].length!=0)
//        {
//            appId = 19;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Scrabble"].length!=0)
//        {
//            appId = 21;
//        }
//        
//        if([notificationTitles[notificationIndex] rangeOfString:@"Scrabble free"].length!=0)
//        {
//            appId = 22;
//        }
//        
//    }
//    else
//    {
//        NSLog(@"calls title = %@",notificationTitles[notificationIndex-100]);
//        if([notificationTitles[notificationIndex-100] rangeOfString:@"Unknown Caller"].length!=0)
//        {
//            appId = 20;
//        }
//        if([notificationTitles[notificationIndex-100] rangeOfString:@"Incoming Caller"].length!=0)
//        {
//            appId = 1;
//        }
//    }
//    
//    NSLog(@"appid = %d",appId);
//    
//    
//    int silent;
//    if(notificationIndex<100)
//    {
//        silent = [notificationIsSilent[notificationIndex] intValue];
//    }
//    else
//    {
//        if([notificationIsSilent[0] intValue] == 1)
//        {
//            silent = 1;
//        }
//        else
//        {
//            silent = [callsNotificationIsSilent[notificationIndex-100] intValue];
//        }
//    }
//    
//    NSLog(@"appid !!!!!!!!!!!!!= %d, silent = %d",appId,silent);
//    [service writeUpdateCofig:appId lFromR:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate];
    
}

- (void)backNotificationViewController:(AddFxMenuViewController *)controller iconImageName:(NSString *)imageName fxTitle:(NSString *)fxTitle lFromR:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause VIBRATE:(int)vibrate LOOP:(int)loop;

{
    
    if (!isEdit) {
        [titleArray addObject:[NSString stringWithFormat:@"%@",fxTitle]];
        [imageNameArray addObject:[NSString stringWithFormat:@"%@",imageName]];
    }
    else {
        [titleArray replaceObjectAtIndex:selectFxIndex withObject:[NSString stringWithFormat:@"%@",fxTitle]];
        [imageNameArray replaceObjectAtIndex:selectFxIndex withObject:[NSString stringWithFormat:@"%@",imageName]];
    }
    
    
    [styleDictionary setObject:titleArray forKey:@"title"];
    [styleDictionary setObject:imageNameArray forKey:@"image"];
    [fxForStyleDic setObject:styleDictionary forKey:[NSString stringWithFormat:@"%d",styleIndex]];
    [fxForStyleDic writeToFile:[FilePath fxForStyleFilePath] atomically:YES];
    
    
    NSString *LFromR = [NSString stringWithFormat:@"%d",lFromR];
    NSString *LFromG = [NSString stringWithFormat:@"%d",lFromG];
    NSString *LFromB = [NSString stringWithFormat:@"%d",lFromB];
    
    NSString *LToR = [NSString stringWithFormat:@"%d",lToR];
    NSString *LToG = [NSString stringWithFormat:@"%d",lToG];
    NSString *LToB = [NSString stringWithFormat:@"%d",lToB];
    
    NSString *RFromR = [NSString stringWithFormat:@"%d",rFromR];
    NSString *RFromG = [NSString stringWithFormat:@"%d",rFromG];
    NSString *RFromB = [NSString stringWithFormat:@"%d",rFromB];
    
    NSString *RToR = [NSString stringWithFormat:@"%d",rToR];
    NSString *RToG = [NSString stringWithFormat:@"%d",rToG];
    NSString *RToB = [NSString stringWithFormat:@"%d",rToB];
    
    NSString *durationStr1 = [NSString stringWithFormat:@"%d",durationMil1];
    NSString *durationStr2 = [NSString stringWithFormat:@"%d",durationMil2];
    
    NSString *blackoutStr = [NSString stringWithFormat:@"%d",blackout];
    NSString *holdStr = [NSString stringWithFormat:@"%d",hold];
    NSString *randomStr = [NSString stringWithFormat:@"%d",random];
    NSString *pauseStr = [NSString stringWithFormat:@"%d",pause];
    NSString *vibrateStr = [NSString stringWithFormat:@"%d",vibrate];
    NSString *loopStr = [NSString stringWithFormat:@"%d",loop];
    //NSLog(@"%@,%@",LFromR,LToG);
    //r =256 stands for transparent
    //frome/to L: R,G,B,    frome/to R: R,G,B  duration1 dutation2  blackout random hold pause
    
    NSArray *lightDataArray = [NSArray arrayWithObjects:LFromR,LFromG,LFromB,LToR,LToG,LToB,RFromR,RFromG,RFromB,RToR,RToG,RToB,durationStr1,durationStr2,blackoutStr,randomStr,holdStr,pauseStr,vibrateStr,loopStr,nil];
    
    [fxMenuLightDataDic setObject:lightDataArray forKey:fxTitle];
    [fxMenuLightDataDic writeToFile:[FilePath fxMenuLightDataFilePath] atomically:YES];
    
    isEdit = NO;
    doneButton.hidden = YES;
    actionsheetButton.hidden = NO;
    [fxMenuCollectionView reloadData];
    
  
    
    [self updatePageControl];
	[self.navigationController popViewControllerAnimated:YES];
    
}

- (void)updatePageControl
{
    float page = [titleArray count]/(float)cellNumPerPage;
    pageControl.numberOfPages = (int)(ceilf(page));
    
    if(pageControl.numberOfPages == 1)
    {
        [pageControl setHidden:YES];
    }
    else
    {
        [pageControl setHidden:NO];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated;  // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
{
    CCDirectorIOS* director = (CCDirectorIOS*)[CCDirector sharedDirector];
    if([director runningScene] != nil)
    {
        //[director stopAnimation];
    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
    
    [fxForStyleDic release];
    [fxMenuLightDataDic release];
    [notificationTitles release];
    [notificationIsSilent release];
    [callsNotificationIsSilent release];
    
    
    [actionsheetButton release];
    [doneButton release];
    [fxMenuCollectionView release];
    [backButton release];
    [backgroundImageView release];
    [previewButton release];
    [line1 release];
    [fxLabel release];
    [pageControl release];

}
@end
