//
//  IEShapeObject.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 26.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameObject.h"
#import "IEShapeNode.h"
#import "IEShaderController.h"
#import "IETextureController.h"
#import "IEGeometryController.h"

@interface IEShapeObject : IEGameObject

@property (nonatomic, strong) IEShapeNode *shapeNode;
@property (nonatomic, strong) IEGeometryController *geometryController;
@property (nonatomic, strong) IEShaderController *shaderController;
@property (nonatomic, strong) IETextureController *textureController;

- (id)initWithGeometryNamed:(NSString*)geometryName andShaderNamed:(NSString*)shaderName;
- (id)initWithGeometryNamed:(NSString*)geometryName andShaderNamed:(NSString*)shaderName andTextureNamed:(NSString*)textureName;
- (id)initAsInstanceOfObject:(IEShapeObject*)object;
- (void)copyTransformationOfObject:(IEShapeObject*)object;
- (void)copyOnceTransformationOfObject:(IEShapeObject*)object;

@end
