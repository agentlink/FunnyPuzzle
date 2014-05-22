//
//  CloudView.m
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "CloudView.h"
#import <PDFImage/PDFImage.h>
@implementation CloudView

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
        float x = CGRectGetMidX(self.frame);
        float y = CGRectGetMidY(self.frame);
        float wx = CGRectGetHeight([[UIScreen mainScreen] bounds]);
        self.layer.anchorPoint = CGPointMake(0.5, 0.8);
        CGPathMoveToPoint(aPath,nil,0-CGRectGetWidth(self.frame),y);        //Origin Point
        CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
                              wx+(CGRectGetWidth(self.frame)/2),y+5,  //Control Point 2
                              wx+CGRectGetWidth(self.frame),y); // End Point
        animation.rotationMode = @"auto";
        animation.path = aPath;
        animation.duration = 10+arc4random()%30;
        animation.autoreverses = NO;
        animation.removedOnCompletion = NO;
        animation.repeatCount = 100.0f;
        animation.timingFunction = [CAMediaTimingFunction
                                    functionWithName:kCAMediaTimingFunctionLinear];
        [self.layer addAnimation:animation forKey:@"position"];
        
        [animation setDelegate:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
