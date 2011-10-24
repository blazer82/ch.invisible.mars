//
//  IESceneGraph.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IERootNode.h"

@interface IESceneGraph : NSObject

@property (nonatomic, strong) IERootNode *rootNode;

@end
