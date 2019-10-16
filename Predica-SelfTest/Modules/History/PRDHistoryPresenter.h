//
//  PRDHistoryPresenter.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

#import "PRDHistoryViewProtocol.h"
#import "PRDHistoryEventHandler.h"
#import "PRDHistoryOutput.h"
#import "PRDHistoryProvider.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRDHistoryPresenter : NSObject<PRDHistoryEventHandler, PRDHistoryOutput>

@property (nonatomic, weak) id<PRDHistoryView> view;
@property (nonatomic, strong) id<PRDHistoryProvider> provider;

@end

NS_ASSUME_NONNULL_END
