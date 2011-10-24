//
//  IEForce.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface IEForce : NSObject

@property (nonatomic) GLKVector3 accelerationVector;
@property (nonatomic) BOOL stopAtZero;
@property (nonatomic) BOOL globalForce;

- (id)initWithAcceleration:(float)acc andDirection:(GLKVector3)direction;
- (id)initWithAccelerationVector:(GLKVector3)vector;

@end
