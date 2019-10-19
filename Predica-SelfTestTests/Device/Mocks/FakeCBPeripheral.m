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
@property (nonatomic, strong) NSArray<CBService*> *mockedServices;

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

-(void)discoverServices:(NSArray<CBUUID *> *)serviceUUIDs {
	self.discoverServicesCalled = YES;

	FakeCBService *service = [FakeCBService serviceWithIdentifier:serviceUUIDs.firstObject];
	self.mockedServices = @[service];

	[self.delegate peripheral:self didDiscoverServices:nil];
}

-(NSArray<CBService*>*)services {
	return self.mockedServices;
}

-(void)discoverCharacteristics:(NSArray<CBUUID *> *)characteristicUUIDs forService:(FakeCBService *)service {
	self.discoverCharacteristicsCalled = YES;

	FakeCBCharacteristic *characteristic = [FakeCBCharacteristic characteristicWithIdentifier:[CBUUID UUIDWithString:@"0x2A35"]];

	service.mockedCharacteristics = @[characteristic];

	[self.delegate peripheral:self didDiscoverCharacteristicsForService:service error:nil];
}

-(void)setNotifyValue:(BOOL)enabled forCharacteristic:(CBCharacteristic *)characteristic {
	self.setNotifyValueCalled = YES;
}

@end
