//
//  IECameraObject.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 26.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraObject.h"

@implementation IECameraObject

@synthesize cameraNode = _cameraNode;

- (id)initPerspectiveWithView:(GLKView *)view
{
    self = [super init];
    
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    
    _cameraNode = [[IECameraNode alloc] initPerspectiveWithAspect:aspect];
    
    self.transformationController = [[IETransformationController alloc] initForCameraNode:_cameraNode];
    
    return self;
}

- (id)initOrthoWithView:(GLKView *)view
{
    self = [super init];
    
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    
    _cameraNode = [[IECameraNode alloc] initOrthoWithAspect:aspect];
    
    self.transformationController = [[IETransformationController alloc] initForCameraNode:_cameraNode];
    
    return self;
}

@end
