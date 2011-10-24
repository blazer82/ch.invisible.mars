//
//  IERootNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGroupNode.h"
#import "IECameraNode.h"

@interface IERootNode : IEGroupNode

@property (nonatomic, strong) IECameraNode *cameraChild;

- (void)attachCameraChild:(IECameraNode *)cameraNode;

@end
