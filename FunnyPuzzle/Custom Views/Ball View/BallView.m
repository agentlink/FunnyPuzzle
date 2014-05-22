//
//  BallView.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "BallView.h"
@interface BallView ()
@property (nonatomic, strong) PDFImageView *imageVeiw;
@end
@implementation BallView
#pragma mark - Custom Accssesors

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
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        //[self startAnimation];
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
            //if (_isVisible)
            //[self startAnimation];
        }];
    }];
}

@end
