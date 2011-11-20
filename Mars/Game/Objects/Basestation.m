//
//  Basestation.m
//  Mars
//
//  Created by Raphael Stäbler on 20.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Basestation.h"

@implementation Basestation

- (id)init
{
    self = [super initWithGeometryNamed:@"basestation2" andShaderNamed:@"NormalMapped" andTextureNamed:@"basestation2-texture"];
    
    [self.textureController loadNormalMapNamed:@"basestation2-normalmap"];
    [self.shapeNode setupNormalMap];
    
    return self;
}

@end
