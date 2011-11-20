//
//  Game.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "Cube.h"
#import "Sunlight.h"
#import "Basestation.h"

@interface Game ()
{
    
}
@property (nonatomic, strong) IEGameManager *gameManager;
@property (nonatomic, strong) InputManager *inputManager;
@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) IEShapeObject *shapeObject;
@property (nonatomic, strong) IEShapeObject *shapeObject2;


@end


@implementation Game

@synthesize gameManager = _gameManager;
@synthesize inputManager = _inputManager;
@synthesize context = _context;
@synthesize shapeObject = _shapeObject;
@synthesize shapeObject2 = _shapeObject2;


- (void)setupWithView:(GLKView *)view
{
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    // game manager
    _gameManager = [IEGameManager sharedManager];
    [_gameManager setupWithView:(GLKView *)view]; 
    
    // input manager
    _inputManager = [[InputManager alloc] initWithView:(GLKView *)view andCameraObject:_gameManager.cameraObject];
    
    // light (sun & ambient)
    Sunlight *sunlight = [[Sunlight alloc] init];
    sunlight.lightNode.light = GLKVector4Make(0.5f, 0.5f, 0.5f, 1.0f);
    [sunlight setupWithAmbientLight:GLKVector4Make(0.15f, 0.1f, 0.1f, 1.0f)];
    [sunlight.transformationController moveX:20.0f];
    [sunlight.transformationController moveY:100.0f];
    [sunlight.transformationController moveZ:-10.0f];
    
    
    // camera
    [_gameManager.cameraObject.transformationController rotateX:GLKMathDegreesToRadians(60)];
    _gameManager.cameraObject.defaultAngle = 60.0f;
    _gameManager.cameraObject.minAngle = 30.0f;
    _gameManager.cameraObject.maxAngle = 80.0f;
    _gameManager.cameraObject.minZoom = 0.5f;
    _gameManager.cameraObject.maxZoom = 2.5f;
    [_gameManager.cameraObject zoom:1.0f];
    [_gameManager.cameraObject.transformationController moveY:-20.0f];
    
    // cube
    //_shapeObject = [[Cube alloc] init];
    //[_gameManager registerShapeObject:_shapeObject];
    
    // terrain
    /*_shapeObject = [[IEShapeObject alloc] initWithGeometryNamed:@"terrain" andShaderNamed:@"NormalMapped" andTextureNamed:@"terrain"];
    [_shapeObject.textureController loadNormalMapNamed:@"terrain-normalmap"];
    [_shapeObject.shapeNode setupNormalMap];
    [_gameManager registerShapeObject:_shapeObject];*/
    
    // basestation
    _shapeObject = [[Basestation alloc] init];
    [_gameManager registerShapeObject:_shapeObject];
}

- (void)update:(float)timeSinceLastUpdate
{
    [_shapeObject.transformationController rotateY:(timeSinceLastUpdate * 0.5f)];
    
    [_gameManager update:timeSinceLastUpdate];
}

- (void)render:(float)timeSinceLastRender
{
    [_gameManager render:timeSinceLastRender];
}

- (void)dealloc
{
    self.gameManager = nil;
    self.inputManager = nil;
}

@end
