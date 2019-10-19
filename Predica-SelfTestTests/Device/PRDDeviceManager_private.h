//
//  PRDDeviceManager_private.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 18/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDDeviceManager_private_h
#define PRDDeviceManager_private_h

@import CoreBluetooth;

@interface PRDDeviceManager ()

@property (nonatomic, strong) CBCentralManager *central;
@property (nonatomic, strong) CBPeripheral *currentPeripheral;
@property (nonatomic, assign) PRDDeviceManagerDeviceState state;

@end

#endif /* PRDDeviceManager_private_h */
