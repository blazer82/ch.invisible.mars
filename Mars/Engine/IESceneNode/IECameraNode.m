//
//  IECameraNode.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraNode.h"

@implementation IECameraNode

@synthesize initialProjectionMatrix = _initialProjectionMatrix;

- (id)initPerspectiveWithAspect:(float)aspect
{
    self = [super init];
    
    _initialProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.transformation= [[IETransformation alloc] initWithMatrix:_initialProjectionMatrix];
    
    return self;
}

@end
