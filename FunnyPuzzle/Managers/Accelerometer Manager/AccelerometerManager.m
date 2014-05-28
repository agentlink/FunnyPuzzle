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
    _shaked=NO;
    [self->motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
                                              withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            if (((data.acceleration.x>_minAxesValue)&&(data.acceleration.x<_maxAxesValue))||((data.acceleration.y>_minAxesValue)&&(data.acceleration.y<_maxAxesValue))||((data.acceleration.z>_minAxesValue)&&(data.acceleration.z<_maxAxesValue))) {
                                if (!_shaked){
                                    if ((_delegate) &&([_delegate respondsToSelector:@selector(iPhoneDidShaked)])){
                                        [_delegate iPhoneDidShaked];
                                    }
                                    if ([_delegate respondsToSelector:@selector(shakedVector:)]) {
                                        [_delegate shakedVector:CGVectorMake(data.acceleration.y, data.acceleration.x)];}
                                    _shaked=YES;
                                }
                            }
                            else{
                                _shaked=NO;
                            }
                        });
    }];
}

- (void) stopShakeDetect{
    [self->motionManager stopAccelerometerUpdates];
}

@end
