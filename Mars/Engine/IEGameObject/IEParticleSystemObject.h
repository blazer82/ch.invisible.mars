//
//  IEParticleSystemObject.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "IEGameObject.h"
#import "IEShapeObject.h"
#import "IEParticleObject.h"
#import "IEGraphicsManager.h"
#import "IEGravity.h"

@interface IEParticleSystemObject : IEGameObject

// object to emmit
@property (nonatomic, strong) IEShapeObject *emitterShapeObject;

// object to be emmitted
@property (nonatomic, strong) IEShapeObject *emissionShapeObject;

// emission rate per normal per second
@property (nonatomic) float emissionRate;

// average particle lifespan in seconds
@property (nonatomic) float particleLifespan;

// average particle initial speed
@property (nonatomic) float particleInitialSpeed;

// randomness of emission rate (usually below 1)
@property (nonatomic) float emissionRateRandomFactor;

// randomness of particle lifespan (usually below 1)
@property (nonatomic) float particleLifespanRadomFactor;

// randomness of particle initial speed (usually below 1)
@property (nonatomic) float particleInitialSpeedRandomFactor;

- (id)initWithEmitterShapeObject:(IEShapeObject*)emitterShapeObject andEmissionShapeObject:(IEShapeObject*)emissionShapeObject;
- (void)prepare;
- (void)update:(float)timeSinceLastUpdate;

@end
