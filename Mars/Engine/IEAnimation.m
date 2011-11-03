//
//  IEAnimation.m
//  Mars
//
//  Created by Raphael Stäbler on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IEAnimation.h"
#import "IEMath.h"

@interface IEAnimation ()
{
    float _timeSinceStart;
    float _fromToDiff;
    float _diffSoFar;
    float _valueSoFar;
}
@property (nonatomic, strong) id target;
@property (nonatomic) SEL action;
@property (nonatomic) float fromValue;
@property (nonatomic) float toValue;
@property (nonatomic, strong) NSInvocation *invocation;

- (float)getEasedDiff:(float)timeSinceLastUpdate;

@end

@implementation IEAnimation

@synthesize duration = _duration;
@synthesize incremental = _incremental;
@synthesize done = _done;
@synthesize target = _target;
@synthesize action = _action;
@synthesize fromValue = _fromValue;
@synthesize toValue = _toValue;
@synthesize invocation = _invocation;

- (id)initWithTarget:(id)target action:(SEL)action methodSignature:(NSMethodSignature *)methodSignature fromValue:(float)fromValue toValue:(float)toValue
{
    self = [super init];
    
    _timeSinceStart = 0.0f;
    _duration = 2.0f;
    _diffSoFar = 0.0f;
    _incremental = YES;
    
    _done = NO;
    
    _target = target;
    _action = action;
    _fromValue = fromValue;
    _toValue = toValue;
    
    _fromToDiff = toValue - fromValue;
    
    _invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [_invocation setTarget:_target];
    [_invocation setSelector:_action];
    
    return self;
}

- (void)update:(float)timeSinceLastUpdate
{
    if (_timeSinceStart < _duration)
    {
        //float diff = _fromToDiff * (timeSinceLastUpdate / _duration);
        float diff = [self getEasedDiff:timeSinceLastUpdate];
        
        _diffSoFar += diff;
        
        if ((diff > 0.0f && _diffSoFar > _fromToDiff) || (diff < 0.0f && _diffSoFar < _fromToDiff))
        {
            _valueSoFar = _toValue;
        }
        else
        {
            _valueSoFar = _fromValue + _diffSoFar;
        }
        
        if (_incremental)
        {
            [_invocation setArgument:&diff atIndex:2];
        }
        else
        {
            [_invocation setArgument:&_valueSoFar atIndex:2];
        }
        
        [_invocation invoke];
    }
    else if (_diffSoFar != _fromToDiff)
    {
        float diff = _fromToDiff - _diffSoFar;
        
        _diffSoFar = _fromToDiff;
        _valueSoFar = _toValue;
        
        if (_incremental)
        {
            [_invocation setArgument:&diff atIndex:2];
        }
        else
        {
            [_invocation setArgument:&_valueSoFar atIndex:2];
        }
        
        [_invocation invoke];
    }
    
    if (_valueSoFar == _toValue)
    {
        _done = YES;
    }
    
    _timeSinceStart += timeSinceLastUpdate;
}

- (float)getEasedDiff:(float)timeSinceLastUpdate
{
    float easedTime = [IEMath easeOut:(_timeSinceStart + timeSinceLastUpdate) scale:_duration];
    float diff = _fromToDiff * (easedTime / _duration);
    diff = diff - _diffSoFar;
    return diff;
    
    /*float x = ((_timeSinceStart + timeSinceLastUpdate) / _duration) * 10.0f;
    float y = logf(x + 1.0) * 4.1f;
    float diff = _fromToDiff * (y / 10.0f);
    diff = diff - _diffSoFar;
    return diff;*/
}

- (void)dealloc
{
    self.invocation = nil;
}

@end
