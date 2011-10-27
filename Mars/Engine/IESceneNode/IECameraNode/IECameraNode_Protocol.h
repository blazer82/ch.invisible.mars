//
//  IECameraNode_Protocol.h
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IECameraNode.h"

@protocol IECameraNode_Protocol <NSObject>

- (id)initWithAspect:(float)aspect;
- (void)zoom:(float)factor;

@end
