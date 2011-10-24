//
//  IEGameObject.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IETransformationController.h"

@interface IEGameObject : NSObject

@property (nonatomic, strong) IETransformationController *transformationController;

@end
