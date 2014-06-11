//
//  Candies.m
//  FunnyPuzzle
//
//  Created by Mac on 5/21/14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "Candy.h"
#import "FPBonusViewController.h"

@implementation Candy
{
    CAKeyframeAnimation *animation;
    CGMutablePathRef aPath;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.Animation=false;
        self.click=false;
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
        self.click=false;
      //  [self config];
       
    }
    return self;
}

-(void)config
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self config];
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
            
            [UIView animateWithDuration:0.8 animations:^{
                self.frame = displacedFrame;
            } completion:^(BOOL finished){
                CGRect displacedFrame1 = candieFrame;
                displacedFrame1.origin.x = self.centrBascket.origin.x+self.frame.size.width;
                displacedFrame1.origin.y = self.centrBascket.origin.y+self.centrBascket.size.height-self.frame.size.height+self.centrBascket.size.height+20;
                self.layer.zPosition=0;
                [UIView animateWithDuration:0.8 animations:^{
                    self.frame=displacedFrame1;
                }completion:^(BOOL finished){
                    [self cleanObject];
                }];
                self.click=true;
            }
             ];
        }
    }
    if (self.BonusLevelKind==1) {
        if (self.Animation) {
            [self Move:false];
            CATransform3D transform = [[self layer] transform];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                [self.layer setTransform:CATransform3DMakeScale(1.5, 1.5, 1.5)];
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    [self.layer setTransform:transform];
                 } completion:^(BOOL finished) {
                   self.backgroundColor=[UIColor clearColor];
                   self.click=true;
                   [self cleanObject];
                 }];
            }];
        }
    }
    
    if (self.BonusLevelKind==2) {
        if (self.Animation) {
            self.backgroundColor=[UIColor clearColor];
            self.click=true;
            [self cleanObject];
        }
    }
    
}

- (void) cleanObject{
    [self.layer removeAnimationForKey:@"position"];
    [UIView commitAnimations];
    animation=nil;
    aPath=nil;
}

-(void)setCentrBascket:(CGRect)centrBascket
{
    _centrBascket=centrBascket;
}

- (void)Move:(bool)animate
{
    if (animate) {
        animation= [CAKeyframeAnimation animation];
        aPath= CGPathCreateMutable();
        float x = CGRectGetMidX(self.frame);
        float y = CGRectGetMidY(self.frame);
        CGPathMoveToPoint(aPath,nil,x,y);        //Origin Point
        CGPathAddCurveToPoint(aPath,nil, x,y,   //Control Point 1
                              x+0.2,y,  //Control Point 2
                              x+0.1,y-0.1); // End Point
        animation.rotationMode = @"auto";
        animation.path = aPath;
        animation.duration = 0.8+arc4random()%4;
        animation.autoreverses = YES;
        animation.removedOnCompletion = YES;
        animation.repeatCount = 100.0f;
        [self.layer addAnimation:animation forKey:@"position" ];
        
    }
    else
    {
        [self.layer removeAnimationForKey:@"position"];
    }
    
}



-(void)dealloc
{
    
}



@end
