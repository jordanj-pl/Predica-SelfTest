//
//  PRDDeviceManager.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDDeviceManager.h"

@import CoreBluetooth;

#import "PRDBloodPressureServiceDataParser.h"

NSString *kBloodPressureService = @"0x1810";
NSString *kBloodPressureServiceCharacteristic = @"0x2A35";
const char *kPRDDeviceManagerCentralQueue = "PRDDeviceManagerCentralQueue";
NSErrorDomain const PRDDeviceErrorDomain = (NSErrorDomain)@"BLE Error";

@interface PRDDeviceManager ()<CBCentralManagerDelegate, CBPeripheralDelegate> {
	dispatch_queue_t _centralQueue;
}

@property (nonatomic, strong) CBCentralManager *central;
@property (nonatomic, strong) CBPeripheral *currentPeripheral;
@property (nonatomic, assign) PRDDeviceManagerDeviceState state;

@end

@implementation PRDDeviceManager

-(instancetype)init {
	self = [super init];
	if(!self) {
		return nil;
	}

	_centralQueue = dispatch_queue_create(kPRDDeviceManagerCentralQueue, NULL);

	_central = [[CBCentralManager alloc] initWithDelegate:self queue:_centralQueue options:@{
		CBCentralManagerOptionShowPowerAlertKey: @(YES)
		//CBCentralManagerOptionRestoreIdentifierKey: @""
		//TODO consider central manager restoration if time permits. It should speed up app initiation.
	}];

	return self;
}

-(void)setState:(PRDDeviceManagerDeviceState)state {
	_state = state;
	[self.delegate didUpdateDeviceState:_state];
}

-(void)scanForCompatibleDevices {
	[self.central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:kBloodPressureService]] options:nil];

	self.state = PRDDeviceManagerDeviceStateFinding;
}

-(void)stopScanning {
	[self.central stopScan];

	self.state = PRDDeviceManagerDeviceStateBLEOn;
}

-(void)connectDevice:(NSUUID *)deviceUUID {
	self.state = PRDDeviceManagerDeviceStateConnecting;

	NSArray *peripherals = [self.central retrievePeripheralsWithIdentifiers:@[deviceUUID]];
	if(peripherals.count != 1) {
		self.state = PRDDeviceManagerDeviceStateDisconnected;
		return;
	}

	self.currentPeripheral = peripherals.firstObject;
	self.currentPeripheral.delegate = self;

	[self.central connectPeripheral:self.currentPeripheral options:nil];
}

-(void)requestMeasurement {
	if(!self.currentPeripheral) {
		//TODO specify error
		[self.delegate didEncounterError:[NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil]];
		return;
	}

	NSArray *services = [self.currentPeripheral.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureService]]];

	if(services.count != 1) {
		//TODO specify error
		[self.delegate didEncounterError:[NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil]];
		return;
	}

	CBService *service = services.firstObject;
	NSArray *characteristics = [service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]]];

	if(characteristics.count != 1) {
		//TODO specify error
		[self.delegate didEncounterError:[NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil]];
		return;
	}

	CBCharacteristic *bloodPressure = characteristics.firstObject;
	[self.currentPeripheral readValueForCharacteristic:bloodPressure];
}

-(void)processMeasurement:(NSData*)data {
	PRDBloodPressureServiceDataParser *parser = [[PRDBloodPressureServiceDataParser alloc] initWithData:data];

	PRDDeviceBloodPressureMeasurement measurement;
	measurement.readingValid = parser.isDataValid;
	measurement.unit = parser.unit;
	measurement.systolic = parser.systolic;
	measurement.diastolic = parser.diastolic;
	measurement.timestamp = parser.timestamp;

	[self.delegate didCompleteBloodPressureMeasurement:measurement];
}

#pragma mark - Central Manager Delegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
	//it prevents updates from fake central managers
	if(![central isMemberOfClass:[CBCentralManager class]]) {
		return;
	}

	switch (central.state) {
		case CBManagerStatePoweredOn:
			self.state = PRDDeviceManagerDeviceStateBLEOn;
			break;

		case CBManagerStateUnauthorized:
			self.state = PRDDeviceManagerDeviceStateBLEUnauthorised;
			break;

		default:
			self.state = PRDDeviceManagerDeviceStateBLEOff;
			break;
	}

}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI {

	PRDDeviceManagerDevice device;
	device.name = peripheral.name;
	device.uuid = peripheral.identifier;

	[self.delegate didFindDevice:device];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	[self.currentPeripheral discoverServices:@[[CBUUID UUIDWithString:kBloodPressureService]]];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	self.state = PRDDeviceManagerDeviceStateDisconnected;
}

#pragma mark - CBPeripheralDelegate

-(void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
	NSLog(@"didModifyServices: %@", invalidatedServices);
	//TODO reload services and check compatibility after change
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	NSArray *services = [peripheral.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureService]]];

	if(services.count == 1 && !error) {
		[peripheral discoverCharacteristics:nil forService:peripheral.services.firstObject];
	} else {
		self.state = PRDDeviceManagerDeviceStateDisconnected;
		//TODO add error description
		NSError *error = [NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil];
		[self.delegate didEncounterError:error];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {

	NSArray *characteristics = [service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]]];

	if(characteristics.count == 1 && !error) {
		CBCharacteristic *bloodPressure = characteristics.firstObject;
		[peripheral setNotifyValue:YES forCharacteristic:bloodPressure];
	} else {
		self.state = PRDDeviceManagerDeviceStateDisconnected;
		//TODO add error description
		NSError *error = [NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil];
		[self.delegate didEncounterError:error];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {

	if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]] && characteristic.isNotifying  && !error) {
		//Connected is set when device is ready to process read requests.
		self.state = PRDDeviceManagerDeviceStateConnected;
	} else {
		self.state = PRDDeviceManagerDeviceStateDisconnected;
		//TODO add error description
		NSError *error = [NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil];
		[self.delegate didEncounterError:error];
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

	if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]] && !error) {
		[self processMeasurement:characteristic.value];
	} else if(error) {
		//TODO add error description
		NSError *error = [NSError errorWithDomain:PRDDeviceErrorDomain code:0 userInfo:nil];
		[self.delegate didEncounterError:error];
	}
}

@end
