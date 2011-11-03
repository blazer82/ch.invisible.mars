//
//  IECameraObject.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 26.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameObject.h"
#import "IECameraNode_Perspective.h"
#import "IECameraNode_Ortho.h"
#import "IECameraNode_Frustum.h"

@interface IECameraObject : IEGameObject

@property (nonatomic, strong) IECameraNode *cameraNode;
@property (nonatomic) float minZoom;
@property (nonatomic) float maxZoom;
@property (nonatomic) float defaultAngle;
@property (nonatomic) float minAngle;
@property (nonatomic) float maxAngle;

- (id)initPerspectiveWithView:(GLKView*)view;
- (id)initOrthoWithView:(GLKView*)view;
- (id)initFrustumWithView:(GLKView*)view;
- (void)zoom:(float)factor;

@end
