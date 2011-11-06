//
//  IELightNode.m
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IELightNode.h"

@implementation IELightNode

@synthesize position = _position;
@synthesize light = _light;

- (id)init
{
    self = [super init];
    
    _position = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    _light = GLKVector4Make(0.0f, 0.0f, 0.0f, 0.0f);
    
    return self;
}

@end
