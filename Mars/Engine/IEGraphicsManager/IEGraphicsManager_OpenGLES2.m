//
//  IEGraphicsManager_OpenGLES2.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGraphicsManager_OpenGLES2.h"

@interface IEGraphicsManager_OpenGLES2 ()
{
    GLKVector4 _rootNodeLightPosition;
}
@property (strong, nonatomic) EAGLContext *context;

@end


@implementation IEGraphicsManager_OpenGLES2

@synthesize currentRootNode = _currentRootNode;
@synthesize currentGroupNode = _currentGroupNode;
@synthesize context = _context;

static IEGraphicsManager_OpenGLES2 *_sharedManager = nil;

+ (IEGraphicsManager_OpenGLES2*)sharedManager
{
    if (_sharedManager == nil)
    {
        _sharedManager = [[super allocWithZone:NULL] init];
    }
    
    return _sharedManager;
}

+ (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (void)setupWithView:(UIView *)view
{
    // initialize context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context)
    {
        NSLog(@"Failed to create ES context");
    }
    
    [EAGLContext setCurrentContext:self.context];
    
    // initialize view
    GLKView *glkView = (GLKView *)view;
    glkView.context = self.context;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // initialize opengl
    glEnable(GL_DEPTH_TEST);
    
    //NSLog([NSString stringWithFormat:@"GL_MAX_TEXTURE_SIZE: %i", GL_MAX_TEXTURE_SIZE]);
}

- (void)prepareToDraw
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // compute root node light position
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(_currentRootNode.cameraChild.transformation.matrix, _currentRootNode.lightChild.transformation.matrix);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(_currentRootNode.cameraChild.projectionMatrix, modelViewMatrix);
    _rootNodeLightPosition = GLKMatrix4MultiplyVector4(modelViewProjectionMatrix, _currentRootNode.lightChild.position);
    //NSLog([NSString stringWithFormat:@"%f %f %f %f", _rootNodeLightPosition.x, _rootNodeLightPosition.y, _rootNodeLightPosition.z, _rootNodeLightPosition.w]);
}

- (void)renderShapeNode:(IEShapeNode *)shapeNode
{
    GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(_currentRootNode.cameraChild.transformation.matrix, shapeNode.transformation.matrix);
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(_currentRootNode.cameraChild.projectionMatrix, modelViewMatrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(shapeNode.transformation.matrix), NULL);
    
    glBindVertexArrayOES(shapeNode.geometry.vertexArray);
    glUseProgram(shapeNode.shader.program);
    
    // texture uniform
    if (shapeNode.texture)
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, shapeNode.texture.texture);
        glUniform1i(shapeNode.shader.uniformTextureSampler, 0);
    }
    
    // normalMap uniform
    if (shapeNode.normalMap)
    {
        glActiveTexture(GL_TEXTURE2);
        glBindTexture(GL_TEXTURE_2D, shapeNode.normalMap.texture);
        glUniform1i(shapeNode.shader.uniformNormalMapSampler, 2);
    }
    
    // matrix uniforms
    glUniformMatrix4fv(shapeNode.shader.uniformModelViewProjectionMatrix, 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(shapeNode.shader.uniformNormalMatrix, 1, 0, normalMatrix.m);
    
    // light uniforms
    glUniform4fv(shapeNode.shader.uniformAmbientLight, 1, _currentRootNode.ambientLight.v);
    glUniform4fv(shapeNode.shader.uniformLightPosition1, 1, _rootNodeLightPosition.v);
    glUniform4fv(shapeNode.shader.uniformSpecularLight1, 1, _currentRootNode.lightChild.light.v);
    
    glDrawArrays(GL_TRIANGLES, 0, shapeNode.geometry.dataLength);
    
    glBindVertexArrayOES(0);
    
    //NSLog([NSString stringWithFormat:@"gl error: %i", glGetError()]);
}

- (void)dealloc
{
    self.context = nil;
    self.currentRootNode = nil;
    self.currentGroupNode = nil;
}

@end
