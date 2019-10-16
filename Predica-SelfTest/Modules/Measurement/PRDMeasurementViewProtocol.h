//
//  PRDMeasurementViewProtocol.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDMeasurementViewProtocol_h
#define PRDMeasurementViewProtocol_h

@protocol PRDMeasurementView <NSObject>

-(void)setDeviceStatus:(NSString*)status;
-(void)setDeviceName:(NSString*)name;
-(void)setSystolic:(NSString*)systolic;
-(void)setDiastolic:(NSString*)diastolic;
-(void)setPressureUnit:(NSString*)unit;
-(void)setTime:(NSString*)time;
-(void)setUpdateButtonEnabled:(BOOL)enabled;

@end

#endif /* PRDMeasurementViewProtocol_h */
