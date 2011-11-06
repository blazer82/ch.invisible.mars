//
//  IELightObject.h
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameObject.h"
#import "IELightNode.h"

@interface IELightObject : IEGameObject

@property (nonatomic, strong) IELightNode *lightNode;

@end
