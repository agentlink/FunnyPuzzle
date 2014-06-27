//
//  Animations.h
//  Animation
//
//  Created by Misha Glagola on 26.06.14.
//  Copyright (c) 2014 m2g. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animations : NSObject 
+ (void)scaleIn:(UIView *)view duration:(double)duration completion:(void(^)(void))completion;
+ (void)scaleOut:(UIView *)view duration:(double)duration completion:(void(^)(void))completion;
+ (void)scaleIn:(UIView *)view duration:(double)duration delay:(double)delay completion:(void(^)(void))completion;
+ (void)scaleOut:(UIView *)view duration:(double)duration deley:(double)deley completion:(void(^)(void))completion;
+ (void)bounceIn:(UIView *)view duration:(double)duration completion:(void(^)(void))completion;
@end