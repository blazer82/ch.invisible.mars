//
//  IETextureController.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreGraphics/CoreGraphics.h"
#import "IEComponentController.h"
#import "IETexture.h"
#import "IEShapeNode.h"

@interface IETextureController : IEComponentController

@property (nonatomic, strong) IETexture *texture;

- (id)initTextureNamed:(NSString*)name forShapeNode:(IEShapeNode*)shapeNode;

@end
