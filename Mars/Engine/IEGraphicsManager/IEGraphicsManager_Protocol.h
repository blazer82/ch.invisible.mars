//
//  IEGraphicsManager_Protocol.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEShapeNode.h"
#import "IECameraNode.h"

@protocol IEGraphicsManager_Protocol <NSObject>

- (void)setupWithView:(UIView *)view;
- (void)prepareToDraw;
- (void)renderShapeNode:(IEShapeNode*)shapeNode;

@end
