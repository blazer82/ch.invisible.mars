//
//  IERootNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGroupNode.h"
#import "IECameraNode.h"
#import "IELightNode.h"

@interface IERootNode : IEGroupNode

@property (nonatomic, strong) IECameraNode *cameraChild;
@property (nonatomic, strong) IELightNode *lightChild;
@property (nonatomic) GLKVector4 ambientLight;

- (void)attachCameraChild:(IECameraNode *)cameraNode;
- (void)attachLightChild:(IELightNode *)lightNode;

@end
