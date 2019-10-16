//
//  PRDHelpers.m
//  Predica-SelfTest
//
//  Created by Jordan Jasinski on 15/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "PRDHelpers.h"

@implementation PRDHelpers

+(double)sfloatToDouble:(uint16_t)bytes {

	uint16_t mantissa = bytes & 0x0FFF;
    int8_t expoent = bytes >> 12;

    if (expoent >= 0x0008) {
        expoent = -((0x000F + 1) - expoent);
    }
	return (double)(mantissa * pow(10, expoent));
}

@end
