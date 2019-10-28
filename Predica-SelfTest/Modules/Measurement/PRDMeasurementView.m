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

@property (nonatomic, weak) IBOutlet UIView *errorView;

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
	self.updateButton.backgroundColor = enabled ? [UIColor systemBlueColor] : [UIColor grayColor];
}

-(void)showError:(NSString *)title message:(NSString *)msg {

	UILabel *titleLabel = [self.errorView viewWithTag:990001];
	UILabel *msgLabel = [self.errorView viewWithTag:990002];
	titleLabel.text = title;
	msgLabel.text = msg;

	[UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		self.errorView.alpha = 1.0;
		[self layoutIfNeeded];
	} completion: ^(bool completed) {
		if(completed) {
			[UIView animateWithDuration:0.8 delay:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
					self.errorView.alpha = 0.0;
					[self layoutIfNeeded];
			} completion:^(bool completed) {
				if(completed) {
					[self.eventHandler didHideError];
				}
			}];
		}
	}];

}

@end
