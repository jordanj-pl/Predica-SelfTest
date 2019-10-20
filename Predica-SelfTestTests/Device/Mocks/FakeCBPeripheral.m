//
//  FakeCBPeripheral.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "FakeCBPeripheral.h"

#import "FakeCBService.h"
#import "FakeCBCharacteristic.h"
//#import <objc/message.h>

@interface FakeCBPeripheral ()

@property (nonatomic, strong) NSUUID *mockedUUID;

@end

@implementation FakeCBPeripheral

+(FakeCBPeripheral*)peripheralWithIdentifier:(NSUUID *)identifier {
	FakeCBPeripheral *peripheral = [FakeCBPeripheral new];
	peripheral.mockedUUID = identifier;
//	objc_setAssociatedObject(peripheral, "_identifier", identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return peripheral;
}

-(NSUUID*)identifier {
	return self.mockedUUID;
}

-(void)reset {
	self.mockedServices = @[];
	self.hasCompatibleServices = NO;
	self.hasCompatibleCharacteristic = NO;

	self.discoverServicesCalled = NO;
	self.discoverCharacteristicsCalled = NO;
	self.setNotifyValueCalled = NO;
}

-(void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs {
	self.discoverServicesCalled = YES;

	if(self.hasCompatibleServices) {
		FakeCBService *service = [FakeCBService serviceWithIdentifier:serviceUUIDs.firstObject];
		self.mockedServices = @[service];
	} else {
		self.mockedServices = @[];
	}

	[self.delegate peripheral:self didDiscoverServices:nil];
}

-(NSArray<CBService*>*)services {
	return self.mockedServices;
}

-(void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(FakeCBService *)service {
	self.discoverCharacteristicsCalled = YES;

	if(self.hasCompatibleCharacteristic) {
		FakeCBCharacteristic *characteristic = [FakeCBCharacteristic characteristicWithIdentifier:[CBUUID UUIDWithString:@"0x2A35"]];

		service.mockedCharacteristics = @[characteristic];
	} else {
		service.mockedCharacteristics = @[];
	}

	[self.delegate peripheral:self didDiscoverCharacteristicsForService:service error:nil];
}

-(void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic {
	self.setNotifyValueCalled = YES;

	((FakeCBCharacteristic*)characteristic).mockIsNotifying = self.mockSetNotify;

	[self.delegate peripheral:self didUpdateNotificationStateForCharacteristic:characteristic error:nil];
}

@end
