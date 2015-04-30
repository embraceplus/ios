//
//  EmbColor.h
//  Embrace ios7
//

//

//#ifndef Embrace_ios7_EmbColor_h
//#define Embrace_ios7_EmbColor_h

static const ccColor3B emWHITE = {0xff,0xff,0xff};
static const ccColor3B emSilver = {0x99,0x99,0x99};
static const ccColor3B emPink_light = {0xff,0x99,0xff};
static const ccColor3B emPink = {0xff,0,0xff};

static const ccColor3B emPurple = {0x99,0,0xff};
static const ccColor3B emPink_red = {0xff,0,0xff};
static const ccColor3B emRed = {0xff,0,0};
static const ccColor3B emRed_Blood = {0xff,0x33,0x33};

static const ccColor3B emYellow = {0xff,0xff,0};
static const ccColor3B emGreen_Acid = {0x99,0xff,0};
static const ccColor3B emGreen = {0,0xff,0};
static const ccColor3B emOrange = {0xff,0x99,0};

static const ccColor3B emGold = {0xff,0xcc,0x33};
static const ccColor3B emBlue_Sky= {0xcc,0xff,0xff};
static const ccColor3B emBlue_Light = {0x33,0x99,0xff};
static const ccColor3B emBlue = {0,0,0xff};


@interface EmbColor : NSObject
{
  
    
}

+ (NSString *)getColor:(int)color;
+ (int) getColorIndex:(int) r g:(int)g b:(int) b;
@end

//#endif
