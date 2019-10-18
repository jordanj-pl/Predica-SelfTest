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
		//TODO consider error handling
		return;
	}

	NSArray *services = [self.currentPeripheral.services filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureService]]];

	if(services.count != 1) {
		//TODO add error handling
		return;
	}

	CBService *service = services.firstObject;
	NSArray *characteristics = [service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]]];

	if(characteristics.count != 1) {
		//TODO add error handling
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
	NSLog(@"::>> didUpdateState: %lu", central.state);

	if(central.state == CBManagerStatePoweredOn) {
		self.state = PRDDeviceManagerDeviceStateBLEOn;
	} else {
		self.state = PRDDeviceManagerDeviceStateBLEOff;
	}
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(nonnull CBPeripheral *)peripheral advertisementData:(nonnull NSDictionary<NSString *,id> *)advertisementData RSSI:(nonnull NSNumber *)RSSI {

	NSLog(@"::>> peripheral: %@", peripheral);

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
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	NSLog(@"didDiscoverServices: %@", peripheral.services);

	[peripheral discoverCharacteristics:nil forService:peripheral.services.firstObject];
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {

	NSLog(@"didDiscoverCharacteristicsForService: %@", service.characteristics);

	NSArray *characteristics = [service.characteristics filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"UUID = %@", [CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]]];

	if(characteristics.count == 1) {
		CBCharacteristic *bloodPressure = characteristics.firstObject;
		[peripheral setNotifyValue:YES forCharacteristic:bloodPressure];

		//Connected is set when device is ready to process read requests.
		self.state = PRDDeviceManagerDeviceStateConnected;
	}
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {

	if([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBloodPressureServiceCharacteristic]]) {
		[self processMeasurement:characteristic.value];
	}
}

@end
