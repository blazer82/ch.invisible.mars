//
//  IECameraObject.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 26.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameObject.h"
#import "IECameraNode.h"

@interface IECameraObject : IEGameObject

@property (nonatomic, strong) IECameraNode *cameraNode;

- (id)initWithView:(GLKView*)view;

@end
