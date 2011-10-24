//
//  IEShaderController.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEComponentController.h"
#import "IEShader.h"
#import "IEShapeNode.h"

@interface IEShaderController : IEComponentController

@property (nonatomic, strong) IEShader *shader;

- (id)initShaderNamed:(NSString*)name forShapeNode:(IEShapeNode*)node;

@end
