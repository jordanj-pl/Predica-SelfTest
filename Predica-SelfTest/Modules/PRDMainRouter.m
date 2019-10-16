//
//  PRDMainRouter.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 14/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDMainRouter.h"

#import "PRDMainView.h"
#import "PRDMainPresenter.h"

@interface PRDMainRouter ()

@end

@implementation PRDMainRouter

@synthesize dbManager = _dbManager;

-(void)startApp {
	[self.dbManager loadDatabase];

	[self startMainFlow];
}

-(void)startMainFlow {

	UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
	PRDMainView *mainView = [sb instantiateInitialViewController];

	PRDMainPresenter *presenter = [PRDMainPresenter new];
	presenter.view = mainView;
	presenter.mainRouter = self;

	mainView.eventHandler = presenter;

	UIApplication *app = [UIApplication sharedApplication];
	UINavigationController *nc = (UINavigationController*)app.keyWindow.rootViewController;

	[nc setViewControllers:@[mainView] animated:YES];
}

#pragma mark - Core Data

-(PRDDatabaseManager*)dbManager {
    if(!_dbManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _dbManager = [PRDDatabaseManager new];
        });
    }

    return _dbManager;
}


@end
