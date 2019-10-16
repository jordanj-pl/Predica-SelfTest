//
//  PRDDatabaseManager.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

@class NSFetchedResultsController;
@class Measurement;

NS_ASSUME_NONNULL_BEGIN

@interface PRDDatabaseManager : NSObject

-(void)loadDatabase;
-(BOOL)isMigrationNeeded;
-(void)migrateDatabaseWithCompletion:(void(^)(BOOL))completionHandler progressHandler:(void(^)(float progress))progressHanlder;

-(void)saveToPersistentStore;
-(void)saveToPersistentStoreAsync;

-(NSFetchedResultsController*)allMeasurements;
-(Measurement*)insertNewMeasurementWithSystolic:(int)systolic diastiolic:(int)diastolic unit:(NSString*)unit time:(NSDate*)time;

@end

NS_ASSUME_NONNULL_END
