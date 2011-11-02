//
//  IEGeometry.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGeometry.h"

@implementation IEGeometry

@synthesize vertexData = _vertexData;
@synthesize dataSize = _dataSize;
@synthesize dataLength = _dataLength;
@synthesize vertexArray = _vertexArray;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize boundingBox = _boundingBox;

- (id)init
{
    self = [super init];
    
    _dataSize = 0;
    _dataLength = 0;
    _vertexArray = 0;
    _vertexBuffer = 0;
    
    _boundingBox.min.x = 0.0f;
    _boundingBox.min.y = 0.0f;
    _boundingBox.min.z = 0.0f;
    
    _boundingBox.max.x = 0.0f;
    _boundingBox.max.y = 0.0f;
    _boundingBox.max.z = 0.0f;
    
    return self;
}

- (void)dealloc
{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    _vertexArray = 0;
    _vertexBuffer = 0;
}

@end
