//
//  PRDHistoryPresenter.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDHistoryPresenter.h"

#import "PRDConstants.h"

@import CoreData;
@import UIKit;

@interface PRDHistoryPresenter ()

@property (nonatomic, strong) NSFetchedResultsController *frc;

@end

@implementation PRDHistoryPresenter

-(instancetype)init {
	self = [super init];
	if(self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMeasurements) name:kPRDNewMeasurementNotificationName object:nil];
	}
	return self;
}

-(void)updateMeasurements {
	__weak typeof(self) weakSelf = self;
	[self.provider updateMeasurements:self.frc withCompletion:^(BOOL success) {
		typeof(self) strongSelf = weakSelf;
		if(success) {
			//TODO it is based on assumption that newly added row is always at the top. It may cause some troubles when adding past measurements e.g. stored in device's memory. Needs to be refactored.
			[strongSelf.view insertItemAtPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		} else {
			//TODO handle error
		}
	}];
}

#pragma mark Event Handler

-(void)showMeasurements {
	[self.provider provideMeasurements];
}

-(void)deleteRow:(NSIndexPath *)row {
	__weak typeof(self) weakSelf = self;

	NSManagedObject *obj = [self.frc objectAtIndexPath:row];
	[self.provider removeMeasurement:obj resultController:self.frc withCompletion:^(BOOL success) {
		typeof(self) strongSelf = weakSelf;
		if(success) {
			[strongSelf.view deleteItemAtPath:row];
		}
	}];
}
#pragma mark Output

-(void)receiveError:(NSString *)error {
	//TODO
}

-(void)receiveMeasurements:(NSFetchedResultsController *)measurements {
	self.frc = measurements;

	[self.view setFetchedResultsController:measurements];
}


@end
