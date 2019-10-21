//
//  PRDDeviceManager.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

typedef enum {
	PRDDeviceManagerDeviceStateBLEOff = 0,//BLE is OFF or unavailable for other reasons
	PRDDeviceManagerDeviceStateBLEUnauthorised,//No permission to use Bluetooth
	PRDDeviceManagerDeviceStateBLEOn, //BLE is on and read
	PRDDeviceManagerDeviceStateFinding, //Scanning for devices
	PRDDeviceManagerDeviceStateConnecting, //Connecting to device
	PRDDeviceManagerDeviceStateConnected, //Connected to device
	PRDDeviceManagerDeviceStateDisconnected //Disconnected from device, BLE is ON and ready
} PRDDeviceManagerDeviceState;

typedef struct {
	NSString *name;
	NSUUID *uuid;
} PRDDeviceManagerDevice;

typedef struct {
	bool readingValid;
	NSString *unit;
	double systolic;
	double diastolic;
	NSTimeInterval timestamp;

} PRDDeviceBloodPressureMeasurement;

@protocol PRDDeviceManagerDelegate <NSObject>

-(void)didUpdateDeviceState:(PRDDeviceManagerDeviceState)state;
-(void)didFindDevice:(PRDDeviceManagerDevice)device;
-(void)didCompleteBloodPressureMeasurement:(PRDDeviceBloodPressureMeasurement)measurement;
-(void)didEncounterError:(NSError*)error;

@end

@interface PRDDeviceManager : NSObject

@property (nonatomic, assign, readonly) PRDDeviceManagerDeviceState state;
@property (nonatomic, weak) id<PRDDeviceManagerDelegate> delegate;

-(void)scanForCompatibleDevices;
-(void)stopScanning;
-(void)connectDevice:(NSUUID*)deviceUUID;
-(void)requestMeasurement;

@end

NS_ASSUME_NONNULL_END
