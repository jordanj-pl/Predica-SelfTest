//
//  PRDMeasurementInteractor.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDMeasurementInteractor.h"

@import UIKit;

#import "PRDConstants.h"
#import "PRDAppDelegate.h"
#import "PRDDatabaseManager.h"

@interface PRDMeasurementInteractor ()<PRDDeviceManagerDelegate>

@property (nonatomic, strong) PRDDeviceManager *deviceManager;

@end

@implementation PRDMeasurementInteractor

-(instancetype)init {
	self = [super init];
	if(self) {
		_deviceManager = ((PRDAppDelegate*)[UIApplication sharedApplication].delegate).deviceManager;
		_deviceManager.delegate = self;
	}
	return self;
}

-(void)findAndConnect {
	[self.deviceManager scanForCompatibleDevices];
}

-(void)requestDeviceStatus {
	//TODO
}

-(void)requestMeasurement {
	[self.deviceManager requestMeasurement];
}

#pragma mark - PRDDeviceManagerDelegate

-(void)didUpdateDeviceState:(PRDDeviceManagerDeviceState)state {
	[self.output receiveDeviceStatus:(PRDDeviceStatus)state];
}

-(void)didFindDevice:(PRDDeviceManagerDevice)device {
	[self.deviceManager stopScanning];

	NSLog(@"DEVICE: %@ >> %@", device.name, device.uuid);

	[self.output receiveDeviceName:device.name];

	[self.deviceManager connectDevice:device.uuid];
}

-(void)didCompleteBloodPressureMeasurement:(PRDDeviceBloodPressureMeasurement)measurement {

	if(!measurement.readingValid) {
		//TODO handle error
		return;
	}

	PRDMeasurement m;

	m.systolic = (int)measurement.systolic;
	m.diastolic = (int)measurement.diastolic;
	m.unit = measurement.unit;

	if(measurement.timestamp > 0) {
		m.time = [NSDate dateWithTimeIntervalSince1970:measurement.timestamp];
	} else {
		m.time = [NSDate date];
	}

	[self.dbManager insertNewMeasurementWithSystolic:m.systolic diastiolic:m.diastolic unit:m.unit time:m.time];

	[[NSNotificationCenter defaultCenter] postNotificationName:kPRDNewMeasurementNotificationName object:nil];

	[self.output receiveMeasurement:m];

	[self.dbManager saveToPersistentStoreAsync];
}

- (void)didEncounterError:(nonnull NSError *)error {
	//TODO
}


@end
