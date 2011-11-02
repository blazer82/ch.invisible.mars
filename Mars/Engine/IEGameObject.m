//
//  IEGameObject.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameObject.h"

@implementation IEGameObject

@synthesize transformationController = _transformationController;

- (void)dealloc
{
    self.transformationController = nil;
}

@end
