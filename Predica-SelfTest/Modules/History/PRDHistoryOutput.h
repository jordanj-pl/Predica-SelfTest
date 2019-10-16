//
//  PRDHistoryOutput.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDHistoryOutput_h
#define PRDHistoryOutput_h

@class NSFetchedResultsController;

@protocol PRDHistoryOutput <NSObject>

-(void)receiveMeasurements:(NSFetchedResultsController*)measurements;
-(void)receiveError:(NSString*)error;

@end

#endif /* PRDHistoryOutput_h */
