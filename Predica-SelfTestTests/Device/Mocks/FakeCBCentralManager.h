//
//  FakeCBCentralManager.h
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import CoreBluetooth;

NS_ASSUME_NONNULL_BEGIN

@interface FakeCBCentralManager : CBCentralManager

@property (nonatomic, strong) NSArray<CBPeripheral*> *fakePeripherals;
@property (nonatomic, assign) BOOL connectPeripheralCalled;

@end

NS_ASSUME_NONNULL_END
