//
//  IEParticleObject.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEGameObject.h"
#import "IEShapeObject.h"
#import "IEForce.h"
#import "IETransformation.h"

@interface IEParticleObject : IEGameObject

@property (nonatomic, strong) IEShapeObject *shapeObject;
@property (nonatomic) float inverseMass;
@property (nonatomic) float lifespan;
@property (nonatomic) float age;
@property (nonatomic) GLKVector3 spawnPoint;

- (id)initWithShapeObject:(IEShapeObject*)shapeObject;
- (void)setupInitialSpeed:(float)speed andDirection:(GLKVector3)direction;
- (void)update:(float)timeSinceLastUpdate;
- (void)addForce:(IEForce*)force;
- (void)setMass:(uint)mass;
- (void)resetWithTransformation:(IETransformation*)transformation;

@end
