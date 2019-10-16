//
//  PRDDeviceManagerTests.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 15/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import XCTest;

#import "PRDDeviceManager.h"

@interface PRDDeviceManager ()

-(NSTimeInterval)parseTime:(NSData*)data;
-(PRDDeviceBloodPressureMeasurement)parseMeasurementData:(NSData*)data;

@end

@interface PRDDeviceManagerTests : XCTestCase

@end

@implementation PRDDeviceManagerTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testParseDate {
    //Given
    NSMutableData *data = [NSMutableData data];

    uint8_t seconds = 52;
    [data appendBytes:&seconds length:1];

    uint8_t minutes = 45;
    [data appendBytes:&minutes length:1];

    uint8_t hours = 14;
    [data appendBytes:&hours length:1];

    uint8_t days = 17;
    [data appendBytes:&days length:1];

    uint8_t months = 11;
    [data appendBytes:&months length:1];

    uint16_t years = 2019;
    [data appendBytes:&years length:2];

    //When
	NSTimeInterval timestamp = [[PRDDeviceManager new] parseTime:data];

    //Then
    NSDate *testTime = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *timeComponents = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond) fromDate:testTime];

    XCTAssertEqual((NSInteger)seconds, timeComponents.second);
    XCTAssertEqual((NSInteger)minutes, timeComponents.minute);
    XCTAssertEqual((NSInteger)hours, timeComponents.hour);
    XCTAssertEqual((NSInteger)days, timeComponents.day);
    XCTAssertEqual((NSInteger)months, timeComponents.month);
    XCTAssertEqual((NSInteger)CFSwapInt16BigToHost(years), timeComponents.year);
}

-(void)testParseMeasurement {
	//Given
	NSMutableData *data = [NSMutableData new];

	uint8_t flags = 0x40;//01000000 - unit mmHg, timestamp present
	[data appendBytes:&flags length:1];

	uint32_t pressure = CFSwapInt32HostToBig(0x100c1007);//systolic 120 diastolic 70
	[data appendBytes:&pressure length:4];

	uint64_t timestamp = CFSwapInt64HostToBig(0x342d0e110b07e300);//17.11.2019 14:45:52
	[data appendBytes:&timestamp length:7];

	NSLog(@"DATA: %@", data);

	//When
	PRDDeviceBloodPressureMeasurement measurement = [[PRDDeviceManager new] parseMeasurementData:data];

	//Then
	XCTAssertTrue(measurement.readingValid);
	XCTAssertEqualObjects(measurement.unit, @"mmHg");
	XCTAssertEqual(measurement.systolic, 120);
	XCTAssertEqual(measurement.diastolic, 70);
	XCTAssertEqual(measurement.timestamp, 1573998352);
}

@end
