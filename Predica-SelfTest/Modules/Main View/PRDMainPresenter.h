//
//  PRDMainPresenter.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 14/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDMainViewProtocol.h"
#import "PRDMainEventHandler.h"

#import "PRDMainRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRDMainPresenter : NSObject<PRDMainEventHandler>

@property (nonatomic, weak) id<PRDMainView> view;

@property (nonatomic, weak) PRDMainRouter *mainRouter;

@end

NS_ASSUME_NONNULL_END
