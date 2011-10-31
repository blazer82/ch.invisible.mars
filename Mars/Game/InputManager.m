//
//  InputManager.m
//  Mars
//
//  Created by Raphael Stäbler on 27.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "InputManager.h"
#import "IEGameManager.h"
#import "IEMath.h"

@interface InputManager ()
{
    float _maxPanX;
    float _maxPanZ;
    float _panBounce;
    
    float _minZoom;
    float _maxZoom;
    float _minZoomBounce;
    float _maxZoomBounce;
    
    float _virtualX;
    float _virtualZ;
    float _virtualZoom;
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
    
    _maxPanX = 30.0f;
    _maxPanZ = 30.0f;
    _panBounce = 5.0f;
    
    _minZoom = 0.5f;
    _minZoomBounce = 0.1f;
    _maxZoom = 2.5f;
    _maxZoomBounce = 0.5f;
    
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
            _virtualX = self.cameraObject.transformationController.transformation.position.x;
            _virtualZ = self.cameraObject.transformationController.transformation.position.z;
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {
            CGPoint panDiff;
            panDiff.x = _panStart.x - translate.x;
            panDiff.y = _panStart.y - translate.y;
            
            float moveX = -(panDiff.x / (_cameraObject.cameraNode.zoomFactor * 20.0f));
            float moveZ = -(panDiff.y / (_cameraObject.cameraNode.zoomFactor * 20.0f));
            
            _virtualX += moveX;
            _virtualZ += moveZ;
            
            if (_virtualX + moveX > _maxPanX)
            {
                float diff = _virtualX + moveX - _maxPanX; 
                if (diff > 0.0f) // supposed to be impossible, but was causing some malfunction
                {
                    diff = [IEMath easeX:diff scale:_panBounce];
                    moveX = _maxPanX + diff - self.cameraObject.transformationController.transformation.position.x;
                }
            }
            else if (_virtualX + moveX < -_maxPanX)
            {
                float diff = -_maxPanX - (_virtualX + moveX);
                if (diff > 0.0f) // supposed to be impossible, but was causing some malfunction
                {
                    diff = [IEMath easeX:diff scale:_panBounce];
                    moveX = -_maxPanX - diff - self.cameraObject.transformationController.transformation.position.x;
                }
            }
            
            if (_virtualZ + moveZ > _maxPanZ)
            {
                float diff = _virtualZ + moveZ - _maxPanZ; 
                if (diff > 0.0f) // supposed to be impossible, but was causing some malfunction
                {
                    diff = [IEMath easeX:diff scale:_panBounce];
                    moveZ = _maxPanZ + diff - self.cameraObject.transformationController.transformation.position.z;
                }
            }
            else if (_virtualZ + moveZ < -_maxPanZ)
            {
                float diff = -_maxPanZ - (_virtualZ + moveX);
                if (diff > 0.0f) // supposed to be impossible, but was causing some malfunction
                {
                    diff = [IEMath easeX:diff scale:_panBounce];
                    moveZ = -_maxPanZ - diff - self.cameraObject.transformationController.transformation.position.z;
                }
            }
            
            [_cameraObject.transformationController moveX:moveX];
            [_cameraObject.transformationController moveZ:moveZ];
            
            _panStart = translate;
        }
        else if (sender.state == UIGestureRecognizerStateEnded)
        {
            if (self.cameraObject.transformationController.transformation.position.x > _maxPanX)
            {
                _virtualX = _maxPanX;
            }
            else if (self.cameraObject.transformationController.transformation.position.x < -_maxPanX)
            {
                _virtualX = -_maxPanX;
            }
            
            if (self.cameraObject.transformationController.transformation.position.z > _maxPanZ)
            {
                _virtualZ = _maxPanZ;
            }
            else if (self.cameraObject.transformationController.transformation.position.z < -_maxPanZ)
            {
                _virtualZ = -_maxPanZ;
            }
            
            // bounce back animation x
            if (_virtualX != self.cameraObject.transformationController.transformation.position.x)
            {
                IEAnimation *animation = [[IEAnimation alloc] initWithTarget:self.cameraObject.transformationController action:@selector(moveX:) methodSignature:[IETransformationController instanceMethodSignatureForSelector:@selector(moveX:)] fromValue:self.cameraObject.transformationController.transformation.position.x toValue:_virtualX];
                animation.incremental = YES;
                animation.duration = 0.2f;
                [_gameManager registerAnimation:animation];
            }
            
            // bounce back animation y
            if (_virtualZ != self.cameraObject.transformationController.transformation.position.z)
            {
                IEAnimation *animation = [[IEAnimation alloc] initWithTarget:self.cameraObject.transformationController action:@selector(moveZ:) methodSignature:[IETransformationController instanceMethodSignatureForSelector:@selector(moveZ:)] fromValue:self.cameraObject.transformationController.transformation.position.z toValue:_virtualZ];
                animation.incremental = YES;
                animation.duration = 0.2f;
                [_gameManager registerAnimation:animation];
            }
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
            _virtualZoom = _cameraObject.cameraNode.zoomFactor;
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {
            float scaleAbs = _virtualZoom * (scale / _scaleStart);
            _virtualZoom = scaleAbs;
            
            if (scaleAbs > _maxZoom)
            {
                float diff = scaleAbs - _maxZoom;
                diff = [IEMath easeX:diff scale:_maxZoomBounce];
                scaleAbs = _maxZoom + diff;
            }
            else if (scaleAbs < _minZoom)
            {
                float diff = _minZoom - scaleAbs;
                diff = [IEMath easeX:diff scale:_minZoomBounce];
                scaleAbs = _minZoom - diff;
            }
            
            [_cameraObject.cameraNode zoom:scaleAbs];
            
            _scaleStart = scale;
        }
        else if (sender.state == UIGestureRecognizerStateEnded)
        {
            if (_cameraObject.cameraNode.zoomFactor > _maxZoom)
            {
                _virtualZoom = _maxZoom;
            }
            else if (_cameraObject.cameraNode.zoomFactor < _minZoom)
            {
                _virtualZoom = _minZoom;
            }
            
            // bounce back animation
            if (_virtualZoom != _cameraObject.cameraNode.zoomFactor)
            {
                IEAnimation *animation = [[IEAnimation alloc] initWithTarget:_cameraObject.cameraNode action:@selector(zoom:) methodSignature:[IECameraNode instanceMethodSignatureForSelector:@selector(zoom:)] fromValue:_cameraObject.cameraNode.zoomFactor toValue:_virtualZoom];
                animation.incremental = NO;
                animation.duration = 0.2f;
                [_gameManager registerAnimation:animation];
            }
        }
    }
}

- (void)handleDblTapGesture:(UITapGestureRecognizer *)sender
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
    animation.duration = 0.2f;
    [_gameManager registerAnimation:animation];
}

@end
