//
//  Game.h
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEGameManager.h"
#import "InputManager.h"
#import "IEShapeObject.h"
#import "IEParticleSystemObject.h"

@interface Game : NSObject

- (void)setupWithView:(GLKView *)view;
- (void)update:(float)timeSinceLastUpdate;
- (void)render:(float)timeSinceLastRender;

@end
