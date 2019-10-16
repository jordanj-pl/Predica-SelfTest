//
//  PRDMeasurementProvider.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDMeasurementProvider_h
#define PRDMeasurementProvider_h

@protocol PRDMeasurementProvider <NSObject>

-(void)findAndConnect;
-(void)requestDeviceStatus;
-(void)requestMeasurement;

@end

#endif /* PRDMeasurementProvider_h */
