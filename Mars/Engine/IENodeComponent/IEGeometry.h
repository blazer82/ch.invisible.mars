//
//  IEGeometry.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IENodeComponent.h"

typedef struct
{
    GLKVector3 min;
    GLKVector3 max;
} IEBoundingBox;

@interface IEGeometry : IENodeComponent

@property (nonatomic) GLfloat *vertexData;
@property (nonatomic) uint dataSize;
@property (nonatomic) GLsizei dataLength;
@property (nonatomic) GLuint vertexArray;
@property (nonatomic) GLuint vertexBuffer;
@property (nonatomic) IEBoundingBox boundingBox;

@end
