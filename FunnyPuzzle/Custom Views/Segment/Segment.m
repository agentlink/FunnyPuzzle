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

#pragma mark - Lifecicle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (_imageView) {
            _imageView = [[PDFImageView alloc] initWithFrame:frame];
            [self addSubview:_imageView];
        }
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
    }
    return self;
}

- (void) dealloc{
    _image=nil;
    _imageView=nil;
    _attachPoint=nil;
}
#pragma mark - Custom Accessors
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
}

#pragma mark - Public
- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, kCGBitmapAlphaInfoMask & kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    NSLog(@"%@", color);
    return color;
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