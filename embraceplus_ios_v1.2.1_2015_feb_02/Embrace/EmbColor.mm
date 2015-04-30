//
//  HelloWorldLayer.m
//  Embrace+
//
//  Created by hum on 9/7/13.
//  Copyright hum 2013. All rights reserved.
//

#import "EmbColor.h"

@implementation EmbColor

+(NSString *)getColor:(int) color
{
    NSString *colorString;
    colorString = [NSString stringWithFormat:@"%d",color];
    
    //NSLog(@"color = %@",colorString);
    return colorString;
}

+(int) getColorIndex:(int) r g:(int)g b:(int) b
{
    if(r == 256 && g == 0 && b == 0)
    {
        return 0;
    }
    
    if(r == emWHITE.r && g == emWHITE.g && b == emWHITE.b)
    {
        return 1;
    }
    
    if(r == emSilver.r && g == emSilver.g && b == emSilver.b)
    {
        return 2;
    }
    
    if(r == emPink_light.r && g == emPink_light.g && b == emPink_light.b)
    {
        return 3;
    }
    
    if(r == emPink.r && g == emPink.g && b == emPink.b)
    {
        return 4;
    }
    
    if(r == emPurple.r && g == emPurple.g && b == emPurple.b)
    {
        return 5;
    }
    
    if(r == emPink_red.r && g == emPink_red.g && b == emPink_red.b)
    {
        return 6;
    }
    
    if(r == emRed.r && g == emRed.g && b == emRed.b)
    {
        return 7;
    }
    
    if(r == emRed_Blood.r && g == emRed_Blood.g && b == emRed_Blood.b)
    {
        return 8;
    }
    
    if(r == emYellow.r && g == emYellow.g && b == emYellow.b)
    {
        return 9;
    }
    
    if(r == emGreen_Acid.r && g == emGreen_Acid.g && b == emGreen_Acid.b)
    {
        return 10;
    }
    
    if(r == emGreen.r && g == emGreen.g && b == emGreen.b)
    {
        return 11;
    }
    
    if(r == emOrange.r && g == emOrange.g && b == emOrange.b)
    {
        return 12;
    }
    
    if(r == emGold.r && g == emGold.g && b == emGold.b)
    {
        return 13;
    }
    
    if(r == emBlue_Sky.r && g == emBlue_Sky.g && b == emBlue_Sky.b)
    {
        return 14;
    }
    
    if(r == emBlue_Light.r && g == emBlue_Light.g && b == emBlue_Light.b)
    {
        return 15;
    }
    
    if(r == emBlue.r && g == emBlue.g && b == emBlue.b)
    {
        return 16;
    }
    
    return 0;
}
@end
