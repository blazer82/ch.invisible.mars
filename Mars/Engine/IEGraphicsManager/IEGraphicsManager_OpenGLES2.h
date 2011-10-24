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

@interface IEGraphicsManager_OpenGLES2 : NSObject <IEGraphicsManager_Protocol>

+ (IEGraphicsManager_OpenGLES2*)sharedManager;

@end
