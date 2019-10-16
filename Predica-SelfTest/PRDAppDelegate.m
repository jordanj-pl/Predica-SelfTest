//
//  AppDelegate.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDAppDelegate.h"

#import "PRDMainRouter.h"

@interface PRDAppDelegate ()

@property (nonatomic, strong, readonly) PRDMainRouter *mainRouter;

@end

@implementation PRDAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.deviceManager = [PRDDeviceManager new];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateInitialViewController]];
	self.window.rootViewController = nc;
	[self.window makeKeyAndVisible];

	_mainRouter = [PRDMainRouter new];
	[self.mainRouter startApp];

	return YES;
}

-(void)applicationDidEnterBackground:(UIApplication *)application {
	[self.mainRouter.dbManager saveToPersistentStoreAsync];
}

-(void)applicationWillTerminate:(UIApplication *)application {
	[self.mainRouter.dbManager saveToPersistentStoreAsync];
}

@end
