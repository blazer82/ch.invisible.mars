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
@synthesize lightChild = _lightChild;
@synthesize ambientLight = _ambientLight;

- (id)init
{
    self = [super init];
    
    _ambientLight = GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f);
    
    return self;
}

- (void)attachCameraChild:(IECameraNode *)cameraNode
{
    _cameraChild = cameraNode;
}

- (void)attachLightChild:(IELightNode *)lightNode
{
    _lightChild = lightNode;
}

- (void)dealloc
{
    self.cameraChild = nil;
    self.lightChild = nil;
}

@end
