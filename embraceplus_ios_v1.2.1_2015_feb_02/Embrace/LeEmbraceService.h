/*
 
 File: LeTemperatureAlarmService.h
 
 Abstract: Temperature Alarm Service Header - Connect to a peripheral 
 and get notified when the temperature changes and goes past settable
 maximum and minimum temperatures.
 
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by 
 Apple Inc. ("Apple") in consideration of your agreement to the
 following terms, and your use, installation, modification or
 redistribution of this Apple software constitutes acceptance of these
 terms.  If you do not agree with these terms, please do not use,
 install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. 
 may be used to endorse or promote products derived from the Apple
 Software without specific prior written permission from Apple.  Except
 as expressly stated in this notice, no other rights or licenses, express
 or implied, are granted by Apple herein, including but not limited to
 any patent rights that may be infringed by your derivative works or by
 other works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */



#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "AnimationParameter.h"

/****************************************************************************/
/*						Service Characteristics								*/
/****************************************************************************/


extern NSString *kEmbraceServiceUUIDString;
extern NSString *kPeerOSInformationCharacteristicUUIDString;
extern NSString *kHeartBeatCharacteristicUUIDString;
extern NSString *kUploadEventCharacteristicUUIDString;
extern NSString *kEffectCommandCharacteristicUUIDString;
extern NSString *kUpdateConfigCharacteristicUUIDString;
extern NSString *kAlarmServiceEnteredBackgroundNotification;
extern NSString *kAlarmServiceEnteredForegroundNotification;

/****************************************************************************/
/*								Protocol									*/
/****************************************************************************/
@class LeEmbraceService;


@protocol LeEmbraceProtocol<NSObject>
- (void) deviceDidConnect;
@end

@protocol LeEmbraceBatteryProtocol<NSObject>
- (void) updateEmbraceBatteryInfo;
@end

/****************************************************************************/
/*						Temperature Alarm service.                          */
/****************************************************************************/
@interface LeEmbraceService : NSObject
{
    NSMutableArray *uploadEventArray;
}
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<LeEmbraceProtocol>)controller;
- (void) reset;
- (void) start;

- (void) writeEffectCommand:(AnimationParameter*)parameter silent:(int)silent;
- (void) writeEffectCommand:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause SILENT:(int) silent VIBRATE:(int)vibrate LOOP:(int)loop;
- (void) writeUpdateCofig:(int)appId parameter:(AnimationParameter*)parameter silent:(int)silent;;
- (void) writeUpdateCofig:(int)appId lFromR:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause SILENT:(int) silent VIBRATE:(int)vibrate LOOP:(int)loop;

//- (void) writeEffectCommand:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause SILENT:(int) silent VIBRATE:(int)vibrate LOOP:(int)loop;

//- (void) writeUpdateCofig:(int)appId lFromR:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause SILENT:(int) silent VIBRATE:(int)vibrate LOOP:(int)loop;

-(void) getBatteryLevel;
-(void) clear;

/* Behave properly when heading into and out of the background */
- (void)enteredBackground;
- (void)enteredForeground;

@property (readonly) CBPeripheral *peripheral;
@end
