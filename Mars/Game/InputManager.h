//
//  InputManager.h
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "IECameraObject.h"
#import "IEAnimation.h"

@interface InputManager : NSObject

@property (nonatomic, strong) IECameraObject *cameraObject;

- (id)initWithView:(GLKView *)view;
- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender;
- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender;
- (IBAction)handleDblTapGesture:(UIPinchGestureRecognizer *)sender;

@end
