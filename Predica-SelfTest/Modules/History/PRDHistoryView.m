//
//  PRDHistoryView.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDHistoryView.h"

@import CoreData;

#import "Measurement+CoreDataProperties.h"
#import "PRDHistoryMeasurementTableViewCell.h"

@interface PRDHistoryView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *frc;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation PRDHistoryView

-(instancetype)initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	if(self) {
		_dateFormatter = [NSDateFormatter new];
		[_dateFormatter setDateFormat:@"HH:mm\nd MMM yyy"];
	}
	return self;
}

-(void)awakeFromNib {
	[super awakeFromNib];
}

-(void)setFetchedResultsController:(NSFetchedResultsController*)frc {
	_frc = frc;

	[self.frc.managedObjectContext performBlockAndWait:^{
		[self.tableView reloadData];
	}];

}

-(void)insertItemAtPath:(NSIndexPath*)indexPath {
	[self.frc.managedObjectContext performBlockAndWait:^{
		[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}];
}

-(void)deleteItemAtPath:(NSIndexPath*)indexPath {
	[self.frc.managedObjectContext performBlockAndWait:^{
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	}];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.frc.sections[0].numberOfObjects;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	PRDHistoryMeasurementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeasurementCell" forIndexPath:indexPath];

	Measurement *measurement = [self.frc objectAtIndexPath:indexPath];

	cell.measurementLabel.text = [NSString stringWithFormat:@"%d - %d", measurement.systolic, measurement.diastolic];
	cell.unitLabel.text = measurement.unit;
	cell.timeLabel.text = [self.dateFormatter stringFromDate:measurement.time];

	return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
		NSLog(@"::>> DELETE editing: %@", indexPath);
		[self.eventHandler deleteRow:indexPath];
    }
}

@end
