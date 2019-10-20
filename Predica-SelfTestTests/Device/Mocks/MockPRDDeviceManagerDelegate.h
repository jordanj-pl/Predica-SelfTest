//
//  MockPRDDeviceManagerDelegate.h
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 20/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDDeviceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MockPRDDeviceManagerDelegate : NSObject <PRDDeviceManagerDelegate>

@property (nonatomic, assign) BOOL didUpdateDeviceStateCalled;
@property (nonatomic, assign) BOOL didFindDeviceCalled;
@property (nonatomic, assign) BOOL didCompleteBloodPressureMeasurementCalled;
@property (nonatomic, assign) BOOL didEncounterErrorCalled;

@end

NS_ASSUME_NONNULL_END
