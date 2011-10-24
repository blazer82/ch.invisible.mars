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

- (id)init
{
    self = [super init];
    
    _matrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -10.0f);
    
    return self;
}

- (id)initWithMatrix:(GLKMatrix4)matrix
{
    self = [super init];
    
    _matrix = matrix;
    
    return  self;
}

@end
