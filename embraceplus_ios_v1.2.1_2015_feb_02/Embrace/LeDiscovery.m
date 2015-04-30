/*

 File: LeDiscovery.m
 
 Abstract: Scan for and discover nearby LE peripherals with the 
 matching service UUID.
 
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



#import "LeDiscovery.h"
#import "FilePath.h"

@interface LeDiscovery () <CBCentralManagerDelegate, CBPeripheralDelegate> {
	//CBCentralManager    *centralManager;
	BOOL				pendingInit;
    
}
@end

extern  int selectStyleIndex;

@implementation LeDiscovery

@synthesize foundPeripherals;
@synthesize RSSIfoundPeripherals;
@synthesize connectedServices;
@synthesize discoveryDelegate;
@synthesize peripheralDelegate;
@synthesize centralManager;

#pragma mark - @dacheng
@synthesize isConnect;
@synthesize connectTimes;
@synthesize p_timer;

#pragma mark -
#pragma mark Init

static BOOL isFirstItem = TRUE;

/****************************************************************************/
/*									Init									*/
/****************************************************************************/
+ (id) sharedInstance
{
    //创建 发现对象
	static LeDiscovery	*this	= nil;

	if (!this)
		this = [[LeDiscovery alloc] init];

	return this;
}


- (id) init
{
    self = [super init];
    if (self) {
		pendingInit = YES;
		centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];

        //下面 数组用来存发现的 外设 和 连接的 服务
		foundPeripherals = [[NSMutableArray alloc] init];
        RSSIfoundPeripherals = [[NSMutableArray alloc] init];
		connectedServices = [[NSMutableArray alloc] init];
        
	}
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
    {
        embraceUUIDDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath embraceUUIDFilePath]];
    }
    else
    {
        embraceUUIDDic = [[NSMutableDictionary alloc]init];
    }
    
    
    return self;
}


- (void) dealloc
{
    // We are a singleton and as such, dealloc shouldn't be called.
    assert(NO);
    [super dealloc];
    [embraceUUIDDic release];
    
    [foundPeripherals release];
    [RSSIfoundPeripherals release];
    [connectedServices release];
    [centralManager release];
    
    //[myTimer release];
}



#pragma mark -
#pragma mark Restoring
/****************************************************************************/
/*								Settings									*/
/****************************************************************************/
/* Reload from file. */
- (void) loadSavedDevices
{
	NSArray	*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];

	if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"No stored array to load");
        return;
    }
     
    for (id deviceUUIDString in storedDevices) {
        
        if (![deviceUUIDString isKindOfClass:[NSString class]])
            continue;
        
        CFUUIDRef uuid = CFUUIDCreateFromString(NULL, (CFStringRef)deviceUUIDString);
        if (!uuid)
            continue;
        
        [centralManager retrievePeripherals:[NSArray arrayWithObject:(id)uuid]];
        CFRelease(uuid);
    }

}


- (void) addSavedDevice:(CFUUIDRef) uuid
{
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;

	if (![storedDevices isKindOfClass:[NSArray class]]) {
        NSLog(@"Can't find/create an array to store the uuid");
        return;
    }

    newDevices = [NSMutableArray arrayWithArray:storedDevices];
    
    uuidString = CFUUIDCreateString(NULL, uuid);
    if (uuidString) {
        [newDevices addObject:(NSString*)uuidString];
        CFRelease(uuidString);
    }
    /* Store */
    [[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) removeSavedDevice:(CFUUIDRef) uuid
{
	NSArray			*storedDevices	= [[NSUserDefaults standardUserDefaults] arrayForKey:@"StoredDevices"];
	NSMutableArray	*newDevices		= nil;
	CFStringRef		uuidString		= NULL;

	if ([storedDevices isKindOfClass:[NSArray class]]) {
		newDevices = [NSMutableArray arrayWithArray:storedDevices];

		uuidString = CFUUIDCreateString(NULL, uuid);
		if (uuidString) {
			[newDevices removeObject:(NSString*)uuidString];
            CFRelease(uuidString);
        }
		/* Store */
		[[NSUserDefaults standardUserDefaults] setObject:newDevices forKey:@"StoredDevices"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}


- (void) centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
	CBPeripheral	*peripheral;
	
    NSString *UUID;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
    {
//        embraceUUIDDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[self embraceUUIDFilePath]];
        
        UUID = [embraceUUIDDic objectForKey:@"UUID"];
        NSLog(@"saved uuid = %@",UUID);
        
    }
    else
    {
        UUID = @"";
    }

    if([peripherals count] > 0)
    {
        for (peripheral in peripherals) {
            NSLog(@"didRetrieveConnectedPeripherals");
    
            if([[peripheral.identifier UUIDString] isEqualToString:UUID])
            {
                NSLog(@"uuid is found");
                [central connectPeripheral:peripheral options:nil];
                [peripheral retain];
                return;
            }
        }
            [central connectPeripheral:peripherals[0] options:nil];
            [peripherals[0] retain];
            
    }
    else{
        [self startScanningForUUIDString:kEmbraceServiceUUIDString];
        
    }
    
//        //??? always disconnect 
//        [central cancelPeripheralConnection:peripheral];
        
        //do scanning
        //开始扫描指定服务
//        [[LeDiscovery sharedInstance] startScanningForUUIDString:kEmbraceServiceUUIDString];
        
        //add connectPeripheral into array
        
	//}

}


- (void) centralManager:(CBCentralManager *)central didRetrievePeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"centralManager::didRetrievePeripheral");
	[central connectPeripheral:peripheral options:nil];
}


- (void) centralManager:(CBCentralManager *)central didFailToRetrievePeripheralForUUID:
    (CFUUIDRef)UUID error:(NSError *)error
{
    NSLog(@"centralManager::didFailToRetrievePeripheralForUUID");
	/* Nuke from plist. */
	[self removeSavedDevice:UUID];
}



#pragma mark -
#pragma mark Discovery
/****************************************************************************/
/*								Discovery                                   */
/****************************************************************************/

- (void) startScanningForUUIDString:(NSString *)uuidString
{
    
    
	NSArray	*uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:uuidString], nil];
    
    //设置 扫描 选项参数
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];

    //直接扫描 UUID= FFC0 ，扫不到，要扫所有？？？
	[centralManager scanForPeripheralsWithServices:uuidArray options:options];
    
    NSLog(@"scanning :: startScanningForUUIDString() ");
    //[centralManager scanForPeripheralsWithServices:nil options:options];
}


- (void) stopScanning
{
	[centralManager stopScan];
    NSLog(@"stopScanning");//sometimes it is 127??
}


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    //为什么找到两次相同的 peripheral
    NSLog(@"RSSI = %@",RSSI);//sometimes it is 127??
    
    if([RSSI intValue] == 127)
    {
        // return;
    }
    
    [self stopScanning];
    
    [foundPeripherals removeAllObjects];
    [RSSIfoundPeripherals removeAllObjects];

	if (![foundPeripherals containsObject:peripheral]) {
		[foundPeripherals addObject:peripheral];
        [RSSIfoundPeripherals addObject:RSSI];
	}

    //start to connect the strongest
    //start a timer
    
    if (isFirstItem)
    {
        myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startConnectBTDevice) userInfo:nil repeats:NO];
        isFirstItem = FALSE;
    }
    
    //选取要连接的 外设
//    targetPeripheral = (CBPeripheral*)[foundPeripherals objectAtIndex:peripheralIndex];
//    if (![targetPeripheral isConnected]) {
//        //如果没有连接 就进行连接
//        [[LeDiscovery sharedInstance] connectPeripheral:peripheral];
//    }
//    else
//    {
//        
//    }

}

- (void)startConnectBTDevice
{
    
    CBPeripheral *targetPeripheral;
    NSNumber * temp;
    int index;
    BOOL isHasfound = FALSE;
    
    NSString *UUID;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
    {
        
        UUID = [embraceUUIDDic objectForKey:@"UUID"];
        NSLog(@"saved uuid = %@",UUID);
        
    }
    else
    {
        UUID = @"";
    }
    
    NSLog(@"foundPeripherals index = %d, count = %d",peripheralIndex,[foundPeripherals count]);
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(version>= 7.0)
    {
        for(int i = 0;i < [foundPeripherals count];i++)
        {
            
            NSLog(@"uuid foundPeripherals %@",[((CBPeripheral *)[foundPeripherals objectAtIndex:i]).identifier UUIDString]);
            
            if([[((CBPeripheral *)[foundPeripherals objectAtIndex:i]).identifier UUIDString] isEqualToString:UUID])
            {
                NSLog(@"uuid is found");
                peripheralIndex = i;
                isHasfound = TRUE;
                break;
            }
            
        }
        
    }

    
    if(!isHasfound)
    {
        
        //find out the strongest RSSI
        for(int i = 0;i < [RSSIfoundPeripherals count];i++)
        {
            if(i ==0)
                temp = [RSSIfoundPeripherals objectAtIndex:i];
            else
            {
                if([RSSIfoundPeripherals objectAtIndex:i] > temp)
                    temp = [RSSIfoundPeripherals objectAtIndex:i];
            }
            
        }
        
        //find out the index of the strongest
        for(int i = 0;i < [RSSIfoundPeripherals count];i++)
        {
            if(temp == [RSSIfoundPeripherals objectAtIndex:i])
            {
                peripheralIndex = i;
                break;
            }
            
        }
        
        NSLog(@"RSSI index = %d =%d =%@",peripheralIndex,[RSSIfoundPeripherals count],[RSSIfoundPeripherals objectAtIndex:peripheralIndex]);
    }

    
    targetPeripheral = (CBPeripheral*)[foundPeripherals objectAtIndex:peripheralIndex];
    if (![targetPeripheral isConnected]) {
        //如果没有连接 就进行连接
        [[LeDiscovery sharedInstance] connectPeripheral:targetPeripheral];
        
        //[central connectPeripheral:peripheral options:nil];
        //[targetPeripheral retain];
    }
    else
    {
        
    }
    
    isFirstItem = TRUE;

}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/*						Connection/Disconnection                            */
/****************************************************************************/
- (void) connectPeripheral:(CBPeripheral*)peripheral
{
	if (![peripheral isConnected]) {
		[centralManager connectPeripheral:peripheral options:nil];
	}
}

- (void) disconnectPeripheral:(CBPeripheral*)peripheral
{
	[centralManager cancelPeripheralConnection:peripheral];
}


- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
	LeEmbraceService	*service	= nil;
	
	float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if(version>= 7.0)
    {
        NSLog(@"didConnectPeripheral UUID = %@",[peripheral.identifier UUIDString]);
        
        NSString * UUID;
        UUID = [peripheral.identifier UUIDString];
        
        [embraceUUIDDic removeAllObjects];
        [embraceUUIDDic setObject:UUID forKey:@"UUID"];
        
        [embraceUUIDDic writeToFile:[FilePath embraceUUIDFilePath] atomically:YES];
    }

	service = [[[LeEmbraceService alloc] initWithPeripheral:peripheral controller:peripheralDelegate] autorelease];
	[service start];
    
	if (![connectedServices containsObject:service])
		[connectedServices addObject:service];

	if ([foundPeripherals containsObject:peripheral])
    {
		[foundPeripherals removeObject:peripheral];
        
    }
    [peripheralDelegate deviceDidConnect];
    
    
#pragma mark - @dacheng
    
    self.isConnect = YES;
    [self.p_timer invalidate];
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"btConnectNotification" object:nil];
}


- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Attempted connection to peripheral %@ failed: %@", [peripheral name], [error localizedDescription]);
}


- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
	LeEmbraceService	*service	= nil;
    NSLog(@"didDisconnectPeripheral !!!!!!!!");
	for (service in connectedServices) {
		if ([service peripheral] == peripheral) {
			[connectedServices removeObject:service];
              NSLog(@"didDisconnectPeripheral **********");
            //[peripheralDelegate alarmServiceDidChangeStatus:service];
			break;
		}
	}
    
#pragma mark - @dacheng
    self.isConnect = NO;
    self.p_timer =  [NSTimer scheduledTimerWithTimeInterval:BuleToothScanInterval target:self selector:@selector(firstConnect) userInfo:nil repeats:YES];
    
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"btDisconnectNotification" object:nil];
    [self startScanningForUUIDString:kEmbraceServiceUUIDString];
}


- (void) clearDevices
{
    LeEmbraceService	*service;
    [foundPeripherals removeAllObjects];
    [RSSIfoundPeripherals removeAllObjects];
    
    for (service in connectedServices) {
        [service reset];
    }
    [connectedServices removeAllObjects];
}


- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;
    NSLog(@"centralManagerDidUpdateState !!!!!!!!= %d",[centralManager state]);
	switch ([centralManager state]) {
		case CBCentralManagerStatePoweredOff:
		{
            [self clearDevices];

            //send notification bt is off
#pragma mark - kane
//            [[NSNotificationCenter  defaultCenter]postNotificationName:@"btDisconnectNotification" object:nil];
			break;
		}
            
		case CBCentralManagerStateUnauthorized:
		{
			/* Tell user the app is not allowed. */
            NSLog(@"CBCentralManagerStateUnauthorized");
			break;
		}
            
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        }
		case CBCentralManagerStateUnknown:
		{
			/* Bad news, let's wait for another event. */
            NSLog(@"CBCentralManagerStateUnknown");
			break;
		}
            
		case CBCentralManagerStatePoweredOn:
		{
			pendingInit = NO;
			[self loadSavedDevices];
            NSLog(@"CBCentralManagerStatePoweredOn");
            
            
            float version = [[[UIDevice currentDevice] systemVersion] floatValue];
            
            NSLog(@"ios version = %f",version);
            if(version<7.0)
            {
                [centralManager retrieveConnectedPeripherals];
            }
            else
            {
                NSArray			*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:kEmbraceServiceUUIDString], nil];
                
                NSArray *connectedPeripheralArray = [[NSArray alloc] init];
                connectedPeripheralArray = [centralManager retrieveConnectedPeripheralsWithServices:uuidArray];
                
                NSLog(@"connectedPeripheralArray = %d",[connectedPeripheralArray count]);
                CBPeripheral *peripheral;
                
                NSString *UUID;
                if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
                {
//                    embraceUUIDDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[self embraceUUIDFilePath]];
                    
                    UUID = [embraceUUIDDic objectForKey:@"UUID"];
                    NSLog(@"saved uuid = %@",UUID);
                    
                }
                else
                {
                    UUID = @"";
                }
                
                if([connectedPeripheralArray count] > 0)
                {
                    for (peripheral in connectedPeripheralArray) {
                        NSLog(@"didRetrieveConnectedPeripherals");
                        
                        if([[peripheral.identifier UUIDString] isEqualToString:UUID])
                        {
                            NSLog(@"uuid is found");
                            [central connectPeripheral:peripheral options:nil];
                            [peripheral retain];
                            return;
                        }
                    }
                    
                    [central connectPeripheral:connectedPeripheralArray[0] options:nil];
                    [connectedPeripheralArray[0] retain];
                    
                }else
                {
                    NSLog(@"start scanning!!!!!!!");
                    [self startScanningForUUIDString:kEmbraceServiceUUIDString];
                    
#pragma mark - @dacheng  kai shi jian cha
                }

                
            }
            
            
            
			break;
		}
            
		case CBCentralManagerStateResetting:
		{
			[self clearDevices];
            
			pendingInit = YES;
			break;
		}
	}
    
    previousState = [centralManager state];
}


#pragma mark - @dacheng  connect  when cannot connect
- (void)reConnect
{
    
    CBCentralManager * central;
    central = self.centralManager;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version<7.0)
    {
        [central retrieveConnectedPeripherals];
    }
    else
    {
        NSArray	*uuidArray	= [NSArray arrayWithObjects:[CBUUID UUIDWithString:kEmbraceServiceUUIDString], nil];
        
        NSArray *connectedPeripheralArray = [[NSArray alloc] init];
        connectedPeripheralArray = [central retrieveConnectedPeripheralsWithServices:uuidArray];
        
        NSLog(@"connectedPeripheralArray = %d",[connectedPeripheralArray count]);
        CBPeripheral *peripheral;
        
        NSString *UUID;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[FilePath embraceUUIDFilePath]])
        {
            embraceUUIDDic = [[NSMutableDictionary alloc]initWithContentsOfFile:[FilePath embraceUUIDFilePath]];
            
            UUID = [embraceUUIDDic objectForKey:@"UUID"];
            NSLog(@"saved uuid = %@",UUID);
            
        }
        else
        {
            UUID = @"";
        }
        
        if([connectedPeripheralArray count] > 0)
        {
            for (peripheral in connectedPeripheralArray) {
                NSLog(@"didRetrieveConnectedPeripherals");
                
                if([[peripheral.identifier UUIDString] isEqualToString:UUID])
                {
                    NSLog(@"uuid is found");
                    [central connectPeripheral:peripheral options:nil];
                    [peripheral retain];
                    return;
                }
            }
            
            [central connectPeripheral:connectedPeripheralArray[0] options:nil];
            [connectedPeripheralArray[0] retain];
            
        }else
        {
            NSLog(@"start scanning!!!!!!!");
            [[LeDiscovery sharedInstance] startScanningForUUIDString:kEmbraceServiceUUIDString];
        }
        
    }

}

- (void)firstConnect
{
    if(self.isConnect == NO)
    {
        [self reConnect];
    }
}


@end
