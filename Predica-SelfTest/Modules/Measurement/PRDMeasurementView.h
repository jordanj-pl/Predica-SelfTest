//
//  MeasurementView.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import UIKit;

#import "PRDMeasurementViewProtocol.h"
#import "PRDMeasurementEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

IB_DESIGNABLE
@interface PRDMeasurementView : UIView<PRDMeasurementView>

@property (nonatomic, strong) id<PRDMeasurementEventHandler> eventHandler;

@end

NS_ASSUME_NONNULL_END
