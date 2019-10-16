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
	PRDDeviceStatusBLEOff = 0,
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


@end

#endif /* PRDMeasurementOutput_h */
