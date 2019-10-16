//
//  PRDMeasurementInteractor.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDMeasurementProvider.h"
#import "PRDMeasurementOutput.h"

@class PRDDatabaseManager;

NS_ASSUME_NONNULL_BEGIN

@interface PRDMeasurementInteractor : NSObject<PRDMeasurementProvider>

@property (nonatomic, strong) PRDDatabaseManager *dbManager;

@property (nonatomic, weak) id<PRDMeasurementOutput> output;

@end

NS_ASSUME_NONNULL_END
