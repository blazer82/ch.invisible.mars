//
//  Game.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

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
    
    _gameManager = [IEGameManager sharedManager];
    [_gameManager setupWithView:(GLKView *)view]; 
    
    _inputManager = [[InputManager alloc] initWithView:(GLKView *)view];
    _inputManager.cameraObject = _gameManager.cameraObject;
    
    
    [_gameManager.cameraObject.transformationController rotateX:GLKMathDegreesToRadians(60)];
    //[_gameManager.cameraObject.transformationController moveX:17.1f];
    //[_gameManager.cameraObject.transformationController moveZ:-5.6f];
    [_gameManager.cameraObject.transformationController moveY:-20.0f];
    
    _shapeObject = [[IEShapeObject alloc] initWithGeometryNamed:@"terrain" andShaderNamed:@"Shader" andTextureNamed:@"terrain"];
    [_gameManager registerShapeObject:_shapeObject];
    
    _shapeObject2 = [[IEShapeObject alloc] initWithGeometryNamed:@"basestation" andShaderNamed:@"Shader" andTextureNamed:@"basestation"];
    [_gameManager registerShapeObject:_shapeObject2];
}

- (void)update:(float)timeSinceLastUpdate
{
    //[_gameManager.cameraObject.transformationController rotateY:(timeSinceLastUpdate * 0.5f)];
    
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
