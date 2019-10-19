//
//  FakeCBService.m
//  Predica-SelfTestTests
//
//  Created by Jordan Jasinski on 19/10/2019.
//  Copyright © 2019 skyisthelimit.aero. All rights reserved.
//

#import "FakeCBService.h"

@interface FakeCBService ()

@property (nonatomic, strong) CBUUID *mockedUUID;

@end

@implementation FakeCBService

+(FakeCBService*)serviceWithIdentifier:(CBUUID *)identifier {
	FakeCBService *service = [FakeCBService new];
	service.mockedUUID = identifier;
	return service;
}

-(CBUUID*)UUID {
	return self.mockedUUID;
}

-(NSArray<CBCharacteristic*>*)characteristics {
	return self.mockedCharacteristics;
}

@end
