//
//  IEShader.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IENodeComponent.h"

@interface IEShader : IENodeComponent

@property (nonatomic) GLuint program;
@property (nonatomic) GLuint uniformModelViewProjectionMatrix;
@property (nonatomic) GLuint uniformNormalMatrix;
@property (nonatomic) GLuint uniformTextureSampler;
@property (nonatomic) GLuint uniformNormalMapSampler;

- (id)initWithProgram:(GLuint)program;

@end
