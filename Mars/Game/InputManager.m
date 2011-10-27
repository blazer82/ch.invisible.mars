//
//  InputManager.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputManager.h"

@interface InputManager ()
{
    CGPoint _panStart;
    CGFloat _scaleStart;
}
@property (nonatomic, strong) GLKView *view;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

@end

@implementation InputManager

@synthesize cameraObject = _cameraObject;
@synthesize view = _view;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize pinchGestureRecognizer = _pinchGestureRecognizer;

- (id)initWithView:(GLKView *)view
{
    self = [super init];
    
    _view = view;
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_view addGestureRecognizer:_panGestureRecognizer];
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [_view addGestureRecognizer:_pinchGestureRecognizer];
    
    return self;
}

- (IBAction)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    if (self.cameraObject)
    {
        CGPoint translate = [sender translationInView:self.view];
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            _panStart = translate;
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {
            CGPoint panDiff;
            panDiff.x = _panStart.x - translate.x;
            panDiff.y = _panStart.y - translate.y;
            
            [_cameraObject.transformationController moveX:-(panDiff.x / (_cameraObject.cameraNode.zoomFactor * 40.0f))];
            [_cameraObject.transformationController moveZ:-(panDiff.y / (_cameraObject.cameraNode.zoomFactor * 40.0f))];
            
            _panStart = translate;
        }
    }
}

- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)sender
{
    if (self.cameraObject)
    {
        CGFloat scale = sender.scale;
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            _scaleStart = scale;
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {
            CGFloat scaleDiff = _cameraObject.cameraNode.zoomFactor * (scale / _scaleStart);
            
            [_cameraObject.cameraNode zoom:scaleDiff];
            
            NSLog([NSString stringWithFormat:@"scale: %f", scale]);
            
            _scaleStart = scale;
        }
    }
}

@end
