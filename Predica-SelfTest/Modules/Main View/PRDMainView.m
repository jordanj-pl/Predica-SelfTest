//
//  ViewController.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDMainView.h"

@interface PRDMainView ()

@end

@implementation PRDMainView

- (void)viewDidLoad {
	[super viewDidLoad];

	self.navigationController.navigationBarHidden = YES;

	[self.eventHandler setupSubviews];
}


@end
