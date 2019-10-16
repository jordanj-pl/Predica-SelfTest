//
//  Measurement+CoreDataProperties.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 16/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//
//

#import "Measurement+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Measurement (CoreDataProperties)

+ (NSFetchRequest<Measurement *> *)fetchRequest;

@property (nonatomic) int32_t diastolic;
@property (nonatomic) int32_t systolic;
@property (nullable, nonatomic, copy) NSDate *time;
@property (nullable, nonatomic, copy) NSString *unit;

@end

NS_ASSUME_NONNULL_END
