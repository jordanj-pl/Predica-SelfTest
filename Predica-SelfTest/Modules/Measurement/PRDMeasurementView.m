//
//  MeasurementView.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 13/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDMeasurementView.h"

@interface PRDMeasurementView ()

@property (nonatomic, weak) IBOutlet UILabel *deviceStatusLabel;
@property (nonatomic, weak) IBOutlet UILabel *deviceNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *systolicLabel;
@property (nonatomic, weak) IBOutlet UILabel *diastolicLabel;
@property (nonatomic, weak) IBOutlet UILabel *datetimeLabel;
@property (nonatomic, weak) IBOutlet UIButton *updateButton;
@property (nonatomic, strong) IBOutletCollection(UILabel) NSArray *pressureUnitLabels;

@end

@implementation PRDMeasurementView

-(instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if(!self) {
		return nil;
	}

	return self;
}

-(void)awakeFromNib {
	[super awakeFromNib];

	self.deviceStatusLabel.text = @"______";
	self.deviceNameLabel.text = @"";
	self.systolicLabel.text = @"__";
	self.diastolicLabel.text = @"__";
	self.datetimeLabel.text = @"------";

	[self.updateButton addTarget:self action:@selector(updateMeasurement:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)updateMeasurement:(UIButton*)button {
	[self.eventHandler updateMeasurement];
}

-(void)setDeviceStatus:(NSString *)status {
	self.deviceStatusLabel.text = status;
}

-(void)setDeviceName:(NSString *)name {
	self.deviceNameLabel.text = name;
}

-(void)setTime:(NSString *)time {
	self.datetimeLabel.text = time;
}

-(void)setSystolic:(NSString *)systolic {
	self.systolicLabel.text = systolic;
}

-(void)setDiastolic:(NSString *)diastolic {
	self.diastolicLabel.text = diastolic;
}

-(void)setPressureUnit:(NSString *)pressureUnit {
	for (UILabel *unitLabel in self.pressureUnitLabels) {
		unitLabel.text = pressureUnit;
	}
}

-(void)setUpdateButtonEnabled:(BOOL)enabled {
	self.updateButton.enabled = enabled;
}

@end
