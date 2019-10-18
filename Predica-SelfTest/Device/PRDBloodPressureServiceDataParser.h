//
//  PRDBloodPressureServiceDataParser.h
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 18/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface PRDBloodPressureServiceDataParser : NSObject

@property (nonatomic, assign, readonly) NSData *rawData;

@property (nonatomic, assign, readonly, getter=isDataValid) BOOL dataValid;
@property (nonatomic, copy, readonly) NSString *unit;
@property (nonatomic, assign, readonly) double systolic;
@property (nonatomic, assign, readonly) double diastolic;
@property (nonatomic, assign, readonly) NSTimeInterval timestamp;

-(instancetype)initWithData:(NSData*)data NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
