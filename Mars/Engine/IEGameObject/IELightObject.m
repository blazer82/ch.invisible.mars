//
//  IELightObject.m
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IELightObject.h"

@implementation IELightObject

@synthesize lightNode = _lightNode;

- (id)init
{
    self = [super init];
    
    _lightNode = [[IELightNode alloc] init];
    
    self.transformationController = [[IETransformationController alloc] initForNode:_lightNode];
    
    return self;
}

@end
