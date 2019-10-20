//
//  MockPRDDeviceManagerDelegate.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 20/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "MockPRDDeviceManagerDelegate.h"

@implementation MockPRDDeviceManagerDelegate

-(void)didUpdateDeviceState:(PRDDeviceManagerDeviceState)state {
	self.didUpdateDeviceStateCalled = YES;
}

-(void)didFindDevice:(PRDDeviceManagerDevice)device {
	self.didFindDeviceCalled = YES;
}

-(void)didCompleteBloodPressureMeasurement:(PRDDeviceBloodPressureMeasurement)measurement {
	self.didCompleteBloodPressureMeasurementCalled = YES;
}

-(void)didEncounterError:(NSError *)error {
	self.didEncounterErrorCalled = YES;
}

@end
