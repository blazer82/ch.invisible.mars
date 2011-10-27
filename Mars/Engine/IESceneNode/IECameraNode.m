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
@synthesize projectionMatrix = _projectionMatrix;
@synthesize zoomFactor = _zoomFactor;

- (id)init
{
    self = [super init];
    
    _zoomFactor = 1.0f;
    
    return self;
}

@end
