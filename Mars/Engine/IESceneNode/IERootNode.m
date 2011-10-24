//
//  IERootNode.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IERootNode.h"

@implementation IERootNode

@synthesize cameraChild = _cameraChild;

- (void)attachCameraChild:(IECameraNode *)cameraNode
{
    _cameraChild = cameraNode;
}

@end
