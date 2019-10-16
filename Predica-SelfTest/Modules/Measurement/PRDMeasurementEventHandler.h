//
//  PRDMeasurementEventHandler.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDMeasurementEventHandler_h
#define PRDMeasurementEventHandler_h

@protocol PRDMeasurementEventHandler <NSObject>

-(void)connectWithFirstCompatibleDevice;
-(void)updateDeviceStatus;
-(void)updateMeasurement;

@end

#endif /* PRDMeasurementEventHandler_h */
