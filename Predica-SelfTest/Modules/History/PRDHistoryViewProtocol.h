//
//  PRDHistoryViewProtocol.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDHistoryViewProtocol_h
#define PRDHistoryViewProtocol_h

@class NSFetchedResultsController;

@protocol PRDHistoryView <NSObject>

//This does not conform to VIPER but ensures CoreData built-in efficiency by using NSFetchedResultsController.
-(void)setFetchedResultsController:(NSFetchedResultsController*)frc;
-(void)insertItemAtPath:(NSIndexPath*)indexPath;
-(void)deleteItemAtPath:(NSIndexPath*)indexPath;

@end

#endif /* PRDHistoryViewProtocol_h */
