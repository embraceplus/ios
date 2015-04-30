//
//  Image.m
//  EmbracePlus ios7
//
//  Created by 赵雅琦 on 14-12-3.
//  Copyright (c) 2014年 RKB Global. All rights reserved.
//

#import "Image.h"

#define SAFECOLOR(color) MIN(255,MAX(0,color))

@implementation UIImage(EmbracePlus)

typedef struct _singleRGBA
{
    unsigned char red;
    unsigned char green;
    unsigned char blue;
    unsigned char alpha;
} RGBA;

typedef void (*FilterFunction)(UInt8 *pixelBuf, UInt32 offset, void *context);

void filterTint(UInt8 *pixelBuf, UInt32 offset, void *context)
{
    //    RGBA *rgbaArray = (RGBA*)context;
    //    RGBA maxRGBA = rgbaArray[0];
    //    RGBA minRGBA = rgbaArray[1];
    
    int r = offset;
    int g = offset+1;
    int b = offset+2;
    //    int a = offset+3;
    
    int red = pixelBuf[r];
    int green = pixelBuf[g];
    int blue = pixelBuf[b];
    //    int alpha = pixelBuf[a];
    
    //    pixelBuf[r] = SAFECOLOR((red - minRGBA.red) * (255.0 / (maxRGBA.red - minRGBA.red)));
    //    pixelBuf[g] = SAFECOLOR((green - minRGBA.green) * (255.0 / (maxRGBA.green - minRGBA.green)));
    //    pixelBuf[b] = SAFECOLOR((blue - minRGBA.blue) * (255.0 / (maxRGBA.blue - minRGBA.blue)));
    pixelBuf[r] = red/2;
    pixelBuf[g] = green/2;
    pixelBuf[b] = blue/2;
    //    pixelBuf[a] = al
}

void filterBlendWithColor(UInt8 *pixelBuf, UInt32 offset, void *context)
{
    UIColor* color = (__bridge UIColor*)context;
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    int r = offset;
    int g = offset+1;
    int b = offset+2;
    
    int red = pixelBuf[r] * components[0];
    int green = pixelBuf[g] * components[1];
    int blue = pixelBuf[b] * components[2];
    
    pixelBuf[r] = red;
    pixelBuf[g] = green;
    pixelBuf[b] = blue;
    
//#if TARGET_IPHONE_SIMULATOR
//    pixelBuf[r] = blue;
//    pixelBuf[g] = green;
//    pixelBuf[b] = red;
//#else
//    pixelBuf[r] = red;
//    pixelBuf[g] = green;
//    pixelBuf[b] = blue;
//#endif

}

- (UIImage *)transform{
    return [self applyFilter:filterTint context:nil];
}

- (UIImage *)tintWithColor:(UIColor *)color{
//    const CGFloat *components = CGColorGetComponents(color.CGColor);
////    self.CGImage
//    CGImageRef imageRef = CGImageCreateWithMaskingColors(self.CGImage, components);
//    return [UIImage imageWithCGImage:imageRef];
    
    
//    return [self applyFilter:filterBlendWithColor context:(__bridge void *)(color)];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [color setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0];
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
    
//    UIImage *inputImage = [UIImage imageWithData:UIImageJPEGRepresentation(self, 1.0)]; //to be optimized
//
//    const float colorMasking[6]={100.0, 255.0, 0.0, 100.0, 100.0, 255.0};
//    CGImageRef imageRef = CGImageCreateWithMaskingColors(inputImage.CGImage, colorMasking);
//    UIImage* finalImage = [UIImage imageWithCGImage:imageRef];
//    CGImageRelease(imageRef);
//    return finalImage;
}

- (UIImage *)toJPEG{
    return [UIImage imageWithData:UIImageJPEGRepresentation(self, 1.0)]; //to be optimized
}
//- (UIImage*)applyFilter:(FilterFunction)filter context:(void*)context

- (UIImage*)applyFilter:(FilterFunction)filter context:(void*)context
{
    CGImageRef inImage = self.CGImage;
    CGDataProviderRef providerRef = CGImageGetDataProvider(inImage);
    CFDataRef m_DataRef = CGDataProviderCopyData(providerRef);
    UInt8 *m_PixelBuf = (UInt8 *)CFDataGetBytePtr(m_DataRef);
    
    int length = CFDataGetLength(m_DataRef);
    
    for (int i=0; i<length; i+=4) {
        filter(m_PixelBuf, i, context);
    }
    
    CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                             CGImageGetWidth(inImage),
                                             CGImageGetHeight(inImage),
                                             CGImageGetBitsPerComponent(inImage),
                                             CGImageGetBytesPerRow(inImage),
                                             CGImageGetColorSpace(inImage),
                                             CGImageGetBitmapInfo(inImage)
                                             );
    
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CFRelease(m_DataRef);
    
    return finalImage;
}


+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    // http://stackoverflow.com/questions/1213790/how-to-get-a-color-image-in-iphone-sdk
    
    //Create a context of the appropriate size
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    //Build a rect of appropriate size at origin 0,0
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    //Set the fill color
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    //Fill the color
    CGContextFillRect(currentContext, fillRect);
    
    //Snap the picture and close the context
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

@end
