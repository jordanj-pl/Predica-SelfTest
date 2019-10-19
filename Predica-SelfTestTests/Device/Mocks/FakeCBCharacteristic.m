//
//  FakeCBCharacteristic.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "FakeCBCharacteristic.h"

@interface FakeCBCharacteristic ()

@property (nonatomic, strong) CBUUID *mockedUUID;

@end

@implementation FakeCBCharacteristic

+(FakeCBCharacteristic*)characteristicWithIdentifier:(CBUUID *)identifier {
	FakeCBCharacteristic *characteristic = [FakeCBCharacteristic new];
	characteristic.mockedUUID = identifier;
	return characteristic;
}

-(CBUUID*)UUID {
	return self.mockedUUID;
}

@end
