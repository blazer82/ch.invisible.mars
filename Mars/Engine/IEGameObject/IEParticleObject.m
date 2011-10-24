//
//  IEParticleObject.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEParticleObject.h"

@interface IEParticleObject ()
{
    
}
@property (nonatomic) GLKVector3 initialSpeedVector;
@property (nonatomic) GLKVector3 speedVector;
@property (nonatomic, strong) NSMutableArray *initialForces;
@property (nonatomic, strong) NSMutableArray *forces;

@end

@implementation IEParticleObject

@synthesize shapeObject = _shapeObject;
@synthesize inverseMass = _inverseMass;
@synthesize lifespan = _lifespan;
@synthesize age = _age;
@synthesize initialForces = _initialForces;
@synthesize forces = _forces;
@synthesize initialSpeedVector = _initialSpeedVector;
@synthesize speedVector = _speedVector;
@synthesize spawnPoint = _spawnPoint;

- (id)initWithShapeObject:(IEShapeObject *)shapeObject
{
    self = [super init];
    
    _shapeObject = shapeObject;
    
    _inverseMass = 0.0f;
    _lifespan = 0.0f;
    _age = 0.0f;
    _initialSpeedVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
    _initialForces = [[NSMutableArray alloc] init];
    _forces= [[NSMutableArray alloc] init];
    return self;
}

- (void)setupInitialSpeed:(float)speed andDirection:(GLKVector3)direction
{
    _initialSpeedVector = GLKVector3MultiplyScalar(GLKVector3Normalize(direction), speed);
}

- (void)resetWithTransformation:(IETransformation *)transformation
{
    _speedVector = _initialSpeedVector;
    _age = 0.0f;
    
    _shapeObject.transformationController.transformation.matrix = transformation.matrix;
    [_shapeObject.transformationController moveX:_spawnPoint.x Y:_spawnPoint.y Z:_spawnPoint.z];
    
    _forces = nil;
    _forces = [[NSMutableArray alloc] init];
    
    for (IEForce *force in _initialForces)
    {
        IEForce *translatedForce = [[IEForce alloc] initWithAccelerationVector:force.accelerationVector];
        translatedForce.stopAtZero = force.stopAtZero;
        translatedForce.globalForce = force.globalForce;
        
        if (translatedForce.globalForce)
        {
            translatedForce.accelerationVector = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(transformation.matrix, NO), translatedForce.accelerationVector);
        }
        
        [_forces addObject:translatedForce];
    }
}

- (void)update:(float)timeSinceLastUpdate
{
    NSMutableArray *forceGarbageCollector = [[NSMutableArray alloc] init];
    
    for (IEForce *force in _forces)
    {
        GLKVector3 forceAccVector = GLKVector3MultiplyScalar(force.accelerationVector, _inverseMass);
        GLKVector3 newSpeedVector;
        
        newSpeedVector = GLKVector3Add(_speedVector, GLKVector3MultiplyScalar(forceAccVector, timeSinceLastUpdate));
        
        if (force.stopAtZero && !GLKVector3AllEqualToScalar(_speedVector, 0.0f))
        {
            if (
                ((_speedVector.x >= 0.0f && newSpeedVector.x <= 0.0f) || (_speedVector.x <= 0.0f && newSpeedVector.x >= 0.0f))
                && ((_speedVector.y >= 0.0f && newSpeedVector.y <= 0.0f) || (_speedVector.y <= 0.0f && newSpeedVector.x >= 0.0f))
                && ((_speedVector.z >= 0.0f && newSpeedVector.z <= 0.0f) || (_speedVector.z <= 0.0f && newSpeedVector.z >= 0.0f))
                )
            {
                newSpeedVector = GLKVector3Make(0.0f, 0.0f, 0.0f);
                [forceGarbageCollector addObject:force];
            }
        }
        
        _speedVector = newSpeedVector;
    }
    
    // garbage collection
    for (IEForce *force in forceGarbageCollector)
    {
        [_forces removeObject:force];
    }
    
    [_shapeObject.transformationController moveX:_speedVector.x Y:_speedVector.y Z:_speedVector.z];
}

- (void)addForce:(IEForce *)force
{
    [_initialForces addObject:force];
}

- (void)setMass:(uint)mass
{
    if (mass > 0)
    {
        _inverseMass = 1.0f / mass;
    }
}

@end
