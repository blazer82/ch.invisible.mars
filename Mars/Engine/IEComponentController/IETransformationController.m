//
//  IETransformationController.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IETransformationController.h"

@implementation IETransformationController

@synthesize transformation = _transformation;

- (id)initForShapeNode:(IEShapeNode *)node
{
    self = [super init];
    
    node.transformation = [[IETransformation alloc] init];
    _transformation = node.transformation;
    
    return self;
}

- (id)initForCameraNode:(IECameraNode *)node
{
    self = [super init];
    
    _transformation = node.transformation;
    
    return self;
}

- (void)rotateXYZ:(GLfloat)radians
{
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 1.0f, 1.0f, 1.0f);
}

- (void)rotateX:(GLfloat)radians
{
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 1.0f, 0.0f, 0.0f);
}

- (void)rotateY:(GLfloat)radians
{
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 0.0f, 1.0f, 0.0f);
}

- (void)rotateZ:(GLfloat)radians
{
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 0.0f, 0.0f, 1.0f);
}

- (void)moveX:(GLfloat)amountX Y:(GLfloat)amountY Z:(GLfloat)amountZ
{
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, amountX, amountY, amountZ);
}

- (void)moveX:(GLfloat)amount
{
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, amount, 0.0f, 0.0f);
}

- (void)moveY:(GLfloat)amount
{
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, 0.0f, amount, 0.0f);
}

- (void)moveZ:(GLfloat)amount
{
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, 0.0f, 0.0f, amount);
}

- (void)scaleXYZ:(GLfloat)factor
{
    _transformation.matrix = GLKMatrix4Scale(_transformation.matrix, factor, factor, factor);
}

@end
