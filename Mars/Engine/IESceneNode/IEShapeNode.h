//
//  IEShapeNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IESceneNode.h"
#import "IEGeometry.h"
#import "IEShader.h"
#import "IETexture.h"

@interface IEShapeNode : IESceneNode

@property (nonatomic, strong) IEGeometry *geometry;
@property (nonatomic, strong) IEShader *shader;
@property (nonatomic, strong) IETexture *texture;
@property (nonatomic) GLuint vertexAttribPosition;
@property (nonatomic) GLuint vertexAttribNormal;
@property (nonatomic) GLuint vertexAttribTexture;

- (void)setupVertexBuffer;
- (void)setupTexture;

@end
