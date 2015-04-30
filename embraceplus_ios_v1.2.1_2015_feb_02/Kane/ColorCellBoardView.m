//
//  ColorCellBoardView.m
//  EmbracePlus ios7
//
//  Created by 晓坤张 on 14-9-6.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import "ColorCellBoardView.h"

@implementation ColorCellBoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //首先通过地方获取上下文(路径)
    CGContextRef context = UIGraphicsGetCurrentContext();
    //线条开始样式 设置为平滑
    CGContextSetLineCap(context, kCGLineCapSquare);
    //线条拐角样式 设置为平滑
    CGContextSetLineJoin(context,kCGLineJoinRound);
    //设置线条颜色
    CGContextSetRGBStrokeColor(context, 255,255,255 , 1);
    //画方形
    CGContextSetLineWidth(context, 5);
    CGContextSetRGBStrokeColor(context, 255, 255, 255, 1);
    CGContextAddRect(context, CGRectMake(0,0, 63, 39));
    CGContextStrokePath(context);
}


@end
