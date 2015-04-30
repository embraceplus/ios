/*

 File: LeTemperatureAlarmService.m
 
 Abstract: Temperature Alarm Service Code - Connect to a peripheral 
 get notified when the temperature changes and goes past settable
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



#import "LeEmbraceService.h"
#import "LeDiscovery.h"
#import "EmbColor.h"
#import "FilePath.h"
#import "NotificationUtility.h"

NSString *kBatteryServiceUUIDString = @"180F";
NSString *kEmbraceServiceUUIDString = @"FFC0";
NSString *kPeerOSInformationCharacteristicUUIDString = @"FFC1";
NSString *kHeartBeatCharacteristicUUIDString = @"FFC2";
NSString *kUploadEventCharacteristicUUIDString = @"FFC3";
NSString *kEffectCommandCharacteristicUUIDString = @"FFC4";
NSString *kUpdateConfigCharacteristicUUIDString = @"FFC5";

//service 0x180F uint8
NSString *kBatteryLevelCharacteristicUUIDString = @"2A19";

NSString *kAlarmServiceEnteredBackgroundNotification = @"kAlarmServiceEnteredBackgroundNotification";
NSString *kAlarmServiceEnteredForegroundNotification = @"kAlarmServiceEnteredForegroundNotification";

extern  int selectStyleIndex;
extern BOOL isFirstConnect;
//extern  int selectFxIndex;
int selectFxIndex;
@interface LeEmbraceService() <CBPeripheralDelegate> {
@private
    CBPeripheral		*servicePeripheral;
    
    CBService			*leEmbraceService;
    CBService			*leEmbraceBatteryService;
    CBCharacteristic    *peerOsInfoCharacteristic;
    CBCharacteristic	*hearBeatCharacteristic;
    CBCharacteristic    *uploadEventCharacteristic;
    CBCharacteristic    *effectCommandCharacteristic;
    CBCharacteristic    *updateConfigCharacteristic;
    CBCharacteristic    *batteryLevelCharacteristic;
    
    CBUUID              *peerOsInfoUUID;
    CBUUID              *heartBeatUUID;
    CBUUID              *uploadEventUUID;
    CBUUID              *effectCommandUUID;
    CBUUID              *updateConfigUUID;
    CBUUID              *batteryLevelUUID;
    
    
//    NSMutableDictionary *fxForStyleDic;
//    
//    NSMutableArray *notificationTitles;
//    NSMutableArray *callsNotificationTitles;
//    NSMutableArray *notificationIsSilent;
//    NSMutableArray *callsNotificationIsSilent;
    
    
    id<LeEmbraceProtocol>	peripheralDelegate;
    
    id<LeEmbraceBatteryProtocol>	peripheralBatteryDelegate;
    
}
@end



@implementation LeEmbraceService


@synthesize peripheral = servicePeripheral;


#pragma mark -
#pragma mark Init

/****************************************************************************/
/*								Init										*/
/****************************************************************************/
- (id) initWithPeripheral:(CBPeripheral *)peripheral controller:(id<LeEmbraceProtocol>)controller
{
    self = [super init];
    if (self) {
        servicePeripheral = [peripheral retain];//保留得到的periperal
        [servicePeripheral setDelegate:self];
        
        //把代理传过来
		peripheralDelegate = controller;
    
        peerOsInfoUUID	= [[CBUUID UUIDWithString:kPeerOSInformationCharacteristicUUIDString] retain];
        heartBeatUUID	= [[CBUUID UUIDWithString:kHeartBeatCharacteristicUUIDString] retain];
        uploadEventUUID	= [[CBUUID UUIDWithString:kUploadEventCharacteristicUUIDString] retain];
        effectCommandUUID	= [[CBUUID UUIDWithString:kEffectCommandCharacteristicUUIDString] retain];
        updateConfigUUID	= [[CBUUID UUIDWithString:kUpdateConfigCharacteristicUUIDString] retain];
        
        
        batteryLevelUUID	= [[CBUUID UUIDWithString:kBatteryLevelCharacteristicUUIDString] retain];
        
        uploadEventArray = [[NSMutableArray alloc]init];

	}
    

    return self;
}



- (void) dealloc {
	if (servicePeripheral) {
		[servicePeripheral setDelegate:[LeDiscovery sharedInstance]];
		[servicePeripheral release];
		servicePeripheral = nil;
        
        [peerOsInfoUUID release];
        [heartBeatUUID release];
        [uploadEventUUID release];
        [effectCommandUUID release];
        [updateConfigUUID release];
    }
    [super dealloc];
}


- (void) reset
{
	if (servicePeripheral) {
		[servicePeripheral release];
		servicePeripheral = nil;
	}
}



#pragma mark -
#pragma mark Service interaction
/****************************************************************************/
/*							Service Interactions							*/
/****************************************************************************/
- (void) start
{
	CBUUID	*serviceUUID	= [CBUUID UUIDWithString:kEmbraceServiceUUIDString];
    CBUUID	*batteryServiceUUID	= [CBUUID UUIDWithString:kBatteryServiceUUIDString];
	NSArray	*serviceArray	= [NSArray arrayWithObjects:serviceUUID,batteryServiceUUID, nil];

    //发现服务
    [servicePeripheral discoverServices:serviceArray];
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    
	NSArray		*services	= nil;
    
	NSArray		*uuids	= [NSArray arrayWithObjects:peerOsInfoUUID,
								   heartBeatUUID,
								   uploadEventUUID,
								   effectCommandUUID,
                                    updateConfigUUID,
								   nil];

	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
		return ;
	}

	services = [peripheral services];
    
	if (!services || ![services count]) {
		return ;
	}

	leEmbraceService = nil;
    
	for (CBService *service in services) {
        NSLog(@"didDiscoverServices !!!!!!!= %@",[service UUID]);
		if ([[service UUID] isEqual:[CBUUID UUIDWithString:kEmbraceServiceUUIDString]]) {
			leEmbraceService = service;
			continue;
		}
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kBatteryServiceUUIDString]]) {
			leEmbraceBatteryService = service;
			continue;
		}
	}


	if (leEmbraceService) {
		[peripheral discoverCharacteristics:uuids forService:leEmbraceService];
	}
    
    if (leEmbraceBatteryService) {
		[peripheral discoverCharacteristics:nil forService:leEmbraceBatteryService];
	}
}


- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error;
{
    //NSLog(@"didDiscoverCharacteristicsForService = %@",[[service characteristics] UUID]);
	NSArray		*characteristics	= [service characteristics];
	CBCharacteristic *characteristic;
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong Peripheral.\n");
		return ;
	}
	
	if (service != leEmbraceService && service != leEmbraceBatteryService ) {
		NSLog(@"Wrong Service.\n");
		return ;
	}
    
    if (error != nil) {
		NSLog(@"Error %@\n", error);
		return ;
	}
    

	for (characteristic in characteristics) {
        NSLog(@"discovered characteristic !!!!!!!!%@", [characteristic UUID]);
        
		if ([[characteristic UUID] isEqual:peerOsInfoUUID]) { // Min Temperature.
            NSLog(@"Discovered peerOsInfoUUID Characteristic");
			peerOsInfoCharacteristic = [characteristic retain];
            
            float iosVersion;
            Byte byte[5];
            iosVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
            NSLog(@"IOS version !!!!!!!!= %f",iosVersion);
            
            byte[0] = 'I';
            byte[1] = 'O';
            byte[2] = 'S';
            byte[4] = 0;
            if(iosVersion>=7.0)
            {
                byte[3] = '7';
            }
            else
            {
                byte[3] = '6';
            }
            
            NSData  *data	= nil;
            data = [[NSData alloc] initWithBytes:byte length:5];
            
        
            NSLog(@"length = %d",data.length);
            
            [peripheral writeValue:data forCharacteristic:peerOsInfoCharacteristic
                              type:CBCharacteristicWriteWithResponse];
            
            [data release];
//            //可以判断characteristic 是否可读
//			[peripheral readValueForCharacteristic:characteristic];
		}
        else if ([[characteristic UUID] isEqual:heartBeatUUID]) {
            NSLog(@"Discovered heartBeatUUID Characteristic");
			hearBeatCharacteristic = [characteristic retain];
            
            [peripheral setNotifyValue:YES forCharacteristic:hearBeatCharacteristic];

		}
        else if ([[characteristic UUID] isEqual:uploadEventUUID]) {
            NSLog(@"Discovered uploadEventUUID Characteristic");
			uploadEventCharacteristic = [characteristic retain];
            
            [peripheral setNotifyValue:YES forCharacteristic:uploadEventCharacteristic];
           
		}
        else if ([[characteristic UUID] isEqual:effectCommandUUID]) {
            NSLog(@"Discovered effectCommandUUID Characteristic");
			effectCommandCharacteristic = [characteristic retain];
            
		}
        else if ([[characteristic UUID] isEqual:updateConfigUUID]) {
            NSLog(@"Discovered updateConfigUUID Characteristic");
			updateConfigCharacteristic = [characteristic retain];
            
            if(isFirstConnect)
            {
                [NotificationUtility configAllNotification:selectStyleIndex];
                isFirstConnect = NO;
            }
            
		}
        else if ([[characteristic UUID] isEqual:batteryLevelUUID]) {
            //NSLog(@"Discovered batteryLevelUUID Characteristic");
			batteryLevelCharacteristic = [characteristic retain];
            
		}

	}
}
#pragma mark - public
- (void)writeEffectCommand:(AnimationParameter *)parameter silent:(int)silent{
    [self writeEffectCommand:parameter.lFromR
                      lFromG:parameter.lFromG
                      lFromB:parameter.lFromB
                        lToR:parameter.lToR
                        lToG:parameter.lToG
                        lToB:parameter.lToB
                      rFromR:parameter.rFromR
                      rFromG:parameter.rFromG
                      rFromB:parameter.rFromB
                        rToR:parameter.rToR
                        rToG:parameter.rToG
                        rToB:parameter.rToB
                    DURATION:parameter.durationTime1
                   DURATION2:parameter.durationTime2
                    BLACKOUT:parameter.isBlackout
                      RANDOM:parameter.isRandom
                        HOLD:parameter.hold
                       PAUSE:parameter.pause
                      SILENT:silent
                     VIBRATE:parameter.isVibrate
                        LOOP:parameter.loop];
}

- (void)writeUpdateCofig:(int)appId parameter:(AnimationParameter *)parameter silent:(int)silent{
    [self writeUpdateCofig:appId
                    lFromR:parameter.lFromR
                      lFromG:parameter.lFromG
                      lFromB:parameter.lFromB
                        lToR:parameter.lToR
                        lToG:parameter.lToG
                        lToB:parameter.lToB
                      rFromR:parameter.rFromR
                      rFromG:parameter.rFromG
                      rFromB:parameter.rFromB
                        rToR:parameter.rToR
                        rToG:parameter.rToG
                        rToB:parameter.rToB
                    DURATION:parameter.durationTime1
                   DURATION2:parameter.durationTime2
                    BLACKOUT:parameter.isBlackout
                      RANDOM:parameter.isRandom
                        HOLD:parameter.hold
                       PAUSE:parameter.pause
                      SILENT:silent
                     VIBRATE:parameter.isVibrate
                        LOOP:parameter.loop];
}

#pragma mark -
#pragma mark Characteristics interaction
///****************************************************************************/
///*						Characteristics Interactions						*/
///****************************************************************************/
- (void) writeEffectCommand:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause SILENT:(int) silent VIBRATE:(int)vibrate LOOP:(int)loop
{
    NSData  *data	= nil;
    
    NSLog(@"writeEffectCommand");
    if (!servicePeripheral) {
        NSLog(@"Not connected to a peripheral");
		return ;
    }

    if (!effectCommandCharacteristic) {
        NSLog(@"No valid effectCommandCharacteristic characteristic");
        return;
    }
    
    int c1Index,c2Index,c3Index,c4Index;
    
    c1Index = [EmbColor getColorIndex:lFromR g:lFromG b:lFromB];
    c2Index = [EmbColor getColorIndex:lToR g:lToG b:lToB];
    c3Index = [EmbColor getColorIndex:rFromR g:rFromG b:rFromB];
    c4Index = [EmbColor getColorIndex:rToR g:rToG b:rToB];

    //vibrate = 1;
    NSLog(@"vibrate in effect = %d",vibrate);
    Byte byte[10];
    byte[0] = loop;
    byte[1] = pause/10;

    if(silent == 0)
        byte[2] = (blackout<<1)|random|0x4|(vibrate<<3);
    else
        byte[2] = (blackout<<1)|random|(vibrate<<3);

    byte[3] = durationMil1/10;
    byte[4] = hold/10;
    byte[5] = durationMil2/10;
    byte[6] = c1Index;
    byte[7] = c2Index;
    byte[8] = c3Index;
    byte[9] = c4Index;
    
    
    for(int i=0;i<10;i++)
    {
        NSLog(@"write data %d= 0x%x",i,byte[i]);
    }
    data = [[NSData alloc] initWithBytes:byte length:10];

    
    if(servicePeripheral)
        [servicePeripheral writeValue:data forCharacteristic:effectCommandCharacteristic type:CBCharacteristicWriteWithResponse];
    
    [data release];
}

- (void) writeUpdateCofig:(int)appId lFromR:(int)lFromR lFromG:(int)lFromG lFromB:(int)lFromB lToR:(int)lToR lToG:(int)lToG lToB:(int)lToB rFromR:(int)rFromR rFromG:(int)rFromG rFromB:(int)rFromB rToR:(int)rToR rToG:(int)rToG rToB:(int)rToB DURATION:(int)durationMil1 DURATION2:(int)durationMil2 BLACKOUT:(int)blackout RANDOM:(int)random HOLD:(int)hold PAUSE:(int)pause SILENT:(int) silent VIBRATE:(int)vibrate LOOP:(int)loop
{
    NSData  *data	= nil;
    
    NSLog(@"writeUpdateCofig");
    if (!servicePeripheral) {
        NSLog(@"Not connected to a peripheral");
		return ;
    }
    
    if (!updateConfigCharacteristic) {
        NSLog(@"No valid updateConfigCharacteristic characteristic");
        return;
    }
    
    int c1Index,c2Index,c3Index,c4Index;
    
    c1Index = [EmbColor getColorIndex:lFromR g:lFromG b:lFromB];
    c2Index = [EmbColor getColorIndex:lToR g:lToG b:lToB];
    c3Index = [EmbColor getColorIndex:rFromR g:rFromG b:rFromB];
    c4Index = [EmbColor getColorIndex:rToR g:rToG b:rToB];
    
    Byte byte[11];
    
    byte[0] = appId;
    byte[1] = loop;
    byte[2] = pause/10;
    
    NSLog(@"silent ======================== %d",silent);
    if(silent == 0)
        byte[3] = (blackout<<1)|random|0x4|(vibrate<<3);
    else
        byte[3] = (blackout<<1)|random|(vibrate<<3);
    
    byte[4] = durationMil1/10;
    byte[5] = hold/10;
    byte[6] = durationMil2/10;
    byte[7] = c1Index;
    byte[8] = c2Index;
    byte[9] = c3Index;
    byte[10] = c4Index;
    
    
    for(int i=0;i<11;i++)
    {
        NSLog(@"write data = 0x%x",byte[i]);
    }
    data = [[NSData alloc] initWithBytes:byte length:11];
    
    if(servicePeripheral)
        [servicePeripheral writeValue:data  forCharacteristic:updateConfigCharacteristic type:CBCharacteristicWriteWithResponse];
    
    [data release];
}

-(void) getBatteryLevel
{
    //NSLog(@"Reading value for characteristic %@", batteryLevelCharacteristic.UUID);
    if(servicePeripheral)
    {
        if (batteryLevelCharacteristic) {
            [servicePeripheral readValueForCharacteristic:batteryLevelCharacteristic];
        }
    }
}

-(void) clear
{
    if (servicePeripheral) {
		[servicePeripheral release];
		servicePeripheral = nil;
        
    }


}
/** If we're connected, we don't want to be getting temperature change notifications while we're in the background.
 We will want alarm notifications, so we don't turn those off.
 */
- (void)enteredBackground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kEmbraceServiceUUIDString]]) {
            
         }
    }
}

/** Coming back from the background, we want to register for notifications again for the temperature changes */
- (void)enteredForeground
{
    // Find the fishtank service
    for (CBService *service in [servicePeripheral services]) {
        if ([[service UUID] isEqual:[CBUUID UUIDWithString:kEmbraceServiceUUIDString]]) {
            
            // Find the temperature characteristic
//            for (CBCharacteristic *characteristic in [service characteristics]) {
//
//            }
        }
    }
}



//读会调用这个函数， 如果读出错，会返回出错
- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    int notificationIndex;
    
	if (peripheral != servicePeripheral) {
		NSLog(@"Wrong peripheral\n");
		return ;
	}

    if ([error code] != 0) {
		NSLog(@"Error %@\n", error);
		return ;
	}

    if ([[characteristic UUID] isEqual:batteryLevelUUID]) {
        
        NSData *data = characteristic.value;
        Byte *dataByte = (Byte *)[data bytes];
        
        int batteryValue;
        batteryValue = dataByte[1]<<8|dataByte[0];
        NSLog(@"battery level = %d",batteryValue);
        
        [[NSNotificationCenter  defaultCenter]postNotificationName:@"batteryLevelNotification" object:[NSNumber numberWithInt:batteryValue]];
        
        return;
    }
    if ([[characteristic UUID] isEqual:heartBeatUUID]) {

        //NSLog(@"didUpdateValueForCharacteristic+heartBeatUUID!!!!!!!!");
        return;
    }
    if ([[characteristic UUID] isEqual:uploadEventUUID]) {
        
        NSLog(@"didUpdateValueForCharacteristic+uploadEventUUID!!!!!!!!");
        
        NSMutableArray * notificationTitles;
        NSMutableArray * callsNotificationTitles;
        NSMutableArray * callsNotificationIsSilent;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath notificationTitleFilePath]])
        {
            
            notificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath notificationTitleFilePath]];
        }

        
        NSData *data = characteristic.value;
        Byte *dataByte = (Byte *)[data bytes];
    
        [uploadEventArray addObject:data];
        if(dataByte[[data length]-1] == 0)
        {
            NSMutableData *appId =[[NSMutableData alloc] initWithData:[uploadEventArray objectAtIndex:0]];
            for(int i =0; i < [uploadEventArray count]-1; i++)
            {
                [appId appendData:[uploadEventArray objectAtIndex:i+1]];
            }
            
#pragma mark - 读取来电人的姓名 kane 如果是NO CallID 则字符串为空
            NSString *appIdString = [[NSString alloc] initWithData:appId encoding:NSUTF8StringEncoding];
            if([appIdString isEqualToString:@""] || appIdString.length == 0)
            {
                return;
            }
            
            NSString *appIdStringTemp = [appIdString substringToIndex:[appIdString length]-1];
            //
            NSLog(@"uploadEventUUID length=%d =%@",[appIdString length],appIdString);
            NSLog(@"uploadEventUUID length=%d =%@",[appIdStringTemp length],appIdStringTemp);
            [uploadEventArray removeAllObjects];
            
            
            //compare the AppId， then send out the effect command
            if([appIdString rangeOfString:@"lowbattery"].length!= 0)
            {
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Warning"
                                                               message:@"Embrace battery is low"
                                                              delegate:self
                                                     cancelButtonTitle:@"ok"
                                                     otherButtonTitles:nil];
                [alert show];
                
                return;

            }
            
            if([appIdString rangeOfString:@"com.apple.mobilephone"].length!= 0)
            {
               
            
            }

            //search name in the list, find out the effect
            if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationTitleFilePath]])
            {
                
                callsNotificationTitles = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationTitleFilePath]];
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath callsNotificationIsSilentFilePath]])
            {
                
                callsNotificationIsSilent = [[NSMutableArray alloc]initWithContentsOfFile:[FilePath callsNotificationIsSilentFilePath]];
            }

            BOOL isFound = NO;
            
            int i;
            for(i = 2;i < [callsNotificationTitles count];i ++)
            {
                NSLog(@"name = %@",callsNotificationTitles[i]);
                if([callsNotificationTitles[i] rangeOfString:appIdStringTemp].length!= 0)
                {
                    notificationIndex = 100 + i;
                    isFound = YES;
                    break;
                }
            }
            
            if(isFound)
            {
                NSLog(@"notificationIndex = %d",notificationIndex);
                
                int lFromR;
                int lFromG;
                int lFromB;
                
                int lToR;
                int lToG;
                int lToB;
                
                int rFromR;
                int rFromG;
                int rFromB;
                
                int rToR;
                int rToG;
                int rToB;
                
                int durationTime1;
                int durationTime2;
                int isBlackout;
                int isRandom;
                
                int hold;
                int pause;
                int isVibrate;
                int loop;
                int silent;

                //compare the AppId， then send out the effect command
                NSMutableArray *fxTitleArray;
                NSMutableDictionary *fxForStyleDic;
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxForStyleFilePath]])
                {
                    fxForStyleDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxForStyleFilePath]];
                    NSMutableDictionary *dictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"%d",selectStyleIndex]];
                    fxTitleArray = [dictionary objectForKey:@"title"];
                    
                    NSMutableDictionary *notificationDictionary = [fxForStyleDic objectForKey:[NSString stringWithFormat:@"style%d",selectStyleIndex]];
                    
                    selectFxIndex = [[notificationDictionary objectForKey:[NSString stringWithFormat:@"%d",notificationIndex]] intValue];
                    
                }
                
                NSLog(@"selectFxIndex = %d,notificationIndex = %d selectStyleIndex = %d",selectFxIndex,notificationIndex,selectStyleIndex);
                
                NSMutableDictionary *fxMenuLightDataDic = [[NSMutableDictionary alloc]init];
                if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath fxMenuLightDataFilePath]])
                {
                    fxMenuLightDataDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath fxMenuLightDataFilePath]];
                }
                
                NSArray *lightDataArray = [fxMenuLightDataDic objectForKey:[fxTitleArray objectAtIndex:selectFxIndex]];
                NSLog(@"FX name =%@",[fxTitleArray objectAtIndex:selectFxIndex]);
                
                
                lFromR = [[lightDataArray objectAtIndex:0] intValue];    //L灯 R  (From)
                lFromG= [[lightDataArray objectAtIndex:1] intValue];    //L灯 G  (From)
                lFromB = [[lightDataArray objectAtIndex:2] intValue];    //L灯 B  (From)
                
                lToR = [[lightDataArray objectAtIndex:3] intValue];    //L灯 R  (To)
                lToG = [[lightDataArray objectAtIndex:4] intValue];    //L灯 G  (To)
                lToB = [[lightDataArray objectAtIndex:5] intValue];    //L灯 B  (To)
                
                
                rFromR= [[lightDataArray objectAtIndex:6] intValue];    //R灯 R  (From)
                rFromG= [[lightDataArray objectAtIndex:7] intValue];    //R灯 G  (From)
                rFromB= [[lightDataArray objectAtIndex:8] intValue];    //R灯 B  (From)
                
                rToR = [[lightDataArray objectAtIndex:9] intValue];    //R灯 R  (To)
                rToG = [[lightDataArray objectAtIndex:10] intValue];    //R灯 G  (To)
                rToB = [[lightDataArray objectAtIndex:11] intValue];    //R灯 B  (To)
                
                durationTime1 = [[lightDataArray objectAtIndex:12] intValue];    //duration
                durationTime2 = [[lightDataArray objectAtIndex:13] intValue];    //duration
                
                isBlackout = [[lightDataArray objectAtIndex:14] intValue];
                isRandom = [[lightDataArray objectAtIndex:15] intValue];
                hold = [[lightDataArray objectAtIndex:16] intValue];
                pause = [[lightDataArray objectAtIndex:17] intValue];
                isVibrate = [[lightDataArray objectAtIndex:18] intValue];
                loop = [[lightDataArray objectAtIndex:19] intValue];
                
                //is silent or not
                if([callsNotificationIsSilent[i] intValue] == 0)
                {
                    
                    silent = 0;
                }
                else
                {
                    silent = 1;
                    isVibrate = 0;
                }
          
                //写
                [self writeEffectCommand:lFromR lFromG:lFromG lFromB:lFromB lToR:lToR lToG:lToG lToB:lToB rFromR:rFromR rFromG:rFromG rFromB:rFromB rToR:rToR rToG:rToG rToB:rToB DURATION:durationTime1 DURATION2:durationTime2 BLACKOUT:isBlackout RANDOM:isRandom HOLD:hold PAUSE:pause SILENT:silent VIBRATE:isVibrate LOOP:loop];
                
//            [fxForStyleDic release];
//            [fxMenuLightDataDic release];
            }
           
        }
       
//        [notificationTitles release];
//        [callsNotificationTitles release];

        return;
    }

 }

- (void)peripheral:(CBPeripheral *)peripheral
didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    
    NSLog(@"didUpdateNotificationStateForCharacteristic = %@",characteristic.UUID);
    if (error) {
        NSLog(@"Error changing notification state: %@",
              [error localizedDescription]);
    }
}
- (void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if(error)
    {
        NSLog(@"Error didWriteValueForCharacteristic: %@",
              [error localizedDescription]);
    }
    if ([characteristic.UUID isEqual:effectCommandUUID])
    {
        NSLog(@"didWriteValueForCharacteristic= effectCommandCharacteristic");
        
        
    }
    
    if ([characteristic.UUID isEqual:updateConfigUUID])
    {
        NSLog(@"didWriteValueForCharacteristic= updateConfigCharacteristic");
    }
    /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
    //[peripheral readValueForCharacteristic:characteristic];
    
//    /* Upper or lower bounds changed */
//    if ([characteristic.UUID isEqual:minimumTemperatureUUID] || [characteristic.UUID isEqual:maximumTemperatureUUID]) {
//        [peripheralDelegate alarmServiceDidChangeTemperatureBounds:self];
//    }
}
@end
