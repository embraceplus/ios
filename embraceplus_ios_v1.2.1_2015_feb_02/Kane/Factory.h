//
//  Factory.h
//  Ucard
//
//  Created by Ucard on 14-2-27.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Factory : NSObject

+ (UILabel *)createLabelWithFrame:(CGRect)rect Text:(NSString *)text FontSize:(NSInteger)size;

+ (UIButton *)createButtonWithFrame:(CGRect)rect IsCustom:(BOOL)style Title:(NSString *)title;

+ (UIButton *)createButtonWithImage:(UIImage *)image Frame:(CGRect)rect;

+ (UITextField *)createTextFieldWithFrame:(CGRect)rect PlaceHolder:(NSString *)s;

+ (NSMutableArray *)createNavigationToolWithImage:(NSArray *)imageArr;

+ (UISwitch *)createSwitchWithFrame:(CGRect)rect
                               isOn:(BOOL)on
                        onTintColor:(UIColor *)c1
                          tintColor:(UIColor *)c2
                     thumbTintColor:(UIColor *)c3;

+ (UIActivityIndicatorView *)createActivityIndicatorViewWithCenter:(UIView *)v;

//延迟GCD
+ (void)dispanchTimerWithTime:(int)time Block:(void(^)(void))block;

@end
