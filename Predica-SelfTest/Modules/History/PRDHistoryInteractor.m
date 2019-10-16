//
//  PRDHistoryInteractor.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDHistoryInteractor.h"

#import "PRDDatabaseManager.h"
@import CoreData;

@implementation PRDHistoryInteractor

- (void)provideMeasurements {
	NSFetchedResultsController *frc = self.dbManager.allMeasurements;

	[frc.managedObjectContext performBlockAndWait:^{
		NSError *error = nil;
		if(![frc performFetch:&error]) {
			NSLog(@"FAILED to perform fetch: %@", error);
			[self.output receiveError:@"Data unavailable"];
		} else {
			[self.output receiveMeasurements:frc];
		}
	}];

}

-(void)updateMeasurements:(NSFetchedResultsController *)frc withCompletion:(void (^)(BOOL))completion {
	[frc.managedObjectContext performBlockAndWait:^{
		NSError *error = nil;
		if(![frc performFetch:&error]) {
			completion(NO);
		} else {
			completion(YES);
		}
	}];
}

-(void)removeMeasurement:(NSManagedObject *)measurement resultController:(NSFetchedResultsController *)frc withCompletion:(void (^)(BOOL))completion{

	[frc.managedObjectContext performBlockAndWait:^{
		[frc.managedObjectContext deleteObject:measurement];

		NSError *error = nil;
		if(![frc performFetch:&error]) {
			completion(NO);
		} else {
			completion(YES);
		}

	}];

	[self.dbManager saveToPersistentStoreAsync];
}

@end
