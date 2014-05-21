//
//  BallView.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "BallView.h"
@interface BallView ()
@property (nonatomic, strong) SVGKFastImageView *imageVeiw;
@end
@implementation BallView
#pragma mark - Custom Accssesors
- (void)setImage:(SVGKImage *)image
{
    if (!_imageVeiw) {
        _imageVeiw = [[SVGKFastImageView alloc] initWithSVGKImage:image];
        [self addSubview:_imageVeiw];
        float h = CGRectGetHeight(_imageVeiw.frame);
        float w = CGRectGetWidth(_imageVeiw.frame);
        if (h>w) {
            _imageVeiw.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), (CGRectGetHeight(self.frame))*(h/w));
        } else {
            
        }
    } else {
        _imageVeiw.image = image;
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
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self startAnimation];
        //self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
        //self.layer.borderColor = [[UIColor redColor] CGColor];
        //self.layer.borderWidth = 5;
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
            [self startAnimation];
        }];
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
