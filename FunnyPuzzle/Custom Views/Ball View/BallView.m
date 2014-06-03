//
//  BallView.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "BallView.h"
#import <QuartzCore/CAAnimation.h>
@interface BallView ()
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic) BOOL isVisible;
@property (nonatomic, strong) PDFImageView *imageVeiw;
@property (nonatomic) UIDynamicAnimator *animator;
@end
@implementation BallView
#pragma mark - Custom Accssesors
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        CGMutablePathRef aPath = CGPathCreateMutable();
        float x = CGRectGetMidX(self.bounds);
        float y = CGRectGetMidY(self.bounds);
        //self.layer.anchorPoint = CGPointMake(0.5, 0.8);
        CGPathMoveToPoint(aPath,nil,x-7,y);        //Origin Point
        CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
                              x+7,y+0.5,  //Control Point 2
                              x+15,y); // End Point
        animation.rotationMode = @"auto";
        animation.path = aPath;
        animation.duration = 2+arc4random()%3;
        animation.autoreverses = YES;
        animation.removedOnCompletion = NO;
        animation.repeatCount = 100.0f;
        animation.timingFunction = [CAMediaTimingFunction
                                    functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.layer addAnimation:animation forKey:@"position"];
        [animation setDelegate:self];
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        [self setupMotionEffect];
    }
    return self;
}
- (void)setupMotionEffect
{
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-10);
    verticalMotionEffect.maximumRelativeValue = @(10);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-10);
    horizontalMotionEffect.maximumRelativeValue = @(10);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self addMotionEffect:group];
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    
    if (_tap) {
        _tap();
    }
}
- (void)setImage:(PDFImage *)image
{
    if (!_imageVeiw) {
        _imageVeiw = [[PDFImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [self addSubview:_imageVeiw];
        float h = CGRectGetHeight(_imageVeiw.frame);
        float w = CGRectGetWidth(_imageVeiw.frame);
        _imageVeiw.image = image;
        if (h>w) {
            _imageVeiw.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), (CGRectGetHeight(self.frame))*(h/w));
        } else {
            
        }
    } else {
        _imageVeiw.image = image;
    }
    image = nil;
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [_imageVeiw setImage:[PDFImage imageNamed:imageName]];
}
- (PDFImageView *)imageVeiw
{
    if (!_imageVeiw) {
        _imageVeiw = [[PDFImageView alloc] init];
        [self addSubview:_imageVeiw];
    }
    return _imageVeiw;
}
- (void)setIsVisible:(BOOL)isVisible
{
    _isVisible = isVisible;
    if (isVisible) {
        //[self startAnimation];
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //Initialization code
    }
    return self;
}

- (void)startAnimation
{
    CGAffineTransform t = self.transform;
    [self needsUpdateConstraints];
    [UIView animateWithDuration:(double)(2+arc4random()%3) animations:^{
        self.transform = CGAffineTransformMakeRotation(arc4random_uniform(0.1) -0.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:(double)(2+arc4random()%3) animations:^{
            self.transform = t;
        } completion:^(BOOL finished) {
            //if (_isVisible)
            //[self startAnimation];
        }];
    }];
}

@end
