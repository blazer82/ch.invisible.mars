//
//  IECameraNode_Perspective.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraNode_Perspective.h"

@implementation IECameraNode_Perspective

- (id)initWithAspect:(float)aspect
{
    self = [super init];
    
    super.initialProjectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    super.projectionMatrix = super.initialProjectionMatrix;
    
    return self;
}

- (void)zoom:(float)factor
{
    
}

@end
