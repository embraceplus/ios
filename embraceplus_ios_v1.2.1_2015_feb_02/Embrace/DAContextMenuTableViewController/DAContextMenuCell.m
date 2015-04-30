//
//  DAСontextMenuCell.m
//  DAContextMenuTableViewControllerDemo
//
//  Created by Daria Kopaliani on 7/24/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAContextMenuCell.h"

@interface DAContextMenuCell () <UIGestureRecognizerDelegate>

@property (assign, nonatomic, getter = isContextMenuHidden) BOOL contextMenuHidden;
@property (assign, nonatomic) BOOL shouldDisplayContextMenuView;
@property (assign, nonatomic) CGFloat initialTouchPositionX;

@end


@implementation DAContextMenuCell

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    //NSLog(@"setUp!!!!!!!");
    self.contextMenuView = [[UIView alloc] initWithFrame:self.actualContentView.bounds];
    self.contextMenuView.backgroundColor = self.contentView.backgroundColor;
    [self.contentView insertSubview:self.contextMenuView aboveSubview:self.actualContentView];
    self.contextMenuHidden = self.contextMenuView.hidden = YES;
    self.shouldDisplayContextMenuView = NO;
    self.editable = YES;
    
//    if(_isSilent)
//    {
//        self.moreOptionsButtonTitle = @"On";
//        self.moreOptionsButtonTitle1 = @"On";
//    }
//    else
//    {
//        self.moreOptionsButtonTitle = @"Silent";
//        self.moreOptionsButtonTitle1 = @"Silent";
//    }
//    
//    if(_isAllowDelete)
//    {
//        
//        self.deleteButtonTitle = @"Delete";
//        self.deleteButtonTitle1 = @"Delete";
//    }
    
    self.menuOptionButtonTitlePadding = 25.;
    self.menuOptionsAnimationDuration = 0.3;
    self.bounceValue = 30.;
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [self addGestureRecognizer:panRecognizer];
    [self setNeedsLayout];
}

#pragma mark - Public

- (CGFloat)contextMenuWidth
{
//    return CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.moreOptionsButton.frame);
    
    if(_isAllowDelete)
        return CGRectGetWidth(self.deleteButton.frame) + CGRectGetWidth(self.moreOptionsButton.frame);
    else
        return CGRectGetWidth(self.moreOptionsButton.frame);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contextMenuView.frame = self.actualContentView.bounds;
//    [self.contentView sendSubviewToBack:self.contextMenuView];
//    [self.contentView bringSubviewToFront:self.actualContentView];
    
    
    [self.contentView sendSubviewToBack:self.actualContentView];
    [self.contentView bringSubviewToFront:self.contextMenuView];
    
    CGFloat height = 57.;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat menuOptionButtonWidth = [self menuOptionButtonWidth];
    

    if(_isAllowDelete)
    {
        self.moreOptionsButton1.frame = CGRectMake(width - menuOptionButtonWidth - menuOptionButtonWidth, 0.-1, menuOptionButtonWidth, height);
        self.deleteButton1.frame = CGRectMake(width - menuOptionButtonWidth, 0.-1, menuOptionButtonWidth, height);
        
        self.moreOptionsButton.frame = CGRectMake(width, 0.-1, menuOptionButtonWidth, height);
        
        self.deleteButton.frame = CGRectMake(width + menuOptionButtonWidth, 0.-1, menuOptionButtonWidth, height);
        
        self.moreOptionsButton1.hidden = YES;
        self.deleteButton1.hidden = YES;
    }
    else
    {
        self.moreOptionsButton1.frame = CGRectMake(width - menuOptionButtonWidth, 0.-1, menuOptionButtonWidth, height);
        self.moreOptionsButton.frame = CGRectMake(width, 0.-1, menuOptionButtonWidth, height);
        
        self.moreOptionsButton1.hidden = YES;

    }
    

}

- (CGFloat)menuOptionButtonWidth
{
    NSString *string = ([self.deleteButtonTitle length] > [self.moreOptionsButtonTitle length]) ? self.deleteButtonTitle : self.moreOptionsButtonTitle;
    CGFloat width = roundf([string sizeWithFont:self.moreOptionsButton.titleLabel.font].width + 2. * self.menuOptionButtonTitlePadding);
    width = MIN(width, CGRectGetWidth(self.bounds) / 2. - 10.);
    if ((NSInteger)width % 2) {
        width += 1.;
    }
    return width;
}

- (void)setDeleteButtonTitle:(NSString *)deleteButtonTitle
{
    _deleteButtonTitle = deleteButtonTitle;
    [self.deleteButton setTitle:deleteButtonTitle forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setDeleteButtonTitle1:(NSString *)deleteButtonTitle1
{
    _deleteButtonTitle1 = deleteButtonTitle1;
    [self.deleteButton1 setTitle:deleteButtonTitle1 forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setEditable:(BOOL)editable
{
    if (_editable != editable) {
        _editable = editable;
        [self setNeedsLayout];
    }
}

- (void)setIsAllowDelete:(BOOL)isAllowDelete
{
    if (_isAllowDelete != isAllowDelete) {
        _isAllowDelete = isAllowDelete;
        
    }
}

- (void)setIsSwipeOn:(BOOL)isSwipeOn
{
    if (_isSwipeOn != isSwipeOn) {
        _isSwipeOn = isSwipeOn;
        
    }
}


- (void)setIsSilent:(BOOL)isSilent
{
    if (_isSilent != isSilent) {
        _isSilent = isSilent;
        
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (self.contextMenuHidden) {
        self.contextMenuView.hidden = YES;
        [super setHighlighted:highlighted animated:animated];
    }
}

- (void)setMenuOptionButtonTitlePadding:(CGFloat)menuOptionButtonTitlePadding
{
    if (_menuOptionButtonTitlePadding != menuOptionButtonTitlePadding) {
        _menuOptionButtonTitlePadding = menuOptionButtonTitlePadding;
        [self setNeedsLayout];
    }
}

- (void)setMenuOptionsViewHidden:(BOOL)hidden animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler
{

    if (self.selected) {
        [self setSelected:NO animated:NO];
    }
    
    //////////
    self.moreOptionsButton1.hidden = YES;
    self.deleteButton1.hidden = YES;
    
    CGRect frame = CGRectMake((hidden) ? 0 : -[self contextMenuWidth], 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [UIView animateWithDuration:(animated) ? self.menuOptionsAnimationDuration : 0.
                          delay:0.
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         self.actualContentView.frame = frame;
     } completion:^(BOOL finished) {
         self.contextMenuHidden = hidden;
         self.shouldDisplayContextMenuView = !hidden;
         if (!hidden) {
             [self.delegate contextMenuDidShowInCell:self];
             
             self.moreOptionsButton1.hidden = NO;
             
             if(self.isAllowDelete)
             {
                 self.deleteButton1.hidden = NO;
             }
             
             
         } else {
             [self.delegate contextMenuDidHideInCell:self];
             
             self.moreOptionsButton1.hidden = YES;
             
             if(self.isAllowDelete)
             {
                 self.deleteButton1.hidden = YES;
             }
             

         }
         if (completionHandler) {
             completionHandler();
         }
     }];
}

- (void)setMoreOptionsButtonTitle:(NSString *)moreOptionsButtonTitle
{
    _moreOptionsButtonTitle = moreOptionsButtonTitle;
    [self.moreOptionsButton setTitle:self.moreOptionsButtonTitle forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setMoreOptionsButtonTitle1:(NSString *)moreOptionsButtonTitle1
{
    _moreOptionsButtonTitle1 = moreOptionsButtonTitle1;
    [self.moreOptionsButton1 setTitle:self.moreOptionsButtonTitle1 forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.contextMenuHidden) {
        self.contextMenuView.hidden = YES;
        [super setSelected:selected animated:animated];
    }
}

#pragma mark - Private

- (void)handlePan:(UIPanGestureRecognizer *)recognizer;
{
    if(!_isSwipeOn)
        return;
    
    if(_isSilent)
    {
        self.moreOptionsButtonTitle = @"On";
        self.moreOptionsButtonTitle1 = @"On";
    }
    else
    {
        self.moreOptionsButtonTitle = @"Silent";
        self.moreOptionsButtonTitle1 = @"Silent";
    }
    
    if(_isAllowDelete)
    {
        
        self.deleteButtonTitle = @"Delete";
        self.deleteButtonTitle1 = @"Delete";
    }

    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        
        //NSLog(@"recognizer.state %d",recognizer.state);
        CGPoint currentTouchPoint = [panRecognizer locationInView:self.contentView];
        CGFloat currentTouchPositionX = currentTouchPoint.x;
        CGPoint velocity = [recognizer velocityInView:self.contentView];
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            self.initialTouchPositionX = currentTouchPositionX;
            if (velocity.x > 0) {
                [self.delegate contextMenuWillHideInCell:self];
            } else {
                [self.delegate contextMenuDidShowInCell:self];
            }
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint velocity = [recognizer velocityInView:self.contentView];
            if (!self.contextMenuHidden || (velocity.x > 0. || [self.delegate shouldShowMenuOptionsViewInCell:self])) {
                if (self.selected) {
                    [self setSelected:NO animated:NO];
                }
                self.contextMenuView.hidden = NO;
                CGFloat panAmount = currentTouchPositionX - self.initialTouchPositionX;
                self.initialTouchPositionX = currentTouchPositionX;
                CGFloat minOriginX = -[self contextMenuWidth] - self.bounceValue;
                CGFloat maxOriginX = 0.;
                CGFloat originX = CGRectGetMinX(self.actualContentView.frame) + panAmount;
                originX = MIN(maxOriginX, originX);
                originX = MAX(minOriginX, originX);
                
                
                if ((originX < -0.5 * [self contextMenuWidth] && velocity.x < 0.) || velocity.x < -100) {
                    self.shouldDisplayContextMenuView = YES;
                } else if ((originX > -0.3 * [self contextMenuWidth] && velocity.x > 0.) || velocity.x > 100) {
                    self.shouldDisplayContextMenuView = NO;
                }
                self.actualContentView.frame = CGRectMake(originX, 0., CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
                //NSLog(@"origin = %f",originX);
                
                self.moreOptionsButton1.hidden = YES;
                
                if(!self.isAllowDelete)
                {
                    self.deleteButton1.hidden = YES;
                    self.deleteButton.hidden = YES;
                }
                
                if(_isSilent)
                {
                    self.moreOptionsButtonTitle = @"On";
                    self.moreOptionsButtonTitle1 = @"On";
                }
                else
                {
                    self.moreOptionsButtonTitle = @"Silent";
                    self.moreOptionsButtonTitle1 = @"Silent";
                }


            }
        } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
            [self setMenuOptionsViewHidden:!self.shouldDisplayContextMenuView animated:YES completionHandler:nil];
        }
    }
}

- (void)deleteButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(contextMenuCellDidSelectDeleteOption:)]) {
        [self.delegate contextMenuCellDidSelectDeleteOption:self];
    }
}

- (void)moreButtonTapped
{
    NSLog(@"moreButtonTapped is tapped");
    
    if(_isSilent)
    {
        [_moreOptionsButton setTitle:@"Silent" forState:UIControlStateNormal];
        [_moreOptionsButton1 setTitle:@"Silent" forState:UIControlStateNormal];
    }
    else
    {
        [_moreOptionsButton setTitle:@"On" forState:UIControlStateNormal];
        [_moreOptionsButton1 setTitle:@"On" forState:UIControlStateNormal];
    }
    
    _isSilent = !_isSilent;
    
    [self.delegate updateSilentStatus:self];
    [self.delegate contextMenuCellDidSelectMoreOption:self];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setMenuOptionsViewHidden:YES animated:NO completionHandler:nil];
}

#pragma mark * Lazy getters
- (UIButton *)moreOptionsButton1
{
    if (!_moreOptionsButton1) {
        CGRect frame = CGRectMake(0., 0., 100., 57.);
        _moreOptionsButton1 = [[UIButton alloc] initWithFrame:frame];
        _moreOptionsButton1.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
               [self.contextMenuView addSubview:_moreOptionsButton1];
        [_moreOptionsButton1 addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //NSLog(@"isAllowDelete= %d",self.isAllowDelete);
    return _moreOptionsButton1;
}

- (UIButton *)moreOptionsButton
{
    //NSLog(@"actualContentView = %f",CGRectGetHeight(self.actualContentView.frame));
    if (!_moreOptionsButton) {
        CGRect frame = CGRectMake(0., 0., 100., 57.);
        _moreOptionsButton = [[UIButton alloc] initWithFrame:frame];
        _moreOptionsButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
        //[self.contextMenuView addSubview:_moreOptionsButton];
        
        [self.actualContentView addSubview:_moreOptionsButton];

//        [_moreOptionsButton addTarget:self action:@selector(moreButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //NSLog(@"moreOptionsButton= %@",_moreOptionsButton);
    return _moreOptionsButton;
}

- (UIButton *)deleteButton1
{
    if (self.editable) {
        if (!_deleteButton1) {
            CGRect frame = CGRectMake(0., 0., 100., 57.);
            _deleteButton1 = [[UIButton alloc] initWithFrame:frame];
            _deleteButton1.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.4];
            
            //if(self.isAllowDelete)
                [self.contextMenuView addSubview:_deleteButton1];
            [_deleteButton1 addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        return _deleteButton1;
    }
    return nil;
}


- (UIButton *)deleteButton
{
    if (self.editable) {
        if (!_deleteButton) {
            CGRect frame = CGRectMake(0., 0., 100., 57.);
            _deleteButton = [[UIButton alloc] initWithFrame:frame];
            _deleteButton.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:0.4];
            //[self.contextMenuView addSubview:_deleteButton];
            
            //if(self.isAllowDelete)
                [self.actualContentView addSubview:_deleteButton];
            
//            [_deleteButton addTarget:self action:@selector(deleteButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        }
        return _deleteButton;
    }
    return nil;
}

#pragma mark * UIPanGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}

@end