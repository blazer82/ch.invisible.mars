//
//  IETexture.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IETexture.h"

@implementation IETexture

@synthesize texture = _texture;
@synthesize imageData = _imageData;
@synthesize width = _width;
@synthesize height = _height;

- (void)dealloc
{
    free(_imageData);
}

@end
