//
//  IEGroupNode.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGroupNode.h"

@implementation IEGroupNode

@synthesize shapeChildren = _shapeChildren;

- (id)init
{
    self = [super init];
    
    _shapeChildren = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)attachShapeChild:(IEShapeNode *)shapeNode
{
    [self.shapeChildren addObject:shapeNode];
}

- (void)removeShapeChild:(IEShapeNode *)shapeNode
{
    [self.shapeChildren removeObject:shapeNode];
}

@end
