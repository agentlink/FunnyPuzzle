//
//  Candies.m
//  FunnyPuzzle
//
//  Created by Mac on 5/21/14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "Candies.h"

@implementation Candies

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       // CGPoint p=CGPointMake(170, 147);
     //   self.centrBascket=&(p);
        
        [self config];
    }
    return self;
}

-(void)config
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
}

-(void)tap:(UITapGestureRecognizer *)recognizer
{
    CGPoint candie=CGPointMake([recognizer locationInView:self.superview].x, [recognizer locationInView:self.superview].y);
    CGPoint point0 = self.layer.position;
    CGPoint point1 = { point0.x + 50, point0.y };
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anim.fromValue    = @(point0.x);
    anim.toValue  = @(point1.x);
    anim.duration   = 1.5f;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // First we update the model layer's property.
    self.layer.position = point1;
    
    // Now we attach the animation.
    [self.layer  addAnimation:anim forKey:@"position.x"];
}

-(void)setCandieRect:(CGRect *)CandieRect
{
    _CandieRect = CandieRect;
}

-(void)setCentrBascket:(CGPoint *)centrBascket
{
    _centrBascket=centrBascket;
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
