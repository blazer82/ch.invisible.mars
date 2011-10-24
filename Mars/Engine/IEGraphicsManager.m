//
//  IEGraphicsManager.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGraphicsManager.h"


@implementation IEGraphicsManager

@synthesize sceneGraph = _sceneGraph;

static IEGraphicsManager *_sharedManager = nil;
static IEGraphicsManager_OpenGLES2 *_manager = nil;

+ (IEGraphicsManager*)sharedManager
{
    if (_sharedManager == nil)
    {
        _sharedManager = [[super allocWithZone:NULL] init];
        _manager = [IEGraphicsManager_OpenGLES2 sharedManager];
    }
    
    return _sharedManager;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    
    _sceneGraph = [[IESceneGraph alloc] init];
    
    return self;
}

- (void)setupWithView:(UIView *)view
{
    [_manager setupWithView:view];
}

- (void)prepareToDraw
{
    [_manager prepareToDraw];
}

- (void)renderShapeNode:(IEShapeNode*)shapeNode forCameraNode:(IECameraNode*)cameraNode
{
    [_manager renderShapeNode:shapeNode forCameraNode:cameraNode];
}

@end
