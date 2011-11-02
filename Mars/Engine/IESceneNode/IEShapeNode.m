//
//  IEShapeNode.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEShapeNode.h"
#import "IEGroupNode.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@implementation IEShapeNode

@synthesize geometry = _geometry;
@synthesize shader = _shader;
@synthesize texture = _texture;
@synthesize vertexAttribPosition = _vertexAttribPosition;
@synthesize vertexAttribNormal = _vertexAttribNormal;
@synthesize vertexAttribTexture = _vertexAttribTexture;

- (id)init
{
    self = [super init];
    
    _vertexAttribPosition = GLKVertexAttribPosition;
    _vertexAttribNormal = GLKVertexAttribNormal;
    _vertexAttribTexture = GLKVertexAttribTexCoord0;
    
    return self;
}

- (void)setupVertexBuffer
{
    GLuint vertexArray;
    GLuint vertexBuffer;
    
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _geometry.dataSize, _geometry.vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, BUFFER_OFFSET(sizeof(GLfloat)*3));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, BUFFER_OFFSET(sizeof(GLfloat)*5));
    
    glBindVertexArrayOES(0);
    
    _geometry.vertexArray = vertexArray;
    _geometry.vertexBuffer = vertexBuffer;
    
    NSLog([NSString stringWithFormat:@"gl error: %i", glGetError()]);
}

- (void)setupTexture
{
    GLuint texture;
    
    // Generates a new texture name/id.
	glGenTextures(1, &texture);
	
	// Binds the new name/id to really create the texture and hold it to set its properties.
	glBindTexture(GL_TEXTURE_2D, texture);
	
	// Uploads the pixel data to the bound texture.
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _texture.width, _texture.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, _texture.imageData);
	
	// Defines the Minification and Magnification filters to the bound texture.
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Generates a full MipMap chain to the current bound texture.
	glGenerateMipmap(GL_TEXTURE_2D);
    
    _texture.texture = texture;
}

- (void)dealloc
{
    self.geometry = nil;
    self.shader = nil;
    self.texture = nil;
}

@end
