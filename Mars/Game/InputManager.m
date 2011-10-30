//
//  InputManager.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputManager.h"
#import "IEGameManager.h"

@interface InputManager ()
{
    float _minZoom;
    float _maxZoom;
    
    float _autoZoom;
    
    CGPoint _panStart;
    CGFloat _scaleStart;
}
@property (nonatomic, strong) IEGameManager *gameManager;
@property (nonatomic, strong) GLKView *view;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *dblTapGestureRecognizer;

- (void)animateCameraZoom:(float)zoomFactor;

@end

@implementation InputManager

@synthesize cameraObject = _cameraObject;
@synthesize gameManager = _gameManager;
@synthesize view = _view;
@synthesize panGestureRecognizer = _panGestureRecognizer;
@synthesize pinchGestureRecognizer = _pinchGestureRecognizer;
@synthesize dblTapGestureRecognizer = _dblTapGestureRecognizer;

- (id)initWithView:(GLKView *)view
{
    self = [super init];
    
    _minZoom = 0.5f;
    _maxZoom = 2.5f;
    
    _autoZoom = _maxZoom;
    
    _gameManager = [IEGameManager sharedManager];
    _view = view;
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [_view addGestureRecognizer:_panGestureRecognizer];
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [_view addGestureRecognizer:_pinchGestureRecognizer];
    
    _dblTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDblTapGesture:)];
    _dblTapGestureRecognizer.numberOfTapsRequired = 2;
    [_view addGestureRecognizer:_dblTapGestureRecognizer];
    
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
            
            [_cameraObject.transformationController moveX:-(panDiff.x / (_cameraObject.cameraNode.zoomFactor * 20.0f))];
            [_cameraObject.transformationController moveZ:-(panDiff.y / (_cameraObject.cameraNode.zoomFactor * 20.0f))];
            
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
            float scaleAbs = _cameraObject.cameraNode.zoomFactor * (scale / _scaleStart);
            
            if (scaleAbs >= _minZoom && scaleAbs <= _maxZoom)
            {
                [_cameraObject.cameraNode zoom:scaleAbs];
            }
            
            _scaleStart = scale;
        }
    }
}

- (void)handleDblTapGesture:(UIPinchGestureRecognizer *)sender
{
    if (self.cameraObject)
    {
        if (_cameraObject.cameraNode.zoomFactor < 1.0f || _cameraObject.cameraNode.zoomFactor == _autoZoom)
        {
            [self animateCameraZoom:1.0f];
        }
        else if (_cameraObject.cameraNode.zoomFactor < _autoZoom)
        {
            [self animateCameraZoom:_autoZoom];
        }
    }
}

- (void)animateCameraZoom:(float)zoomFactor
{
    IEAnimation *animation = [[IEAnimation alloc] initWithTarget:_cameraObject.cameraNode action:@selector(zoom:) methodSignature:[IECameraNode instanceMethodSignatureForSelector:@selector(zoom:)] fromValue:_cameraObject.cameraNode.zoomFactor toValue:zoomFactor];
    animation.incremental = NO;
    [_gameManager registerAnimation:animation];
}

@end
