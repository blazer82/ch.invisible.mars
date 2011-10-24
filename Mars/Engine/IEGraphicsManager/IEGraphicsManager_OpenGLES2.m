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
    
}
@property (strong, nonatomic) EAGLContext *context;

@end


@implementation IEGraphicsManager_OpenGLES2

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
}

- (void)prepareToDraw
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void)renderShapeNode:(IEShapeNode *)shapeNode forCameraNode:(IECameraNode *)cameraNode
{
    GLKMatrix4 modelViewProjectionMatrix = GLKMatrix4Multiply(cameraNode.transformation.matrix, shapeNode.transformation.matrix);
    GLKMatrix3 normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(shapeNode.transformation.matrix), NULL);
    
    glBindVertexArrayOES(shapeNode.geometry.vertexArray);
    glUseProgram(shapeNode.shader.program);
    
    if (shapeNode.texture)
    {
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, shapeNode.texture.texture);
        glUniform1i(shapeNode.shader.uniformTextureSampler, 0);
    }
    
    glUniformMatrix4fv(shapeNode.shader.uniformModelViewProjectionMatrix, 1, 0, modelViewProjectionMatrix.m);
    glUniformMatrix3fv(shapeNode.shader.uniformNormalMatrix, 1, 0, normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, shapeNode.geometry.dataLength);
    
    glBindVertexArrayOES(0);
    
    //NSLog([NSString stringWithFormat:@"gl error: %i", glGetError()]);
}

@end
