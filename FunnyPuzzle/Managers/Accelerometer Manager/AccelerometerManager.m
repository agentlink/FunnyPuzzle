//
//  AccelerometerManager.m
//  Shaketest
//
//  Created by Stas Volskyi on 27.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "AccelerometerManager.h"

@implementation AccelerometerManager

static AccelerometerManager *_instance=nil;

+ (AccelerometerManager*) sharedInstance{
    @synchronized(self){
        if (_instance==nil) {
            _instance=[[self alloc] init];
            _instance->motionManager=[[CMMotionManager alloc] init];
            _instance->_minAxesValue=0.70f;
            _instance->_maxAxesValue=0.75f;
        }
    }
    return _instance;    
}

- (void) setShakeRangeWithMinValue:(float)minValue MaxValue:(float)maxValue{
    _instance->_minAxesValue=minValue;
    _instance->_maxAxesValue=maxValue;
}

- (void) startShakeDetect{
    [self->motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                              withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            if (((data.acceleration.x>_instance.minAxesValue)&&(data.acceleration.x<_instance.maxAxesValue))||((data.acceleration.y>_instance.minAxesValue)&&(data.acceleration.y<_instance.maxAxesValue))) {
                                if ((_delegate) &&([_delegate respondsToSelector:@selector(iPhoneDidShaked)])) {
                                    [_delegate iPhoneDidShaked];
                                }
                                if ([_delegate respondsToSelector:@selector(shakedVector:)]) {
                                    [_delegate shakedVector:CGVectorMake(data.acceleration.y, data.acceleration.x)];
                                }
                            }
                        });
    }];
}

- (void) stopShakeDetect{
    [self->motionManager stopAccelerometerUpdates];
}

@end
