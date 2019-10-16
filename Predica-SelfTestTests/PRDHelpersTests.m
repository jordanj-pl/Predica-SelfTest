//
//  PRDHelpersTests.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 15/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

@import XCTest;

#import "PRDHelpers.h"

@interface PRDHelpersTests : XCTestCase

@end

@implementation PRDHelpersTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSFloatToDouble_120 {
    //Given
    uint16_t givenSFloat = 4108;//0001000000001100

    //When
	double result = [PRDHelpers sfloatToDouble:givenSFloat];

    //Then
    XCTAssertEqual(result, 120);
}

- (void)testSFloatToDouble_70 {
    //Given
    uint16_t givenSFloat = 4103;//0001000000000111

    //When
	double result = [PRDHelpers sfloatToDouble:givenSFloat];

    //Then
    XCTAssertEqual(result, 70);
}

@end
