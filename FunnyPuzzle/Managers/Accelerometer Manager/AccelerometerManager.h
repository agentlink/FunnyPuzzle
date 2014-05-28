//
//  AccelerometerManager.h
//  Shaketest
//
//  Created by Stas Volskyi on 27.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@protocol ShakeHappendDelegate <NSObject>

- (void) iPhoneDidShaked;

@end

@interface AccelerometerManager : NSObject{
    CMMotionManager *motionManager;
}

@property (nonatomic) id<ShakeHappendDelegate> delegate;

+ (AccelerometerManager*) sharedInstance;

- (void) startShakeDetect;
- (void) stopShakeDetect;

//min value -1, max value 1
- (void) setShakeRangeWithMinValue:(float)minValue MaxValue:(float)maxValue;

@property (nonatomic, readonly) float minAxesValue;
@property (nonatomic, readonly) float maxAxesValue;

@end
