//
//  PRDMeasurementPresenter.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDMeasurementPresenter.h"

@implementation PRDMeasurementPresenter

#pragma mark Event Handler

-(void)connectWithFirstCompatibleDevice {
	[self.provider findAndConnect];
}

-(void)updateDeviceStatus {
//TODO
}

-(void)updateMeasurement {
	[self.provider requestMeasurement];
}

#pragma mark Output

-(void)receiveMeasurement:(PRDMeasurement)measurement {
//TODO Complete

	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	[df setTimeStyle:NSDateFormatterShortStyle];

	dispatch_async(dispatch_get_main_queue(), ^{
		[self.view setSystolic:[NSString stringWithFormat:@"%d", measurement.systolic]];
		[self.view setDiastolic:[NSString stringWithFormat:@"%d", measurement.diastolic]];

		[self.view setTime:[df stringFromDate:measurement.time]];
		[self.view setPressureUnit:measurement.unit];
	});
}

-(void)receiveDeviceStatus:(PRDDeviceStatus)status {
	NSString *txtStatus = @"";
	BOOL updateButtonEnabled = NO;

	switch (status) {
		case PRDDeviceStatusBLEOff:
				txtStatus = @"Bluetooth Off";
			break;

			case PRDDeviceStatusBLEOn:
				txtStatus = @"Bluetooth On";
				break;

			case PRDDeviceStatusFinding:
				txtStatus = @"Finding devices...";
				break;

			case PRDDeviceStatusConnecting:
				txtStatus = @"Connecting...";
				break;

			case PRDDeviceStatusConnected:
				txtStatus = @"Connected";
				updateButtonEnabled = YES;
				break;

			case PRDDeviceStatusNonconnected:
				txtStatus = @"Not connected";
				break;

			default:
				txtStatus = @"Unknown";
				break;
	}

	dispatch_async(dispatch_get_main_queue(), ^{
		[self.view setDeviceStatus:txtStatus];
		[self.view setUpdateButtonEnabled:updateButtonEnabled];
	});
}

-(void)receiveDeviceName:(NSString *)name {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self.view setDeviceName:name];
	});
}

@end
