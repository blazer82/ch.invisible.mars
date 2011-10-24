//
//  IETransformationController.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEComponentController.h"
#import "IETransformation.h"
#import "IEShapeNode.h"
#import "IECameraNode.h"

@interface IETransformationController : IEComponentController

@property (nonatomic, strong) IETransformation *transformation;

- (id)initForShapeNode:(IEShapeNode*)node;
- (id)initForCameraNode:(IECameraNode*)node;
- (void)rotateXYZ:(GLfloat)radians;
- (void)rotateX:(GLfloat)radians;
- (void)rotateY:(GLfloat)radians;
- (void)rotateZ:(GLfloat)radians;
- (void)moveX:(GLfloat)amountX Y:(GLfloat)amountY Z:(GLfloat)amountZ;
- (void)moveX:(GLfloat)amount;
- (void)moveY:(GLfloat)amount;
- (void)moveZ:(GLfloat)amount;
- (void)scaleXYZ:(GLfloat)factor;

@end
