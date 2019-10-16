//
//  PRDHistoryProvider.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDHistoryProvider_h
#define PRDHistoryProvider_h

@class NSFetchedResultsController;
@class NSManagedObject;

@protocol PRDHistoryProvider <NSObject>

-(void)provideMeasurements;
-(void)updateMeasurements:(NSFetchedResultsController*)frc withCompletion:(void(^)(BOOL success))completion;
-(void)removeMeasurement:(NSManagedObject*)measurement resultController:(NSFetchedResultsController*)frc withCompletion:(void(^)(BOOL success))completion;

@end

#endif /* PRDHistoryProvider_h */
