//
//  FakeCBPeripheral.h
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import CoreBluetooth;

NS_ASSUME_NONNULL_BEGIN

@interface FakeCBPeripheral : CBPeripheral

@property (nonatomic, assign) BOOL discoverServicesCalled;
@property (nonatomic, assign) BOOL discoverCharacteristicsCalled;
@property (nonatomic, assign) BOOL setNotifyValueCalled;

@property (nonatomic, assign) BOOL hasCompatibleServices;
@property (nonatomic, assign) BOOL hasCompatibleCharacteristic;
@property (nonatomic, assign) BOOL mockSetNotify;

@property (nonatomic, strong) NSArray<CBService*> *mockedServices;

+(FakeCBPeripheral*)peripheralWithIdentifier:(NSUUID*)identifier;

-(void)reset;

@end

NS_ASSUME_NONNULL_END
