//
//  Image.h
//  EmbracePlus ios7
//
//  Created by 赵雅琦 on 14-12-3.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage(EmbracePlus)

+ (UIImage *) imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *) transform;
- (UIImage *) tintWithColor:(UIColor*)color;
- (UIImage *) toJPEG;
//    UIImage *inputImage = [UIImage imageWithData:UIImageJPEGRepresentation(self, 1.0)]; //to be optimized


@end
