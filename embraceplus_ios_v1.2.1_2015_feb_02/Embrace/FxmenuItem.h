//
//  FxmenuItem.h
//  Embrace
//
//  Created by s1 dred on 13-8-14.
//  Copyright (c) 2013年 d-red puma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ItemViewDelegate <NSObject>

-(void)itemDidDelectedWithTag:(NSInteger)tag;

@end
@interface FxmenuItem : UIImageView
{
    UIButton *delButton;
    BOOL isEditable;
    UIImageView *selectImageView;
}
@property(nonatomic,assign)id<ItemViewDelegate> delegate;
@property(nonatomic,retain)UIButton *delButton;
@property(nonatomic,retain)UIImageView *selectImageView;
@property BOOL isEditable;

-(void)showDeleteIcon;
@end
