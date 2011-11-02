//
//  IESceneGraph.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IESceneGraph.h"

@implementation IESceneGraph

@synthesize rootNode = _rootNode;

- (id)init
{
    self = [super init];
    
    _rootNode = [[IERootNode alloc] init];
    
    return self;
}

- (void)dealloc
{
    self.rootNode = nil;
}

@end
