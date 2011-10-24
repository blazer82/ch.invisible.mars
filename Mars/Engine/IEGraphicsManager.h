//
//  IEGraphicsManager.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IEGraphicsManager/IEGraphicsManager_Protocol.h"
#import "IEGraphicsManager/IEGraphicsManager_OpenGLES2.h"
#import "IESceneGraph.h"

@interface IEGraphicsManager : NSObject <IEGraphicsManager_Protocol>

@property (nonatomic, strong) IESceneGraph *sceneGraph;

+ (IEGraphicsManager*)sharedManager;

@end
