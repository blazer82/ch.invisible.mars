//
//  Sunlight.m
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Sunlight.h"
#import "IEGameManager.h"

@interface Sunlight ()
{
    
}
@property (nonatomic, strong) IEGameManager *gameManager;

@end

@implementation Sunlight

@synthesize gameManager = _gameManager;

- (id)init
{
    self = [super init];
    
    _gameManager = [IEGameManager sharedManager];
    
    return self;
}

- (void)setupWithAmbientLight:(GLKVector4)light
{
    [_gameManager.graphicsManager.sceneGraph.rootNode attachLightChild:self.lightNode];
    _gameManager.graphicsManager.sceneGraph.rootNode.ambientLight = light;
}

- (void)dealloc
{
    self.gameManager = nil;
}

@end
