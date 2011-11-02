//
//  IEParticleSystemObject.m
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 03.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEParticleSystemObject.h"

typedef struct
{
    GLKVector3 coord;
    GLKVector3 normal;
} Vertex;

typedef struct
{
    Vertex a;
    Vertex b;
    Vertex c;
    Vertex center;
} SpawnFace;

@interface IEParticleSystemObject ()
{
    SpawnFace *_spawnFaces;
    uint _spawnFaceCount;
    float _timeSinceLastSpawn;
    float _nextEmissionRate;
    uint _particlePoolSize;
    uint _particlePoolIndex;
}
@property (nonatomic, strong) IEGraphicsManager *graphicsManager;
@property (nonatomic, strong) NSMutableArray *particles;
@property (nonatomic, strong) NSArray *particlePool;

- (void)setupSpawnFaces;

@end

@implementation IEParticleSystemObject

@synthesize emitterShapeObject = _emitterShapeObject;
@synthesize emissionShapeObject = _emissionShapeObject;
@synthesize emissionRate = _emissionRate;
@synthesize particleLifespan = _particleLifespan;
@synthesize particleInitialSpeed = _particleInitialSpeed;
@synthesize emissionRateRandomFactor = _emissionRateRandomFactor;
@synthesize particleLifespanRadomFactor = _particleLifespanRadomFactor;
@synthesize particleInitialSpeedRandomFactor = _particleInitialSpeedRandomFactor;
@synthesize graphicsManager = _graphicsManager;
@synthesize particles = _particles;
@synthesize particlePool = _particlePool;

- (id)initWithEmitterShapeObject:(IEShapeObject *)emitterShapeObject andEmissionShapeObject:(IEShapeObject *)emissionShapeObject
{
    self = [super init];
    
    _emitterShapeObject = emitterShapeObject;
    _emissionShapeObject = emissionShapeObject;
    
    _emissionRate = 0.0f;
    _particleLifespan = 0.0f;
    _particleInitialSpeed = 0.0f;
    _emissionRateRandomFactor = 0.0f;
    _particleLifespanRadomFactor = 0.0f;
    _particleInitialSpeedRandomFactor = 0.0f;
    
    _timeSinceLastSpawn = 0.0f;
    
    _graphicsManager = [IEGraphicsManager sharedManager];
    _particles = [[NSMutableArray alloc] init];
    
    _particlePoolSize = 0;
    _particlePoolIndex = 0;
    
    _nextEmissionRate = _emissionRate;
    
    [self setupSpawnFaces];
    
    return self;
}

- (void)prepare
{
    NSMutableArray *particles = [[NSMutableArray alloc] init];
    
    uint poolIndex = 0;
    
    for (uint p = 0; p < _emissionRate * _particleLifespan * (1 + _particleLifespanRadomFactor); p++)
    {
        for (uint s = 0; s < 3; s++)
        {
            for (uint f = 0; f < _spawnFaceCount; f++)
            {
                SpawnFace spawnFace = _spawnFaces[f];
                Vertex spawnPoint;
                
                if (s == 0)
                {
                    spawnPoint = spawnFace.a;
                }
                else if (s == 1)
                {
                    spawnPoint = spawnFace.b;
                }
                else
                {
                    spawnPoint = spawnFace.c;
                }
                
                // calculate random lifespan
                float lifespanRandomComponent = ((arc4random() % 100) * (_particleLifespanRadomFactor * 2 * _particleLifespan)) / 100;
                float particleLifespan = _particleLifespan - (_particleLifespan * _particleLifespanRadomFactor) + lifespanRandomComponent;
                
                // calculate random speed
                float speedRandomComponent = ((arc4random() % 100) * (_particleInitialSpeedRandomFactor * 2 * _particleInitialSpeed)) / 100;
                float particleInitialSpeed = _particleInitialSpeed - (_particleInitialSpeed * _particleInitialSpeedRandomFactor) + speedRandomComponent;
                
                // initialize shape object
                IEShapeObject *particleShape = [[IEShapeObject alloc] initAsInstanceOfObject:_emissionShapeObject];
                
                // inititialize particle object
                IEParticleObject *particleObject = [[IEParticleObject alloc] initWithShapeObject:particleShape];
                particleObject.spawnPoint = spawnPoint.coord;
                [particleObject setMass:20];
                particleObject.lifespan = particleLifespan;
                [particleObject setupInitialSpeed:particleInitialSpeed andDirection:spawnPoint.normal];
                
                // add basic braking force
                IEForce *brakingForce = [[IEForce alloc] initWithAcceleration:(particleInitialSpeed * -10.0f) andDirection:spawnPoint.normal];
                brakingForce.stopAtZero = YES;
                [particleObject addForce:brakingForce];
                
                // add gravity
                IEGravity *gravity = [[IEGravity alloc] init];
                [particleObject addForce:gravity];
                
                // add particle to the system
                [particles addObject:particleObject];
                
                poolIndex++;
            }
        }
    }
    
    _particlePoolSize = poolIndex;
    
    _particlePool = [[NSArray alloc] initWithArray:particles];
}

- (void)update:(float)timeSinceLastUpdate
{
    // remove outdated particles
    NSMutableArray *garbageCollector = [[NSMutableArray alloc] init];
    
    for (IEParticleObject *particleObject in _particles)
    {
        particleObject.age += timeSinceLastUpdate;
        
        if (particleObject.age > particleObject.lifespan)
        {
            [garbageCollector addObject:particleObject];
        }
    }
    
    //NSLog([NSString stringWithFormat:@"num particles %i", _particles.count]);
    
    for (IEParticleObject *particleObject in garbageCollector)
    {
        [_graphicsManager.sceneGraph.rootNode removeShapeChild:particleObject.shapeObject.shapeNode];
        [_particles removeObject:particleObject];
    }
    
    // update existing particles
    for (IEParticleObject *particleObject in _particles)
    {
        [particleObject update:timeSinceLastUpdate];
    }
    
    // calculate emission (prevent from being zero or below)
    if (_nextEmissionRate <= 0.0f)
    {
        _nextEmissionRate = _emissionRate;
    }
    _timeSinceLastSpawn += timeSinceLastUpdate;
    uint newParticleCount = floorf(_nextEmissionRate * _timeSinceLastSpawn);
    
    //NSLog([NSString stringWithFormat:@"newParticleCount: %i", newParticleCount]);
    
    // create new particles
    if (newParticleCount > 0)
    {
        _timeSinceLastSpawn = 0.0f;
        
        for (uint p = 0; p < newParticleCount; p++)
        {
            // update pool index
            _particlePoolIndex++;
            if (_particlePoolIndex >= _particlePoolSize)
            {
                _particlePoolIndex = 0;
            }
            
            // fetch from pool
            IEParticleObject *particleObject = [_particlePool objectAtIndex:_particlePoolIndex];
            
            // reset particle
            [particleObject resetWithTransformation:_emitterShapeObject.transformationController.transformation];
            
            // register shapeNode with graphics manager
            [_graphicsManager.sceneGraph.rootNode attachShapeChild:particleObject.shapeObject.shapeNode];
            
            // add particle to the system
            [_particles addObject:particleObject];
        }
        
        // calculate random emission rate
        float spawnRateRandomComponent = ((arc4random() % 100) * (_emissionRateRandomFactor * 2 * _emissionRate)) / 100;
        _nextEmissionRate = _emissionRate - (_emissionRate * _emissionRateRandomFactor) + spawnRateRandomComponent;
    }
}

- (void)setupSpawnFaces
{
    _spawnFaceCount = _emitterShapeObject.shapeNode.geometry.dataLength / 3;
    
    //NSLog([NSString stringWithFormat:@"_spawnFaceCount %i", _spawnFaceCount]);
    
    _spawnFaces = malloc(sizeof(SpawnFace) * _spawnFaceCount);
    
    for (uint faceIndex = 0; faceIndex < _spawnFaceCount; faceIndex++)
    {
        SpawnFace spawnFace;
        
        spawnFace.a.coord.x  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 0];
        spawnFace.a.coord.y  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 1];
        spawnFace.a.coord.z  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 2];
        spawnFace.a.normal.x = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 5];
        spawnFace.a.normal.y = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 6];
        spawnFace.a.normal.z = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 7];
        
        spawnFace.b.coord.x  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 8];
        spawnFace.b.coord.y  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 9];
        spawnFace.b.coord.z  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 10];
        spawnFace.b.normal.x = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 13];
        spawnFace.b.normal.y = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 14];
        spawnFace.b.normal.z = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 15];
        
        spawnFace.c.coord.x  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 16];
        spawnFace.c.coord.y  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 17];
        spawnFace.c.coord.z  = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 18];
        spawnFace.c.normal.x = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 21];
        spawnFace.c.normal.y = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 22];
        spawnFace.c.normal.z = _emitterShapeObject.shapeNode.geometry.vertexData[(faceIndex * 24) + 23];
        
        // calculate face center
        GLKVector3 v1 = GLKVector3Lerp(spawnFace.a.coord, spawnFace.b.coord, 0.5f);
        spawnFace.center.coord = GLKVector3Lerp(v1, spawnFace.c.coord, 0.5f);
        //spawnFace.center.coord = GLKVector3MultiplyScalar(GLKVector3Add(GLKVector3Add(spawnFace.a.coord, spawnFace.b.coord), spawnFace.c.coord), 0.33f);

        // calculate center normal (face normal)
        spawnFace.center.normal = GLKVector3Normalize(GLKVector3Add(GLKVector3Add(spawnFace.a.normal, spawnFace.b.normal), spawnFace.c.normal));
        
        // move corners towards center
        spawnFace.a.coord = GLKVector3Lerp(spawnFace.a.coord, spawnFace.center.coord, 0.5f);
        spawnFace.a.normal = GLKVector3Normalize(GLKVector3Add(spawnFace.a.normal, spawnFace.center.normal));
        
        spawnFace.b.coord = GLKVector3Lerp(spawnFace.b.coord, spawnFace.center.coord, 0.5f);
        spawnFace.b.normal = GLKVector3Normalize(GLKVector3Add(spawnFace.b.normal, spawnFace.center.normal));
        
        spawnFace.c.coord = GLKVector3Lerp(spawnFace.c.coord, spawnFace.center.coord, 0.5f);
        spawnFace.c.normal = GLKVector3Normalize(GLKVector3Add(spawnFace.c.normal, spawnFace.center.normal));
        
        _spawnFaces[faceIndex] = spawnFace;
    }
}

- (void)dealloc
{
    self.emitterShapeObject = nil;
    self.emissionShapeObject = nil;
}

@end
