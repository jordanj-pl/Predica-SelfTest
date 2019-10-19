//
//  FakeCBCentralManager.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "FakeCBCentralManager.h"

@implementation FakeCBCentralManager

-(instancetype)initWithDelegate:(id<CBCentralManagerDelegate>)delegate queue:(dispatch_queue_t)queue options:(NSDictionary<NSString *,id> *)options {
	self = [super initWithDelegate:delegate queue:queue options:options];
	_connectPeripheralCalled = NO;
	return self;
}

-(void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options {

	self.connectPeripheralCalled = YES;

	[self.delegate centralManager:self didConnectPeripheral:peripheral];
}

-(NSArray<CBPeripheral*>*)retrievePeripheralsWithIdentifiers:(NSArray<NSUUID *> *)identifiers {

	return self.fakePeripherals;
}

@end
