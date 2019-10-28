//
//  PRDMeasurementOutput.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDMeasurementOutput_h
#define PRDMeasurementOutput_h

typedef struct {
	int systolic;
	int diastolic;
	NSString *unit;
	NSDate *time;
} PRDMeasurement;

typedef enum {
	PRDMeasurementErrorInvalidMeasurement = 1,
	PRDMeasurementErrorConnectivityIssue = 2,
} PRDMeasurementError;

typedef enum {
	PRDDeviceStatusBLEOff = 0,
	PRDDeviceStatusBLEUnauthorised,
	PRDDeviceStatusBLEOn,
	PRDDeviceStatusFinding,
	PRDDeviceStatusConnecting,
	PRDDeviceStatusConnected,
	PRDDeviceStatusNonconnected
} PRDDeviceStatus;

@protocol PRDMeasurementOutput <NSObject>

-(void)receiveDeviceStatus:(PRDDeviceStatus)status;
-(void)receiveDeviceName:(NSString*)name;
-(void)receiveMeasurement:(PRDMeasurement)measurement;
-(void)receiveError:(PRDMeasurementError)error;

@end

#endif /* PRDMeasurementOutput_h */
