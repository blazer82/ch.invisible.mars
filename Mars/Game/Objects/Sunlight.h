//
//  Sunlight.h
//  Mars
//
//  Created by Raphael Stäbler on 06.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IELightObject.h"

@interface Sunlight : IELightObject

- (void)setupWithAmbientLight:(GLKVector4)light;

@end
