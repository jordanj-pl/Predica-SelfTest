//
//  PRDHistoryMeasurementTableViewCell.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface PRDHistoryMeasurementTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *measurementLabel;
@property (nonatomic, weak) IBOutlet UILabel *unitLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
