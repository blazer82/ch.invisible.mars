//
//  IESceneNode.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IETransformation.h"

@interface IESceneNode : NSObject

@property (nonatomic, strong) IETransformation *transformation;

@end
