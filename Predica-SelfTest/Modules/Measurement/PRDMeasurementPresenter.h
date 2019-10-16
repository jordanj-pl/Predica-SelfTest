//
//  PRDMeasurementPresenter.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDMeasurementEventHandler.h"
#import "PRDMeasurementViewProtocol.h"
#import "PRDMeasurementProvider.h"
#import "PRDMeasurementOutput.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRDMeasurementPresenter : NSObject<PRDMeasurementEventHandler, PRDMeasurementOutput>

@property (nonatomic, weak) id<PRDMeasurementView> view;
@property (nonatomic, strong) id<PRDMeasurementProvider> provider;

@end

NS_ASSUME_NONNULL_END
