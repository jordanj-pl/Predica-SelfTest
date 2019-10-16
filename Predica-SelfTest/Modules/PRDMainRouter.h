//
//  PRDMainRouter.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 14/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDDatabaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRDMainRouter : NSObject

@property (nonatomic, strong, readonly) PRDDatabaseManager *dbManager;

-(void)startApp;

@end

NS_ASSUME_NONNULL_END
