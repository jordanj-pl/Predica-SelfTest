//
//  PRDBloodPressureServiceDataParser.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 18/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDBloodPressureServiceDataParser.h"

#import "PRDHelpers.h"

@implementation PRDBloodPressureServiceDataParser

-(instancetype)initWithData:(NSData *)data {
	self = [super init];
	if(self) {
		_rawData = data;
		[self parseMeasurementData:_rawData];
	}
	return self;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
-(instancetype)init {
	@throw [NSException exceptionWithName:@"Designated initializer required" reason:@"Use initWithData: instead. data is required." userInfo:nil];
	return nil;
}
#pragma clang diagnostic pop

-(void)parseMeasurementData:(NSData*)data {
	NSLog(@"DATA: %@", data);
	uint8_t pressurekPa = 1 << 7;
	uint8_t timestampPresent = 1 << 6;

	_dataValid = YES;

	uint8_t flags = 0x00;
	uint16_t systolic = 0x0000;
	uint16_t diastolic = 0x0000;

	@try {
		[data getBytes:&flags range:NSMakeRange(0, 1)];

		[data getBytes:&systolic range:NSMakeRange(1, 2)];
		systolic = CFSwapInt16BigToHost(systolic);

		[data getBytes:&diastolic range:NSMakeRange(3, 2)];
		diastolic = CFSwapInt16BigToHost(diastolic);
	} @catch (NSException *exception) {
		_dataValid = NO;
		return;
	}

	if(flags & pressurekPa) {
		_unit = @"kPa";
	} else {
		_unit = @"mmHg";
	}

	_systolic = [PRDHelpers sfloatToDouble:systolic];
	_diastolic = [PRDHelpers sfloatToDouble:diastolic];

	if(flags & timestampPresent) {
		NSData *timeData;
		@try {
			timeData = [data subdataWithRange:NSMakeRange(5, 7)];
		} @catch (NSException *exception) {
			_dataValid = NO;
			return;
		}

		_timestamp = [self parseTime:timeData];
	}
}

-(NSTimeInterval)parseTime:(NSData*)data {

	if(data.length != 7) {
		return 0;
	}

	uint16_t year;
	uint8_t month;
	uint8_t day;
	uint8_t hour;
	uint8_t minute;
	uint8_t second;

	[data getBytes:&year range:NSMakeRange(5, 2)];
	year = CFSwapInt16BigToHost(year);

	[data getBytes:&month range:NSMakeRange(4, 1)];
	[data getBytes:&day range:NSMakeRange(3, 1)];
	[data getBytes:&hour range:NSMakeRange(2, 1)];
	[data getBytes:&minute range:NSMakeRange(1, 1)];
	[data getBytes:&second range:NSMakeRange(0, 1)];

	NSDateComponents *date = [NSDateComponents new];
	date.year = (NSInteger)year;
	date.month = (NSInteger)month;
	date.day = (NSInteger)day;
	date.hour = (NSInteger)hour;
	date.minute = (NSInteger)minute;
	date.second = (NSInteger)second;

	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

	return [[calendar dateFromComponents:date] timeIntervalSince1970];
}

@end
