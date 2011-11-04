//
//  IECameraObject.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 26.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraObject.h"

@interface IECameraObject ()
{
}
@end

@implementation IECameraObject

@synthesize cameraNode = _cameraNode;
@synthesize minZoom = _minZoom;
@synthesize maxZoom = _maxZoom;
@synthesize defaultAngle = _defaultAngle;
@synthesize minAngle = _minAngle;
@synthesize maxAngle = _maxAngle;

- (id)initPerspectiveWithView:(GLKView *)view
{
    self = [super init];
    
    _minZoom = 1.0f;
    _maxZoom = 1.0f;
    _defaultAngle = 0.0f;
    _minAngle = 0.0f;
    _maxAngle = 0.0f;
    
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    
    _cameraNode = [[IECameraNode_Perspective alloc] initWithAspect:aspect];
    
    self.transformationController = [[IETransformationController alloc] initForCameraNode:_cameraNode];
    
    return self;
}

- (id)initOrthoWithView:(GLKView *)view
{
    self = [super init];
    
    _minZoom = 1.0f;
    _maxZoom = 1.0f;
    _defaultAngle = 0.0f;
    _minAngle = 0.0f;
    _maxAngle = 0.0f;
    
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    
    _cameraNode = [[IECameraNode_Ortho alloc] initWithAspect:aspect];
    
    self.transformationController = [[IETransformationController alloc] initForCameraNode:_cameraNode];
    
    return self;
}

- (id)initFrustumWithView:(GLKView *)view
{
    self = [super init];
    
    _minZoom = 1.0f;
    _maxZoom = 1.0f;
    _defaultAngle = 0.0f;
    _minAngle = 0.0f;
    _maxAngle = 0.0f;
    
    float aspect = fabsf(view.bounds.size.width / view.bounds.size.height);
    
    _cameraNode = [[IECameraNode_Frustum alloc] initWithAspect:aspect];
    
    self.transformationController = [[IETransformationController alloc] initForCameraNode:_cameraNode];
    
    return self;
}

- (void)zoom:(float)factor
{
    float angle = _defaultAngle;
    
    if (factor < 1.0)
    {
        angle = _defaultAngle + ((_maxAngle - _defaultAngle) / (_minZoom - 1.0f)) * (factor - 1.0f);
    }
    else if (factor > 1.0)
    {
        angle = _defaultAngle + ((_minAngle - _defaultAngle) / (_maxZoom - 1.0f)) * (factor - 1.0f);
    }
    
    /*if (angle < _minAngle)
    {
        angle = _minAngle;
    }
    
    if (angle > _maxAngle)
    {
        angle = _maxAngle;
    }*/
    
    //NSLog([NSString stringWithFormat:@"angle: %f", angle]);
    
    float angleDiff = GLKMathDegreesToRadians(angle) - _cameraNode.transformation.rotation.x;
    
    [_cameraNode zoom:factor];
    [self.transformationController rotateX:angleDiff];
}

- (void)dealloc
{
    self.cameraNode = nil;
}

@end
