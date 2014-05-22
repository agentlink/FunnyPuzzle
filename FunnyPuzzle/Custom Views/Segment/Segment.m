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
@property (nonatomic, strong) IBOutlet PDFImageView *imageView;
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
        if (_imageView) {
            _imageView = [[PDFImageView alloc] initWithFrame:frame];
            [self addSubview:_imageView];
        }
        [self config];
        }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (_imageView) {
            _imageView = [[PDFImageView alloc] initWithFrame:self.frame];
            [self addSubview:_imageView];
        }
        [self config];
        }
    return self;
}

- (void)config
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
}
- (void)setImage:(PDFImage *)image
{
    _image = image;
    if (!_imageView) {
        _imageView = [[PDFImageView alloc] initWithFrame:self.frame];
        [self addSubview:_imageView];
    }
    _imageView.image = image;
}
- (void)setImagePath:(NSString *)imagePath
{
    _imagePath = imagePath;
    if (imagePath)
    {
        _image = [PDFImage imageNamed:imagePath];
        self.frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
    } else {
        [_imageView removeFromSuperview];
    }
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
- (void)dealloc
{
    for (UIGestureRecognizer *recognizer in self.gestureRecognizers) {
        [self removeGestureRecognizer:recognizer];
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