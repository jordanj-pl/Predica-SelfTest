//
//  PRDDatabaseManager.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDDatabaseManager.h"

#import "PRDCoreDataHelper.h"

#import "Measurement+CoreDataProperties.h"

@interface PRDDatabaseManager ()

@property (nonatomic, strong, readonly) PRDCoreDataHelper *cdh;

@end

@implementation PRDDatabaseManager

-(instancetype)init {
	self = [super init];
	if(self) {
		_cdh = [[PRDCoreDataHelper alloc] initWithStoreURL:self.storeURL];
	}
	return self;
}

-(void)loadDatabase {
	[self.cdh loadDatabase];
}

-(BOOL)isMigrationNeeded {
	return [self.cdh isMigrationNecessary];
}

-(void)migrateDatabaseWithCompletion:(void (^)(BOOL))completionHandler progressHandler:(void (^)(float))progressHanlder {

	[self.cdh migrateStoreWithCompletion:completionHandler progressHandler:progressHanlder];
}

#pragma mark - CRUD

#pragma mark INSERT

-(Measurement*)insertNewMeasurementWithSystolic:(int)systolic diastiolic:(int)diastolic unit:(NSString *)unit time:(NSDate *)time {
	__block Measurement *insertedObject;

	[self.cdh.context performBlockAndWait:^{
		insertedObject = (Measurement*)[NSEntityDescription insertNewObjectForEntityForName:@"Measurement" inManagedObjectContext:self.cdh.context];

		insertedObject.systolic = systolic;
		insertedObject.diastolic = diastolic;
		insertedObject.unit = unit;
		insertedObject.time = time;
	}];

	[self saveContext:self.cdh.context];

	return insertedObject;
}

#pragma mark SELECT

-(NSFetchedResultsController*)allMeasurements {
	NSFetchRequest *request = [self.cdh.model fetchRequestTemplateForName:@"AllMeasurements"].copy;
	request.sortDescriptors = [NSArray arrayWithObjects:
	                               [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO],nil];

	return [[NSFetchedResultsController alloc] initWithFetchRequest:request
	                                        managedObjectContext:self.cdh.context
	                                          sectionNameKeyPath:nil
	                                                   cacheName:nil];
}

#pragma mark - saving

-(void)saveContext:(NSManagedObjectContext*)context {
    [context performBlockAndWait:^{
        if(context.hasChanges) {
            NSError *error = nil;

            if([context save:&error]) {
                NSLog(@"EMKDatabaseManager SAVED changes from import context to parent context");
            } else {
                NSLog(@"EMKDatabaseManager FAILED to save changes from import context to parent context: %@", error);
            }
        } else {
            NSLog(@"EMKDatabaseManager SKIPPED saving context as there are no changes");
        }
    }];
}

-(void)saveToPersistentStore {
	[self.cdh saveParentContext];
}

-(void)saveToPersistentStoreAsync {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		[self.cdh saveParentContext];
	});
}

#pragma mark - Create DB file path

NSString *dbFilename = @"Measurements.sqlite";

-(NSString*)applicationDocumentsDirectory {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

-(NSURL*)applicationStoresDirectory {
    NSURL *storesDirectory = [[NSURL fileURLWithPath:[self applicationDocumentsDirectory]] URLByAppendingPathComponent:@"Stores"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[storesDirectory path]]) {
        NSError *error = nil;

        if([fileManager createDirectoryAtURL:storesDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
        } else {
			NSLog(@"FAILED to create Stores directory: %@", error);
		}
    }

    return storesDirectory;
}

-(NSURL*)storeURL {
    return [[self applicationStoresDirectory] URLByAppendingPathComponent:dbFilename];
}

@end
