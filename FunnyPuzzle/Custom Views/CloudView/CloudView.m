//
//  CloudView.m
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "CloudView.h"
#import <PDFImage/PDFImage.h>
@interface CloudView ()
@end
@implementation CloudView

#pragma mark - Lifecicle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self startAnimation];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        CGMutablePathRef aPath = CGPathCreateMutable();
        float y = self.frame.origin.y;
        float screenHeigth = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        
        CGPathMoveToPoint(aPath, nil,0-CGRectGetWidth(self.frame), y);
        CGPathAddLineToPoint(aPath, nil, screenHeigth+CGRectGetWidth(self.frame), y);
       
        
        animation.path = aPath;
        animation.duration = 30+arc4random()%60;
        animation.autoreverses = NO;
        animation.removedOnCompletion = NO;
        animation.repeatCount = INFINITY;
        animation.beginTime = 30+arc4random()%60;
        animation.timingFunction = [CAMediaTimingFunction
                                    functionWithName:kCAMediaTimingFunctionLinear];
        
        [self.layer addAnimation:animation forKey:@"position"];
        NSArray *clouds = @[@"cloud1", @"cloud2", @"cloud3"];
        PDFImage *cloud = [PDFImage imageNamed:[clouds objectAtIndex:arc4random()%(clouds.count)]];
        PDFImageView *cloudView = [[PDFImageView alloc] initWithFrame:[self calcRect:self.frame size:cloud.size]];
        cloudView.image = cloud;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:cloudView];
        [self setupMotionEffect];
    }
    return self;
}
#pragma mark - Private
- (CGRect)calcRect:(CGRect)rect size:(CGSize)size
{
    float multiplayer = 1;
    if (size.width>self.frame.size.width)
    {
        multiplayer = self.frame.size.width/size.width;
    }
    CGRect result;
    result.size = CGSizeMake(size.width*multiplayer, size.height*multiplayer);
    return result;
}
- (void)setupMotionEffect
{
    int dimentions = (10+arc4random()%50);

    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-dimentions);
    verticalMotionEffect.maximumRelativeValue = @(dimentions);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-dimentions);
    horizontalMotionEffect.maximumRelativeValue = @(dimentions);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self addMotionEffect:group];
}

@end
