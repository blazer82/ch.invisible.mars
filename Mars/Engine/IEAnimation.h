//
//  IEAnimation.h
//  Mars
//
//  Created by Raphael Stäbler on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IEAnimation : NSObject

@property (nonatomic) float duration;
@property (nonatomic) BOOL incremental;
@property (nonatomic, readonly) BOOL done;

- (id)initWithTarget:(id)target action:(SEL)action methodSignature:(NSMethodSignature*)methodSignature fromValue:(float)fromValue toValue:(float)toValue;
- (void)update:(float)timeSinceLastUpdate;

@end
