//
//Segment.m
//KG
//
//Created by Misha on 20.05.14.
//Copyright (c) 2014 KG. All rights reserved.
//

#import "Segment.h"

@interface Segment ()

//- (IBAction)ViewClick:(id)sender;
@property (nonatomic, weak) IBOutlet SVGKFastImageView *imageWiew;


@end

@implementation Segment

CGPoint pp,p;
bool t=true;
int i=1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self config];
        }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
        }
    return self;
}

- (void)config
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
}
- (void)setImage:(SVGKImage *)image
{
    _image = image;
    _imageWiew.image = image;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state==UIGestureRecognizerStateBegan)
        {
            pp = CGPointMake([recognizer locationInView:self.superview].x, [recognizer locationInView:self.superview].y);
            p = CGPointMake(pp.x-self.layer.position.x, pp.y-self.layer.position.y);
            
            }
    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
            CGPoint p2=CGPointMake([recognizer locationInView:self.superview].x, [recognizer locationInView:self.superview].y);
            CGPoint p1 = CGPointMake(p2.x-p.x, p2.y-p.y);
            self.layer.position=p1;
    }
    
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