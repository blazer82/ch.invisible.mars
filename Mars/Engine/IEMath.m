//
//  IEMath.m
//  Mars
//
//  Created by Raphael Stäbler on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEMath.h"

@implementation IEMath

+ (float)easeX:(float)x scale:(float)scale
{
    x = (x / scale) * 10.0f;
    float y = logf(x + 1.0f) * 4.1f;
    
    float easedX = scale * (y / 10.0f);
    return easedX;
}

@end
