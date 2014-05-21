//
//  CloudView.m
//  KG
//
//  Created by Misha on 20.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "CloudView.h"
#import <SVGKit/SVGKImage.h>
@implementation CloudView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self startAnimation];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //CGRect startRect = self.frame;
        //startRect.origin.x = 0;//-CGRectGetHeight(self.frame);
        //self.frame = startRect;
        [self startAnimation];
    }
    return self;
}
- (void)startAnimation
{
    CGRect rect = self.frame;
    rect.origin.x = CGRectGetWidth(self.superview.frame);
    //CGAffineTransform t = self.transform;
    [UIView animateWithDuration:(double)(10+arc4random()%20) animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        CGRect rect = self.frame;
        rect.origin.x = -CGRectGetWidth(self.frame);
        self.frame = rect;
        [self startAnimation];
    }];
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
