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
@synthesize normalMap = _normalMap;
@synthesize vertexAttribPosition = _vertexAttribPosition;
@synthesize vertexAttribNormal = _vertexAttribNormal;
@synthesize vertexAttribTexture = _vertexAttribTexture;
@synthesize vertexAttribTangent = _vertexAttribTangent;

- (id)init
{
    self = [super init];
    
    _vertexAttribPosition = GLKVertexAttribPosition;
    _vertexAttribNormal = GLKVertexAttribNormal;
    _vertexAttribTexture = GLKVertexAttribTexCoord0;
    _vertexAttribTangent = 6;
    
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
    
    glEnableVertexAttribArray(_vertexAttribPosition);
    glVertexAttribPointer(_vertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*11, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(_vertexAttribTexture);
    glVertexAttribPointer(_vertexAttribTexture, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*11, BUFFER_OFFSET(sizeof(GLfloat)*3));
    glEnableVertexAttribArray(_vertexAttribNormal);
    glVertexAttribPointer(_vertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*11, BUFFER_OFFSET(sizeof(GLfloat)*5));
    glEnableVertexAttribArray(_vertexAttribTangent);
    glVertexAttribPointer(_vertexAttribTangent, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*11, BUFFER_OFFSET(sizeof(GLfloat)*8));
    
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
    
    [_texture freeSourceData];
}

- (void)setupNormalMap
{
    GLuint texture;
    
    // Generates a new texture name/id.
	glGenTextures(1, &texture);
	
	// Binds the new name/id to really create the texture and hold it to set its properties.
	glBindTexture(GL_TEXTURE_2D, texture);
	
	// Uploads the pixel data to the bound texture.
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _normalMap.width, _normalMap.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, _normalMap.imageData);
	
	// Defines the Minification and Magnification filters to the bound texture.
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// Generates a full MipMap chain to the current bound texture.
	glGenerateMipmap(GL_TEXTURE_2D);
    
    _normalMap.texture = texture;
    
    [_normalMap freeSourceData];
}

- (void)dealloc
{
    self.geometry = nil;
    self.shader = nil;
    self.texture = nil;
    self.normalMap = nil;
}

@end
