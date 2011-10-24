//
//  IEGravity.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGravity.h"

@implementation IEGravity

- (id)init
{
    self = [super initWithAcceleration:-9.81f andDirection:GLKVector3Make(0.0f, 1.0f, 0.0f)];
    
    self.globalForce = YES;
    
    return self;
}

@end
