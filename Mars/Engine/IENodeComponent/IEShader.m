//
//  IEShader.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEShader.h"

@interface IEShader ()
{

}

@end

@implementation IEShader

@synthesize program = _program;
@synthesize uniformModelViewProjectionMatrix = _uniformModelViewProjectionMatrix;
@synthesize uniformNormalMatrix = _uniformNormalMatrix;
@synthesize uniformTextureSampler = _uniformTextureSampler;

- (id)initWithProgram:(GLuint)program
{
    self = [super init];
    _program = program;
    
    return self;
}

- (void)dealloc
{
    if (_program)
    {
        glDeleteProgram(_program);
        _program = 0;
    }
}

@end
