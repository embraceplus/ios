//
//  Factory.m
//  Ucard
//
//  Created by Ucard on 14-2-27.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "Factory.h"

@implementation Factory

//文本
+(UILabel *)createLabelWithFrame:(CGRect)rect Text:(NSString *)text FontSize:(NSInteger)size
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Arial" size:size];
    return label;
}

//按钮
+(UIButton *)createButtonWithFrame:(CGRect)rect IsCustom:(BOOL)style Title:(NSString *)title
{
    if(style)
    {
        UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
        bu.frame = rect;
        [bu setTitle:title forState:UIControlStateNormal];
        [bu setTitleColor:[UIColor magentaColor] forState:UIControlStateHighlighted];
        return bu;
    }
    else
    {
        UIButton *bu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bu.frame = rect;
        [bu setTitle:title forState:UIControlStateNormal];
        return bu;
    }
    
}

+ (UIButton *)createButtonWithImage:(UIImage *)image Frame:(CGRect)rect;
{
    UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
    [bu setImage:image forState:UIControlStateNormal];
    bu.frame = rect;
    return bu;
}


//输入框
+(UITextField *)createTextFieldWithFrame:(CGRect)rect PlaceHolder:(NSString *)s
{
    UITextField *text = [[UITextField alloc] initWithFrame:rect];
    text.placeholder = s;
    text.borderStyle = UITextBorderStyleRoundedRect;
    return text;
}

//导航栏
+ (NSMutableArray *)createNavigationToolWithImage:(NSArray *)imageArr
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    for(int i = 0;i < [imageArr count];i++)  {
        UIButton *bu = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *im = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        [bu setImage:im forState:UIControlStateNormal];
        [arr addObject:bu];
    }
    return arr;
}

//switch开关

+ (UISwitch *)createSwitchWithFrame:(CGRect)rect
                         isOn:(BOOL)on
                  onTintColor:(UIColor *)c1
                    tintColor:(UIColor *)c2
               thumbTintColor:(UIColor *)c3
{
    UISwitch *s = [[UISwitch alloc] initWithFrame:rect];
    if(c1)
    {
        s.onTintColor = c1;
    }
    if(c2)
    {
        s.tintColor = c2;
    }
    if(c3)
    {
        s.thumbTintColor = c3;
    }
    return s;
}

//加载菊花
+ (UIActivityIndicatorView *)createActivityIndicatorViewWithCenter:(UIView *)v
{
    //初始化菊花控件
    UIActivityIndicatorView *uiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //设置位置
    [v addSubview:uiv];
    uiv.center = v.center;
    //停止转动时消失
    uiv.hidesWhenStopped = YES;
    uiv.tag = 2;
    //设置背景颜色
    uiv.backgroundColor = [UIColor clearColor];
    //设置背景透明
    uiv.alpha = 0.5;
    //设置背景为圆角矩形
    uiv.layer.cornerRadius = 6;
    uiv.layer.masksToBounds = YES;
    return uiv;
}

//延迟GCD
+ (void)dispanchTimerWithTime:(int)time Block:(void(^)(void))block
{
    dispatch_time_t tim = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(time*NSEC_PER_SEC));
    dispatch_after(tim,dispatch_get_main_queue(), ^
                   {
                       block();
                   });
}


@end
