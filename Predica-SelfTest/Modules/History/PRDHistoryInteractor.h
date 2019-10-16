//
//  PRDHistoryInteractor.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDHistoryProvider.h"
#import "PRDHistoryOutput.h"

@class PRDDatabaseManager;

NS_ASSUME_NONNULL_BEGIN

@interface PRDHistoryInteractor : NSObject<PRDHistoryProvider>

@property (nonatomic, weak) id<PRDHistoryOutput> output;

@property (nonatomic, strong) PRDDatabaseManager *dbManager;

@end

NS_ASSUME_NONNULL_END
