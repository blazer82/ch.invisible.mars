//
//  IEGraphicsManager_OpenGLES2.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 22.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IEGraphicsManager_Protocol.h"
#import "IEGroupNode.h"
#import "IERootNode.h"

@interface IEGraphicsManager_OpenGLES2 : NSObject <IEGraphicsManager_Protocol>

@property (nonatomic, strong) IERootNode *currentRootNode;
@property (nonatomic, strong) IEGroupNode *currentGroupNode;

+ (IEGraphicsManager_OpenGLES2*)sharedManager;

@end
