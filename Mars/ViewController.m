//
//  ViewController.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (nonatomic, strong) IEGameManager *gameManager;
@property (nonatomic, strong) IEShapeObject *shapeObject;
@property (nonatomic, strong) IEShapeObject *shapeObject2;

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;

- (void)setupGL;
- (void)tearDownGL;
@end

@implementation ViewController

@synthesize gameManager = _gameManager;
@synthesize shapeObject = _shapeObject;
@synthesize shapeObject2 = _shapeObject2;
@synthesize context = _context;
@synthesize effect = _effect;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    self.gameManager = [IEGameManager sharedManager];
    [self.gameManager setupWithView:(GLKView *)self.view];  
    //[self.gameManager useMotionManager];
    [self setupGL];
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return NO;
    }
}

- (void)setupGL
{
    [_gameManager.cameraObject.transformationController rotateX:GLKMathDegreesToRadians(60)];
    //[_gameManager.cameraObject.transformationController moveX:17.1f];
    //[_gameManager.cameraObject.transformationController moveZ:-5.6f];
    [_gameManager.cameraObject.transformationController moveY:-1.1f];
    
    _shapeObject = [[IEShapeObject alloc] initWithGeometryNamed:@"terrain" andShaderNamed:@"Shader" andTextureNamed:@"terrain"];
    [self.gameManager registerShapeObject:_shapeObject];
    
    _shapeObject2 = [[IEShapeObject alloc] initWithGeometryNamed:@"basestation" andShaderNamed:@"Shader" andTextureNamed:@"basestation"];
    [self.gameManager registerShapeObject:_shapeObject2];
}

- (void)tearDownGL
{
    /*[EAGLContext setCurrentContext:self.context];
     
     glDeleteBuffers(1, &_vertexBuffer);
     glDeleteVertexArraysOES(1, &_vertexArray);
     
     self.effect = nil;
     
     if (_program) {
     glDeleteProgram(_program);
     _program = 0;
     }*/
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [_gameManager.cameraObject.transformationController rotateY:(self.timeSinceLastUpdate * 0.5f)];
    //[_gameManager.cameraObject.transformationController moveX:(self.timeSinceLastUpdate * 0.25f)];
    //[_gameManager.cameraObject.transformationController moveY:(self.timeSinceLastUpdate * 0.25f)];
    //[_shapeObject.transformationController rotateXYZ:(self.timeSinceLastUpdate * 0.5f)];
    //[_shapeObject2.transformationController rotateXYZ:(self.timeSinceLastUpdate * 5.0f)];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.gameManager update:self.timeSinceLastUpdate];
}

@end
