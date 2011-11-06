//
//  IELightNode.h
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IESceneNode.h"

@interface IELightNode : IESceneNode

@property (nonatomic) GLKVector3 position;
@property (nonatomic) GLKVector4 light;

@end
