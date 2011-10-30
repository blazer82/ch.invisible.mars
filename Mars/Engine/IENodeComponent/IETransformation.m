//
//  IETransformation.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IETransformation.h"

@implementation IETransformation

@synthesize matrix = _matrix;
@synthesize position = _position;
@synthesize rotation = _rotation;
@synthesize scale = _scale;

- (id)init
{
    self = [super init];
    
    _matrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
    _position = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _rotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
    return self;
}

- (id)initWithMatrix:(GLKMatrix4)matrix
{
    self = [super init];
    
    _matrix = matrix;
    _position = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _rotation = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _scale = GLKVector3Make(0.0f, 0.0f, 0.0f);
    
    return  self;
}

@end
