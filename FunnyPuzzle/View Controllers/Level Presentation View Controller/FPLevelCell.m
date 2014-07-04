//
//  FPLevelCell.m
//  FunnyPuzzle
//
//  Created by Misha on 29.05.14.
//  Copyright (c) 2014 Mobilez365. All rights reserved.
//

#import "FPLevelCell.h"
#import "UIImage+ImageEffects.h"
#import "FPLevelManager.h"

//#import "JMIBlur.h"
@interface FPLevelCell ()
@property (nonatomic) PDFImageView *star;
@property (nonatomic) IBOutlet NSLayoutConstraint *height;
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
        
        //[self setBackgroundColor:[UIColor colorWithPatternImage:[self blurredSnapshot]]];
        
        //[self capture];
    }
    return self;
}

-(UIImage *)blurredSnapshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, self.window.screen.scale);
    [self drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImage *blurredSnapshotImage = [snapshotImage applyLightEffect];
    UIGraphicsEndImageContext();
    return blurredSnapshotImage;
}

- (void)setIsFinished:(BOOL)isFinished
{
    _isFinished = isFinished;
    if (isFinished) {
        PDFImage *star = [FPLevelManager imageNamed:@"Levels/star_s"];
        _star = [[PDFImageView alloc] initWithFrame:CGRectMake(0, -self.frame.size.width/5, self.frame.size.width, self.frame.size.width)];
        _star.image = star;
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate.fromValue = @0;
        rotate.toValue = @(M_PI);
        rotate.duration = INFINITY;
        [_name sizeToFit];
        _height.constant = _name.frame.size.height;
        [self insertSubview:_star atIndex:0];
        [_star.layer addAnimation:rotate forKey:@"rotate"];
    } else {
        _name.text = @"";
        _height.constant = 0;
        [_star removeFromSuperview];
        [self setNeedsDisplay];
    }
}
- (void)setIsLocked:(BOOL)isLocked
{
    _isLocked = isLocked;
    if (isLocked) {
        [self setIsFinished:NO];
        self.imageView.image = [FPLevelManager imageNamed:@"Levels/locked"];
        self.tintColor = [UIColor greenColor];
        PDFImageOptions *imageOptions = [PDFImageOptions optionsWithSize:self.imageView.image.size];
        imageOptions.tintColor = [UIColor blueColor];
        CGRect frame = CGRectMake(0, 10, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-20);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [self.imageView.image imageWithOptions:imageOptions];
        imageView.alpha = 0.3;
        imageView.tag = 3;
        [self addSubview:imageView];
        self.imageView.hidden = YES;

    } else {
        [[(UIImageView *)self viewWithTag:3] removeFromSuperview];
        self.imageView.image = nil;
        self.tintColor = [UIColor clearColor];
        self.imageView.hidden = NO;
    }
}
- (void)changeFrameWithAnimationToRect:(CGRect)rect
{
    [UIView animateWithDuration:0.3 animations:^{
        [[self imageView] setFrame:rect];
    }];
}

@end
