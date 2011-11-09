//
//  Cube.m
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"

@implementation Cube

- (id)init
{
    self = [super initWithGeometryNamed:@"cube2" andShaderNamed:@"NormalMapped" andTextureNamed:@"cube2"];
    
    [self.textureController loadNormalMapNamed:@"cube2-normalmap"];
    [self.shapeNode setupNormalMap];
    
    return self;
}

@end
