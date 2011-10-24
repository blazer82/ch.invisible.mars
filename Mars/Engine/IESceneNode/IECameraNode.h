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

- (id)initPerspectiveWithAspect:(float)aspect;

@end
