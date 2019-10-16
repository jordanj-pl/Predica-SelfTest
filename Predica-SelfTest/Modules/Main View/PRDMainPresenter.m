//
//  PRDMainPresenter.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 14/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDMainPresenter.h"

#import "PRDMainView.h"

#import "PRDMeasurementView.h"
#import "PRDMeasurementPresenter.h"
#import "PRDMeasurementInteractor.h"

#import "PRDHistoryView.h"
#import "PRDHistoryPresenter.h"
#import "PRDHistoryInteractor.h"

@implementation PRDMainPresenter

-(void)setupSubviews {
	//Setup measurement view
	PRDMeasurementPresenter *measurementPresenter = [PRDMeasurementPresenter new];
	measurementPresenter.view = ((PRDMainView*)self.view).measurementView;
	((PRDMainView*)self.view).measurementView.eventHandler = measurementPresenter;

	PRDMeasurementInteractor *measurementInteractor = [PRDMeasurementInteractor new];
	measurementInteractor.output = measurementPresenter;
	measurementInteractor.dbManager = self.mainRouter.dbManager;

	measurementPresenter.provider = measurementInteractor;

	//Setup history view
	PRDHistoryPresenter *historyPresenter = [PRDHistoryPresenter new];
	historyPresenter.view = ((PRDMainView*)self.view).historyView;
	((PRDMainView*)self.view).historyView.eventHandler = historyPresenter;

	PRDHistoryInteractor *historyInteractor = [PRDHistoryInteractor new];
	historyInteractor.output = historyPresenter;
	historyInteractor.dbManager = self.mainRouter.dbManager;

	historyPresenter.provider = historyInteractor;

	//Automatically look for compatible device
	[measurementPresenter connectWithFirstCompatibleDevice];
	[historyPresenter showMeasurements];

}

@end
