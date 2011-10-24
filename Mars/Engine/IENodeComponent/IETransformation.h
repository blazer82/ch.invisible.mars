//
//  IETransformation.h
//  InvisibleEngine
//
//  Created by Raphael Stäbler on 23.09.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IENodeComponent.h"

@interface IETransformation : IENodeComponent

@property (nonatomic) GLKMatrix4 matrix;

- (id)initWithMatrix:(GLKMatrix4)matrix;

@end
