//
//  IECameraNode_Ortho.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraNode_Ortho.h"

@interface IECameraNode_Ortho ()
{
    float _aspect;
    float _zoomMultiplier;
}

- (void)setupProjectionMatrix;

@end


@implementation IECameraNode_Ortho

- (id)initWithAspect:(float)aspect
{
    self = [super init];
    
    _aspect = aspect;
    _zoomMultiplier = 10.0f;
    
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
    float width = ((1/self.zoomFactor) * _zoomMultiplier) * _aspect;
    float height = width / _aspect;
    
    super.initialProjectionMatrix = GLKMatrix4MakeOrtho(-(width/2), (width/2), 0.0f, height, 0.1f, 100.0f);
    super.projectionMatrix = super.initialProjectionMatrix;
}

@end
