//
//Segment.m
//KG
//
//Created by Misha on 20.05.14.
//Copyright (c) 2014 KG. All rights reserved.
//

#import "Segment.h"
#import "GameModel.h"

@interface Segment ()

//- (IBAction)ViewClick:(id)sender;
@property (nonatomic) BOOL dragEnabled;
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
        //[self config];
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
        //[self config];
        }
    return self;
}

- (void)config
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_imageView addGestureRecognizer:pan];
    
}
- (void)checkForRightPlace:(Segment *)segment
{
    //[GameModel sharedInstance].manager.grayLinedFiewld.superview.backgroundColor = [UIColor redColor];
    CGPoint currentPoint = [segment frame].origin;
    CGPoint oser =  [GameModel sharedInstance].fieldOrigin;
    CGPoint pointInPlace = CGPointMake(currentPoint.x+oser.x, currentPoint.y+oser.y);
    //if (CGPointEqualToPoint ())
}
- (void)setImage:(PDFImage *)image
{
    _image = image;
    if (!_imageView) {
        _imageView = [[PDFImageView alloc] initWithFrame:self.frame];
        [self addSubview:_imageView];
    }
    //_imageView.backgroundColor = [UIColor grayColor];
    _imageView.clipsToBounds = YES;
    _imageView.image = image;
    [self config];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    

    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self];
    CGRect startRect = [self frame];
    NSLog(@"%i", CGRectContainsPoint(startRect, touchLocation));
    NSLog(@"%@", [self colorOfPoint:touchLocation]);
    NSLog(@"alpha: %f", CGColorGetAlpha([[self colorOfPoint:touchLocation] CGColor]));
    if (!CGColorGetAlpha([[self colorOfPoint:touchLocation] CGColor])==0) {
        pp = CGPointMake([touch1 locationInView:self.superview].x, [touch1 locationInView:self.superview].y);
        p = CGPointMake(pp.x-self.layer.position.x, pp.y-self.layer.position.y);
        _dragEnabled = YES;
    }
}
- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    if ((recognizer.state == UIGestureRecognizerStateChanged) && _dragEnabled)
    {
            CGPoint p2=CGPointMake([recognizer locationInView:self.superview].x, [recognizer locationInView:self.superview].y);
            CGPoint p1 = CGPointMake(p2.x-p.x, p2.y-p.y);
            self.layer.position=p1;
    } else if (recognizer.state == UITouchPhaseEnded)
    {
        [self checkForRightPlace:self];
        _dragEnabled = NO;
        
    }
    
}
- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
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