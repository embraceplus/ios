//
//  DAСontextMenuCell.h
//  DAContextMenuTableViewControllerDemo
//
//  Created by Daria Kopaliani on 7/24/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DAContextMenuCell;

@protocol DAContextMenuCellDelegate <NSObject>

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell;
- (void)contextMenuDidHideInCell:(DAContextMenuCell *)cell;
- (void)contextMenuDidShowInCell:(DAContextMenuCell *)cell;
- (void)contextMenuWillHideInCell:(DAContextMenuCell *)cell;
- (void)contextMenuWillShowInCell:(DAContextMenuCell *)cell;
- (BOOL)shouldShowMenuOptionsViewInCell:(DAContextMenuCell *)cell;
- (void)updateSilentStatus:(DAContextMenuCell *)cell;
@optional
- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell;

@end


@interface DAContextMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *actualContentView;
@property (strong, nonatomic) UIView *contextMenuView;
@property (strong, nonatomic) UIButton *moreOptionsButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *moreOptionsButton1;
@property (strong, nonatomic) UIButton *deleteButton1;


@property (readonly, assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (strong, nonatomic) NSString *deleteButtonTitle;
@property (strong, nonatomic) NSString *deleteButtonTitle1;
@property (assign, nonatomic) BOOL editable;

@property (assign, nonatomic) BOOL isAllowDelete;
@property (assign, nonatomic) BOOL isSilent;
@property (assign, nonatomic) BOOL isSwipeOn;

@property (assign, nonatomic) CGFloat menuOptionButtonTitlePadding;
@property (assign, nonatomic) CGFloat menuOptionsAnimationDuration;
@property (assign, nonatomic) CGFloat bounceValue;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle;
@property (strong, nonatomic) NSString *moreOptionsButtonTitle1;

@property (weak, nonatomic) id<DAContextMenuCellDelegate> delegate;

- (CGFloat)contextMenuWidth;
- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;

@end
