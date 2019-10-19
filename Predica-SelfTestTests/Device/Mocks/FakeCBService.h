//
//  FakeCBService.h
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import CoreBluetooth;

NS_ASSUME_NONNULL_BEGIN

@interface FakeCBService : CBService

@property (nonatomic, strong) NSArray<CBCharacteristic*> *mockedCharacteristics;

+(FakeCBService*)serviceWithIdentifier:(CBUUID*)identifier;

@end

NS_ASSUME_NONNULL_END
