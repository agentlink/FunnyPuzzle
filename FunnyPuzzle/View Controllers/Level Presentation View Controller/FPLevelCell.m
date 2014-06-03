//
//  FPLevelCell.m
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelCell.h"
//#import "JMIBlur.h"
@interface FPLevelCell ()
@property (nonatomic) PDFImageView *star;
@end
@implementation FPLevelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[self layer] setBorderColor:[[UIColor grayColor] CGColor]];
        [[self layer] setBorderWidth:3];
        //[self capture];
    }
    return self;
}


- (void)setIsFinished:(BOOL)isFinished
{
    _isFinished = isFinished;
    if (isFinished) {
        PDFImage *star = [PDFImage imageNamed:@"Levels/star_s"];
        _star = [[PDFImageView alloc] initWithFrame:CGRectMake(0, -self.frame.size.width/5, self.frame.size.width, self.frame.size.width)];
        _star.image = star;
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.fromValue = @0;
        rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
        rotate.duration = INFINITY;
        [_star.layer addAnimation:rotate forKey:@"rotate"];
        
        [self insertSubview:_star atIndex:0];
    } else {
        [_star removeFromSuperview];
        [self setNeedsDisplay];
    }
}
- (void)changeFrameWithAnimationToRect:(CGRect)rect
{
    [UIView animateWithDuration:0.3 animations:^{
        [[self imageVeiw] setFrame:rect];
    }];
}

@end
