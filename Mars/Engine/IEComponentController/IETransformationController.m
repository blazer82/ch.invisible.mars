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
    
    node.transformation = [[IETransformation alloc] init];
    _transformation = node.transformation;
    
    return self;
}

- (void)rotateXYZ:(GLfloat)radians
{
    _transformation.rotation = GLKVector3Make(_transformation.rotation.x + radians, _transformation.rotation.y + radians, _transformation.rotation.z + radians);
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 1.0f, 1.0f, 1.0f);
}

- (void)rotateX:(GLfloat)radians
{
    _transformation.rotation = GLKVector3Make(_transformation.rotation.x + radians, _transformation.rotation.y, _transformation.rotation.z);
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 1.0f, 0.0f, 0.0f);
}

- (void)rotateY:(GLfloat)radians
{
    _transformation.rotation = GLKVector3Make(_transformation.rotation.x, _transformation.rotation.y + radians, _transformation.rotation.z);
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 0.0f, 1.0f, 0.0f);
}

- (void)rotateZ:(GLfloat)radians
{
    _transformation.rotation = GLKVector3Make(_transformation.rotation.x, _transformation.rotation.y, _transformation.rotation.z + radians);
    _transformation.matrix = GLKMatrix4Rotate(_transformation.matrix, radians, 0.0f, 0.0f, 1.0f);
}

- (void)moveX:(GLfloat)amountX Y:(GLfloat)amountY Z:(GLfloat)amountZ
{
    _transformation.position = GLKVector3Make(_transformation.position.x + amountX, _transformation.position.y + amountY, _transformation.position.z + amountZ);
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, amountX, amountY, amountZ);
}

- (void)moveX:(GLfloat)amount
{
    _transformation.position = GLKVector3Make(_transformation.position.x + amount, _transformation.position.y, _transformation.position.z);
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, amount, 0.0f, 0.0f);
}

- (void)moveY:(GLfloat)amount
{
    _transformation.position = GLKVector3Make(_transformation.position.x, _transformation.position.y + amount, _transformation.position.z);
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, 0.0f, amount, 0.0f);
}

- (void)moveZ:(GLfloat)amount
{
    _transformation.position = GLKVector3Make(_transformation.position.x, _transformation.position.y, _transformation.position.z + amount);
    _transformation.matrix = GLKMatrix4Translate(_transformation.matrix, 0.0f, 0.0f, amount);
}

- (void)scaleXYZ:(GLfloat)factor
{
    _transformation.scale = GLKVector3Make(_transformation.scale.x * factor, _transformation.scale.y * factor, _transformation.scale.z * factor);
    _transformation.matrix = GLKMatrix4Scale(_transformation.matrix, factor, factor, factor);
}

@end
