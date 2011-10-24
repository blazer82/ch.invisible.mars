//
//  IETexture.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IENodeComponent.h"

@interface IETexture : IENodeComponent

@property (nonatomic) GLuint texture;
@property (nonatomic) GLvoid *imageData;
@property (nonatomic) GLsizei width;
@property (nonatomic) GLsizei height;

@end
