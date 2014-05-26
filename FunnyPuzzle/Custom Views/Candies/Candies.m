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
        self.Animation=false;
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
          self.Animation=false;
        
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
    if (self.BonusLevelKind==0) {
        if (self.Animation) {
            CGRect candieFrame = self.frame;
            candieFrame.origin.x=self.frame.origin.x;
            candieFrame.origin.y=self.frame.origin.y;
            
            CGRect displacedFrame = candieFrame;
            displacedFrame.origin.x = self.centrBascket.origin.x+self.frame.size.width;
            displacedFrame.origin.y = self.centrBascket.origin.y+self.centrBascket.size.height-self.frame.size.height;
            self.layer.zPosition=2;
            
            [UIView animateWithDuration:1.8 animations:^{
                self.frame = displacedFrame;
            } completion:^(BOOL finished){
                CGRect displacedFrame1 = candieFrame;
                displacedFrame1.origin.x = self.centrBascket.origin.x+self.frame.size.width;
                displacedFrame1.origin.y = self.centrBascket.origin.y+self.centrBascket.size.height-self.frame.size.height+self.centrBascket.size.height+20;
                self.layer.zPosition=0;
                [UIView animateWithDuration:1.8 animations:^{
                self.frame=displacedFrame1;
                }];
              //  self.backgroundColor=[UIColor clearColor];
            }
             ];
        }
    }
    
    if (self.BonusLevelKind==1) {
        if (self.Animation) {
            self.backgroundColor=[UIColor clearColor];
        }
    }
    
    
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
