//
//  IECameraNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IESceneNode.h"
#import <GLKit/GLKit.h>
#import "IECameraNode_Protocol.h"

@interface IECameraNode : IESceneNode <IECameraNode_Protocol>

@property (nonatomic) GLKMatrix4 initialProjectionMatrix;
@property (nonatomic) GLKMatrix4 projectionMatrix;
@property (nonatomic) float zoomFactor;

@end
