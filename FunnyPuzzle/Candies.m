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
        [self config];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if (self)
    {
        CGRect r=CGRectMake(67 , 113, 104, 81);
        self.centrBascket = r;
        
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
    CGRect candieFrame = self.frame;
    candieFrame.origin.x=self.frame.origin.x+self.frame.size.width/2;
    candieFrame.origin.y=self.frame.origin.y+self.frame.size.height/2;
    
    CGRect displacedFrame = candieFrame;
    displacedFrame.origin.x = self.centrBascket.origin.x+self.centrBascket.size.width/2-self.frame.size.width/2;
    displacedFrame.origin.y = self.centrBascket.origin.y+self.centrBascket.size.height/2-self.frame.size.height/2;
    
    
    [UIView animateWithDuration:1.3 animations:^{
        self.frame = displacedFrame;
    } completion:^(BOOL finished){
        self.backgroundColor=[UIColor clearColor];
    }
     ];
    
}

-(void)setCentrBascket:(CGRect)centrBascket
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
