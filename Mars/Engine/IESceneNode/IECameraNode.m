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

- (id)initPerspectiveWithAspect:(float)aspect
{
    self = [super init];
    
    _initialProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    _projectionMatrix = _initialProjectionMatrix;
    
    return self;
}

- (id)initOrthoWithAspect:(float)aspect
{
    self = [super init];
    
    float width = 10.0f * aspect;
    float height = width / aspect;
    
    _initialProjectionMatrix = GLKMatrix4MakeOrtho(-(width/2), (width/2), 0.0f, height, 0.1f, 100.0f);
    _projectionMatrix = _initialProjectionMatrix;
    
    return self;
}

@end
