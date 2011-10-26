//
//  IECameraNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IESceneNode.h"
#import <GLKit/GLKit.h>

@interface IECameraNode : IESceneNode

@property (nonatomic) GLKMatrix4 initialProjectionMatrix;
@property (nonatomic) GLKMatrix4 projectionMatrix;

- (id)initPerspectiveWithAspect:(float)aspect;
- (id)initOrthoWithAspect:(float)aspect;

@end
