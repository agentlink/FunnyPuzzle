//
//  AccelerometerManager.m
//  Shaketest
//
//  Created by Stas Volskyi on 27.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "AccelerometerManager.h"

@interface AccelerometerManager()

@property (nonatomic) BOOL shaked;
@property (nonatomic) BOOL xShaked;
@property (nonatomic) BOOL yShaked;
@property (nonatomic) BOOL zShaked;

@end

@implementation AccelerometerManager

- (id) init{
    motionManager=[[CMMotionManager alloc] init];
    _minAxesValue=0.70f;
    _maxAxesValue=0.75f;
    return self;
}



- (void) setShakeRangeWithMinValue:(float)minValue MaxValue:(float)maxValue{
    _minAxesValue=minValue;
    _maxAxesValue=maxValue;
}

- (void) startShakeDetect{
    _xShaked=NO;
    _yShaked=NO;
    _zShaked=NO;
    _shaked=NO;
    [self->motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                              withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            if ((data.acceleration.x>_minAxesValue)&&(data.acceleration.x<_maxAxesValue)){
                                [self tryToMakeShakeOnVectorXAxe:data.acceleration.x YAxe:data.acceleration.y];
                                _xShaked=YES;
                            }
                            else if ((data.acceleration.y>_minAxesValue)&&(data.acceleration.y<_maxAxesValue)){
                                [self tryToMakeShakeOnVectorXAxe:data.acceleration.x YAxe:data.acceleration.y];
                                _yShaked=YES;
                            }
                            else if ((data.acceleration.z>_minAxesValue)&&(data.acceleration.z<_maxAxesValue)){
                                [self tryToMakeShakeOnVectorXAxe:data.acceleration.x YAxe:data.acceleration.y];
                                _zShaked=YES;
                            }
                            if ((data.acceleration.x>-0.20)&&(data.acceleration.x<0.20)){
                                _xShaked=NO;
                            }
                            if ((data.acceleration.y>-0.20)&&(data.acceleration.y<0.20)){
                                _yShaked=NO;
                            }
                            if ((data.acceleration.z>-0.20)&&(data.acceleration.z<0.20)){
                                _zShaked=NO;
                            }
                            [self setShaked];
                        });
    }];
}

- (void) stopShakeDetect{
    [self->motionManager stopAccelerometerUpdates];
}

- (void) tryToMakeShakeOnVectorXAxe:(float)x YAxe:(float)y{
    if (!_shaked){
        if ((_delegate) &&([_delegate respondsToSelector:@selector(iPhoneDidShaked)])){
            [_delegate iPhoneDidShaked];
        }
        if ([_delegate respondsToSelector:@selector(shakedVector:)]) {
            [_delegate shakedVector:CGVectorMake(y,x)];
        }
        _shaked=YES;
    }
}

- (void) setShaked{
    if ((_xShaked==NO)&&(_yShaked==NO)&&(_zShaked==NO)) {
        _shaked=NO;
    }
}

- (void) dealloc{
    _delegate=nil;
}

@end
