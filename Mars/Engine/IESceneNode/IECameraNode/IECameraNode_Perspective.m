//
//  IECameraNode_Perspective.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraNode_Perspective.h"

@interface IECameraNode_Perspective ()
{
    float _aspect;
}

- (void)setupProjectionMatrix;

@end

@implementation IECameraNode_Perspective

- (id)initWithAspect:(float)aspect
{
    self = [super init];
    
    _aspect = aspect;
    
    [self setupProjectionMatrix];
    
    return self;
}

- (void)zoom:(float)factor
{
    self.zoomFactor = factor;
    [self setupProjectionMatrix];
}

- (void)setupProjectionMatrix
{
    super.initialProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f) * (1 / self.zoomFactor), _aspect, 0.1f, 100.0f);
    super.projectionMatrix = super.initialProjectionMatrix;
}

@end
