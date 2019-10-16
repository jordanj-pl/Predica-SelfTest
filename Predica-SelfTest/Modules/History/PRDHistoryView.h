//
//  PRDHistoryView.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import UIKit;

#import "PRDHistoryViewProtocol.h"
#import "PRDHistoryEventHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface PRDHistoryView : UIView<PRDHistoryView>

@property (nonatomic, strong) id<PRDHistoryEventHandler> eventHandler;

@end

NS_ASSUME_NONNULL_END
