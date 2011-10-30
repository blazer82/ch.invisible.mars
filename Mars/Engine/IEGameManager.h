//
//  IEGameManager.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "IEGraphicsManager.h"
#import "IECameraObject.h"
#import "IEShapeObject.h"
#import "IEParticleSystemObject.h"
#import "IEAnimation.h"

@interface IEGameManager : NSObject

@property (nonatomic, strong) IEGraphicsManager *graphicsManager;
@property (nonatomic, strong) IECameraObject *cameraObject;

+ (IEGameManager*)sharedManager;

- (void)setupWithView:(GLKView *)view;
- (void)useMotionManager;
- (void)update:(float)timeSinceLastUpdate;
- (void)render:(float)timeSinceLastRender;
- (void)registerShapeObject:(IEShapeObject*)shapeObject;
- (void)registerParticleSystem:(IEParticleSystemObject*)particleSystem;
- (void)registerAnimation:(IEAnimation*)animation;

@end
