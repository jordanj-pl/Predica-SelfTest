//
//  PRDHistoryEventHandler.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#ifndef PRDHistoryEventHandler_h
#define PRDHistoryEventHandler_h

@protocol PRDHistoryEventHandler <NSObject>

-(void)showMeasurements;
-(void)deleteRow:(NSIndexPath*)row;

@end

#endif /* PRDHistoryEventHandler_h */
