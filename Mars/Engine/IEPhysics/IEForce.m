//
//  IEForce.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEForce.h"

@implementation IEForce

@synthesize accelerationVector = _accelerationVector;
@synthesize stopAtZero = _stopAtZero;
@synthesize globalForce = _globalForce;

- (id)initWithAcceleration:(float)acc andDirection:(GLKVector3)direction
{
    self = [super init];
    
    _accelerationVector = GLKVector3MultiplyScalar(GLKVector3Normalize(direction), acc);
    _stopAtZero = NO;
    _globalForce = NO;
    
    return self;
}

- (id)initWithAccelerationVector:(GLKVector3)vector
{
    self = [super init];
    
    _accelerationVector = vector;
    _stopAtZero = NO;
    _globalForce = NO;
    
    return self;
}

@end
