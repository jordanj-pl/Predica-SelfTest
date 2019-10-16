//
//  Measurement+CoreDataProperties.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//
//

#import "Measurement+CoreDataProperties.h"

@implementation Measurement (CoreDataProperties)

+ (NSFetchRequest<Measurement *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Measurement"];
}

@dynamic diastolic;
@dynamic systolic;
@dynamic time;
@dynamic unit;

@end
