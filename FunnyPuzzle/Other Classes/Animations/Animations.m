//
//  Animations.m
//  Animation
//
//  Created by Misha Glagola on 26.06.14.
//  Copyright (c) 2014 m2g. All rights reserved.
//

#import "Animations.h"
@interface Animations ()
@property (nonatomic, copy) void (^completionBlock)(void);
@end
@implementation Animations 


+ (void)scaleIn:(UIView *)view duration:(double)duration completion:(void(^)(void))completion
{
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;

    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    scaleAnimation.keyTimes = @[@0.0, @0.68, @1.0];

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@0, @1, @1];
    opacityAnimation.keyTimes = scaleAnimation.keyTimes;


    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    Animations *animation = [[Animations alloc] init];
    animation.completionBlock = completion;
    animationGroup.delegate = animation;
    [view.layer addAnimation:animationGroup forKey:@"scale"];
    view.layer.opacity = 1;
}
+ (void)scaleOut:(UIView *)view duration:(double)duration completion:(void(^)(void))completion
{
    if (view.alpha <= 0) return;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;

    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 0.1)]];
    scaleAnimation.keyTimes = @[@0.0, @0.32, @1.0];

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1, @1, @0];
    opacityAnimation.keyTimes = scaleAnimation.keyTimes;


    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    Animations *animation = [[Animations alloc] init];
    animation.completionBlock = completion;
    animationGroup.delegate = animation;
    [view.layer addAnimation:animationGroup forKey:@"scale"];
    view.layer.opacity = 0;
}
+ (void)bounceIn:(UIView *)view duration:(double)duration completion:(void(^)(void))completion
{
    //if (view.alpha >= 1) return;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = duration;

    CATransform3D transform = view.layer.transform;
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:transform],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    scaleAnimation.keyTimes = @[@0.0, @0.32, @1.0];

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.values = @[@1, @0.9, @1];
    opacityAnimation.keyTimes = scaleAnimation.keyTimes;


    animationGroup.animations = @[scaleAnimation, opacityAnimation];
    Animations *animation = [[Animations alloc] init];
    animation.completionBlock = completion;
    animationGroup.delegate = animation;
    [view.layer addAnimation:animationGroup forKey:@"scale"];
}

+ (void)scaleIn:(UIView *)view duration:(double)duration delay:(double)delay completion:(void(^)(void))completion
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay* NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if (self) {
            [Animations scaleIn:view duration:duration completion:completion];
        }
    });
}
+ (void)scaleOut:(UIView *)view duration:(double)duration deley:(double)deley completion:(void(^)(void))completion
{
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, deley* NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        if (self) {
            [Animations scaleIn:view duration:duration completion:completion];
        }
    });
}


+ (void)move:(UIView *)view to:(CGPoint)newPosition duration:(double)duration completion:(void(^)(void))completion
{
    float keys = 30;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CAKeyframeAnimation *ancorPointAnimation = [CAKeyframeAnimation animationWithKeyPath:@"anchorPoint"];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *keyTimes = [[NSMutableArray alloc] init];
    ancorPointAnimation.values = @[[NSValue valueWithCGPoint:view.layer.anchorPoint],
                                   [NSValue valueWithCGPoint:CGPointZero]];
    ancorPointAnimation.keyTimes = @[@0, @0.2];

    float x = view.layer.position.x;
    float y = view.layer.position.y;
    float newX = newPosition.x;
    float newY = newPosition.y;
    Animations *animations = [[Animations alloc] init];
    view.layer.anchorPoint = CGPointMake(0, 0);
    for (float i = 0; i<=duration; i+=(duration/keys)) {
        float scale = [animations easeOutElastic:(i/duration) shift:0];
        float currentX, currentY;
        currentX = newX>x ? newX*scale-(x-(x*scale)) : newX*scale+(x-(x*scale));
        currentY = newY>y ? newY*scale-(y-(y*scale)) : newY*scale+(y-(y*scale));
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(currentX, currentY)];
        [values addObject:value];
        [keyTimes addObject:@(i/duration)];
    }
    animation.values = values;
    animation.keyTimes = keyTimes;

    animations.completionBlock = completion;
    animationGroup.delegate = animations;
    view.layer.position = newPosition;
    animationGroup.animations = @[animation, ancorPointAnimation];
    animationGroup.duration = duration;
    [view.layer addAnimation:animationGroup forKey:@"move"];
}

#pragma mark - Custom Accssesors


#pragma mark - CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
        if (_completionBlock) {
            _completionBlock();
        }
}
#pragma mark -  Timing Functions
- (float)easeOutElastic:(double)time shift:(double)shift
{
    shift = shift ? shift : 0.3;
    return pow(2, -10*time)*sin((time-shift/4)*(2*M_PI)/shift)+1;
}

@end
