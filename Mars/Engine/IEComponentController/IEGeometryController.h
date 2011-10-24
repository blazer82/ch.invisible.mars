//
//  IEGeometryController.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEComponentController.h"
#import "IEShapeNode.h"
#import "IEGeometry.h"

@interface IEGeometryController : IEComponentController

@property (nonatomic, strong) IEGeometry *geometry;

- (id)initGeometryNamed:(NSString *)file forShapeNode:(IEShapeNode*)node;

@end
