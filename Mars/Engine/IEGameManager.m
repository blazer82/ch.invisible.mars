//
//  IEGameManager.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameManager.h"

@interface IEGameManager ()
{
    
}
@property (nonatomic, strong) NSMutableArray *particleSystems;
@property (nonatomic, strong) NSMutableArray *animations;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) BOOL useDeviceMotion;

- (void)setupCameraWithView:(UIView*)view;

@end

@implementation IEGameManager

@synthesize particleSystems = _particleSystems;
@synthesize animations = _animations;
@synthesize graphicsManager = _graphicsManager;
@synthesize cameraObject = _cameraObject;
@synthesize motionManager = _motionManager;
@synthesize useDeviceMotion = _useDeviceMotion;

+ (IEGameManager*)sharedManager
{
    static dispatch_once_t once;
    static IEGameManager *sharedManager;
    dispatch_once(&once, ^ { sharedManager = [[self alloc] init]; });
    return sharedManager;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    self = [super init];
    
    _useDeviceMotion = NO;
    _particleSystems = [[NSMutableArray alloc] init];
    _animations = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)setupWithView:(GLKView *)view
{
    _graphicsManager = [IEGraphicsManager sharedManager];
    [_graphicsManager setupWithView:view];
    [self setupCameraWithView:view];
}

- (void)setupCameraWithView:(GLKView *)view
{
    _cameraObject = [[IECameraObject alloc] initOrthoWithView:view];
    //[_cameraObject.transformationController moveY:-2.0f];
    [_graphicsManager.sceneGraph.rootNode attachCameraChild:_cameraObject.cameraNode];
}

- (void)update:(float)timeSinceLastUpdate
{
    // camera motion
    if (_useDeviceMotion)
    {
        // Get device motion
        /*CMDeviceMotion *currentDeviceMotion = [_motionManager deviceMotion];
        CMAttitude *currentAttitude = [currentDeviceMotion attitude];
        CMRotationMatrix rotationMatrix = [currentAttitude rotationMatrix];
        
        // Init OpenGL rotation matrix
        GLKMatrix4 projectionRotationMatrix;
        projectionRotationMatrix = GLKMatrix4Make(rotationMatrix.m11, rotationMatrix.m21, rotationMatrix.m31, 0.0f, rotationMatrix.m12, rotationMatrix.m22, rotationMatrix.m32, 0.0f, rotationMatrix.m13, rotationMatrix.m23, rotationMatrix.m33, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f);
        
        // correct rotation
        projectionRotationMatrix = GLKMatrix4RotateX(projectionRotationMatrix, 1.25f);
        
        _graphicsManager.sceneGraph.rootNode.cameraChild.transformation.matrix = GLKMatrix4Multiply(_graphicsManager.sceneGraph.rootNode.cameraChild.initialProjectionMatrix, projectionRotationMatrix);*/
    }
    
    // update particle systems
    for (IEParticleSystemObject *particleSystem in _particleSystems)
    {
        [particleSystem update:timeSinceLastUpdate];
    }
    
    // remove outdated animations
    NSMutableArray *garbageCollector = [[NSMutableArray alloc] init];
    
    for (IEAnimation *animation in _animations)
    {
        if (animation.done)
        {
            [garbageCollector addObject:animation];
        }
    }
    for (IEAnimation *animation in garbageCollector)
    {
        [_animations removeObject:animation];
    }
    
    // update animation
    for (IEAnimation *animation in _animations)
    {
        [animation update:timeSinceLastUpdate];
    }
}

- (void)render:(float)timeSinceLastRender
{
    [_graphicsManager prepareToDraw];
    for (IEShapeNode *shape in _graphicsManager.sceneGraph.rootNode.shapeChildren)
    {
        [_graphicsManager renderShapeNode:shape forCameraNode:_graphicsManager.sceneGraph.rootNode.cameraChild];
    }
}

- (void)registerShapeObject:(IEShapeObject *)shapeObject
{
    [_graphicsManager.sceneGraph.rootNode attachShapeChild:shapeObject.shapeNode];
}

- (void)registerParticleSystem:(IEParticleSystemObject *)particleSystem
{
    [_particleSystems addObject:particleSystem];
}

- (void)registerAnimation:(IEAnimation *)animation
{
    [_animations addObject:animation];
}

- (void)useMotionManager
{
    _motionManager = [[CMMotionManager alloc] init];
    [_motionManager setDeviceMotionUpdateInterval:1.0f/60.0f];
    [_motionManager startDeviceMotionUpdates];
    _useDeviceMotion = YES;
}

@end
