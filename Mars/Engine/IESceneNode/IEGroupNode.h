//
//  IEGroupNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IESceneNode.h"
#import "IEShapeNode.h"

@interface IEGroupNode : IESceneNode

@property (nonatomic, strong) NSMutableArray *shapeChildren;

- (void)attachShapeChild:(IEShapeNode *)shapeNode;
- (void)removeShapeChild:(IEShapeNode *)shapeNode;

@end
