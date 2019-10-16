//
//  ViewController.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import UIKit;

#import "PRDMainViewProtocol.h"
#import "PRDMainEventHandler.h"

#import "PRDMeasurementView.h"
#import "PRDHistoryView.h"

@interface PRDMainView : UIViewController<PRDMainView>

@property (nonatomic, weak) IBOutlet PRDMeasurementView *measurementView;
@property (nonatomic, weak) IBOutlet PRDHistoryView *historyView;

@property (nonatomic, strong) id<PRDMainEventHandler> eventHandler;

@end

