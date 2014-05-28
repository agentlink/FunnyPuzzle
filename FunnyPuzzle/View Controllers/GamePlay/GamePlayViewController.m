//
//  GamePlayViewController.m
//  KG
//
//  Created by Misha on 19.05.14.
//  Copyright (c) 2014 KG. All rights reserved.
//

#import "GamePlayViewController.h"
#import "GameModel.h"
#import <CoreMotion/CoreMotion.h>
#import "AccelerometerManager.h"

@interface GamePlayViewController () <ShakeHappendDelegate>

@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *rightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *next;
@property (nonatomic, weak) IBOutlet UIButton *prew;
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (nonatomic) Segment *dragingSegment;
@property (nonatomic) CGPoint touchPoint;
@property (nonatomic) AccelerometerManager *accelerometerManager;

@property (nonatomic) UIDynamicAnimator *dAnimator;
@property (nonatomic) UISnapBehavior *snap;
@property (nonatomic) UICollisionBehavior *collisions;
@property (nonatomic) UIPushBehavior *push;
@property (nonatomic) UILabel *label;

@property (nonatomic) FPLevelManager *level;
@property (nonatomic, weak) IBOutlet PDFImageView *field;

- (IBAction)next:(id)sender;
- (IBAction)prew:(id)sender;
- (IBAction)back:(id)sender;



@end

@implementation GamePlayViewController

#pragma mark - Lifecicle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self stopWinAnimations:nil];
    
    [_centerView addSubview:[GameModel sharedInstance].currentField];
    _field = [GameModel sharedInstance].currentField;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(_centerView.bounds), CGRectGetMidY(_centerView.bounds));
    CGPoint origin;
    centerPoint.x = centerPoint.x-(CGRectGetWidth(_field.bounds)*.5f);
    centerPoint.y = centerPoint.y-(CGRectGetHeight(_field.bounds)*.5f);
    [GameModel sharedInstance].level.grayLinedFiewld = _level.grayLinedFiewld;
    origin.x = centerPoint.x+CGRectGetMinX(_field.superview.frame);
    origin.y = centerPoint.y+CGRectGetMinY(_field.superview.frame);
    _field.frame = CGRectMake(centerPoint.x, centerPoint.y, CGRectGetWidth(_field.frame), CGRectGetHeight(_field.frame));
    [GameModel sharedInstance].fieldFrame = _field.frame;
    if (![GameModel sharedInstance].levelWin) {
        for (Segment *s in _level.segments) {
            [self.view addSubview:s];
            
            s.frame = [self createRandomPosition:s.frame];
            s.rect = [[GameModel sharedInstance] calcRect:s];
            s.transform = CGAffineTransformMakeScale(0, 0);
            s.alpha = 0;
            if ([s isEqual:[[_level segments] lastObject]])
                s.layer.zPosition =1;
            [UIView animateWithDuration:0.2 delay:[_level.segments indexOfObject:s]*0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                s.transform = CGAffineTransformMakeScale(1.2, 1.2);
                s.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f animations:^{
                    s.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
        }
        
        [GameModel sharedInstance].fieldOrigin = origin;
        _field.transform = CGAffineTransformMakeScale(0, 0);
        _field.alpha = 0;
        [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _field.transform = CGAffineTransformMakeScale(1.2, 1.2);
            _field.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f animations:^{
                _field.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }];
    } else {
        [self startWinAnimations:nil];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopWinAnimations:self.view];
    [GameModel sharedInstance].level = nil;
}
- (void)iPhoneDidShaked
{
}
- (void)shakedVector:(CGVector)vector
{
    [_push setPushDirection:vector];
    NSLog(@"vector: dx,dy: %f,%f", vector.dx, vector.dy);
    _push.active = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startConfiguration];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) dealloc
{
    [self.view removeGestureRecognizer:[self.view.gestureRecognizers firstObject]];
}



#pragma mark - Private
- (CGRect)createRandomPosition:(CGRect)rect
{
    rect.origin.x = arc4random()%(int)fabs((CGRectGetHeight(_leftView.frame)-CGRectGetHeight(rect)-40));
    rect.origin.y = arc4random()%(int)fabs((CGRectGetWidth(_leftView.frame)-CGRectGetWidth(rect)-40));
    return rect;
}
- (void) startConfiguration
{
    _level = [GameModel sharedInstance].level;
    
    UIFont *font = [UIFont fontWithName:@"KBCuriousSoul" size:60];
    _next.titleLabel.font = font;
    _prew.titleLabel.font = font;
    _next.layer.zPosition = MAXFLOAT;
    _prew.layer.zPosition = MAXFLOAT;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    
    [self.view addGestureRecognizer:pan];
    
    _dAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    _collisions = [[UICollisionBehavior alloc] init];
    _collisions.translatesReferenceBoundsIntoBoundary = YES;
    _push = [[UIPushBehavior alloc] initWithItems:nil mode:UIPushBehaviorModeInstantaneous];
    _push.magnitude = 5;
    [_dAnimator addBehavior:_collisions];
    [_dAnimator addBehavior:_push];
    
    _accelerometerManager = [AccelerometerManager new];
    [_accelerometerManager setShakeRangeWithMinValue:0.3 MaxValue:1];
    
    [GameModel sharedInstance].gamePlayViewController = self;
    _accelerometerManager.delegate = self;
}

- (void) updateLevel
{
    _level = [GameModel sharedInstance].level;
    [self viewDidAppear:YES];
}
- (void)removeObjects
{
    for (UIView *v in _level.segments) {
        [UIView animateWithDuration:0.3 animations:^{
            v.transform = CGAffineTransformMakeScale(0, 0);
            v.alpha = 0;
            _field.transform = CGAffineTransformMakeScale(0, 0);
            _field.alpha = 0;
        } completion:^(BOOL finished) {
            [v removeFromSuperview];
        }];
    }
}
- (void)startWinAnimations:(UIView *)view
{
    PDFImage *star = [PDFImage imageNamed:@"Levels/star"];
    PDFImageView *imageView = [[PDFImageView alloc] initWithFrame:CGRectMake(0, 0, star.size.width, star.size.height)];
    imageView.image = star;
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = 4;
    animationGroup.repeatCount = INFINITY;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = @0;
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 10;
    animationGroup.animations = @[rotate];
    
    [imageView.layer addAnimation:animationGroup forKey:@"pulse"];
    imageView.layer.position = _centerView.layer.position;// _field.layer.position;
    imageView.transform = CGAffineTransformMakeScale(0, 0);
    imageView.tag = 42;
    
    PDFImageView *res = [GameModel sharedInstance].level.colorField;
    res.frame = _field.frame;
    res.transform = CGAffineTransformMakeScale(2, 2);
    res.alpha = 0;
    res.layer.zPosition = 255;
    res.tag = 43;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = _level.levelName;
    label.font = [UIFont fontWithName:@"KBCuriousSoul" size:30];
    label.tag = 44;
    [label sizeToFit];
    label.layer.position = CGPointMake(CGRectGetMinX(_leftView.frame), CGRectGetMinY(_leftView.frame));
    [self.view addSubview:label];
    _snap = [[UISnapBehavior alloc] initWithItem:label snapToPoint:CGPointMake(CGRectGetMidX(_leftView.frame), CGRectGetMidY(_leftView.frame))];
    _snap.damping = 0.2;
    [_push addItem:label];
    [_dAnimator addBehavior:_snap];
    [_collisions addItem:label];

    [_centerView insertSubview:res atIndex:0];
    [self.view insertSubview:imageView atIndex:0];
    [self removeObjects];
    [UIView animateWithDuration:0.2 animations:^{
        imageView.transform = CGAffineTransformMakeScale(1, 1);
        _field.layer.shadowColor = [[UIColor whiteColor] CGColor];
        _field.layer.shadowRadius = 20;
        _field.layer.shadowOffset = CGSizeMake(0, 0);
        _field.layer.shadowOpacity = 1;
        res.transform = CGAffineTransformMakeScale(0.8, 0.8);
        res.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            res.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    [_accelerometerManager startShakeDetect];
    _push.active = YES;
}
- (void)stopWinAnimations:(UIView *)view
{
    PDFImageView *imageView = (PDFImageView *)[self.view viewWithTag:42];
    PDFImageView *res = (PDFImageView *)[self.view viewWithTag:43];
    res.layer.zPosition = -1;
    UILabel *label = (UILabel *)[self.view viewWithTag:44];
    [_dAnimator removeBehavior:_snap];
    [_collisions removeItem:label];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0, 0);
        res.transform = CGAffineTransformMakeScale(0, 0);
        res.alpha = 0;
        //label.transform = CGAffineTransformMakeScale(0, 0);
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [imageView removeFromSuperview];
        [res removeFromSuperview];
    }];
     [_accelerometerManager stopShakeDetect];
    _push.active = NO;
}
#pragma mark - IBAction
- (IBAction)next:(id)sender
{
    [self removeObjects];
    _level = [[GameModel sharedInstance] nextLevel];
    [self updateLevel];
}
- (IBAction)prew:(id)sender
{
    [self removeObjects];
    _level = [[GameModel sharedInstance] prewLevel];
    [self updateLevel];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - GestureRecognizers

- (void)panGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    
   // if (recognizer.state == UIGestureRecognizerStateBegan)
    //{
    _dragingSegment.layer.anchorPoint = _touchPoint;
        _dragingSegment.layer.position = [recognizer locationInView:self.view];
        //NSLog(@"touchBegan");
    //}
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [[GameModel sharedInstance] checkForRightPlace:_dragingSegment];
        
    }
}
- (void)levelFinish
{
    [self startWinAnimations:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:self.view];
    _dragingSegment = nil;
    NSMutableArray *tapSegments = [[NSMutableArray alloc] init];
    for (Segment *s in _level.segments) {
        if (CGRectContainsPoint(s.frame, touchLocation)) {
            if (s.inPlase) {
                [UIView animateWithDuration:0.1 animations:^{
                    s.transform = CGAffineTransformMakeScale(1.2, 1.2);
                    
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        s.transform = CGAffineTransformMakeScale(1, 1);
                    }];
                }];
            } else {
                [tapSegments addObject:s];
            }
            
        }
        
    }
    if (tapSegments.count>1) {
        for (Segment *s in tapSegments) {
            if (s.layer.zPosition == 1 && !CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0)
            {
                s.layer.zPosition = 1;
                _dragingSegment = s;
                _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
            } else if (!_dragingSegment && !CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0) {
                s.layer.zPosition = 1;
                _dragingSegment = s;
                _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
            } else {
                s.layer.zPosition = 0;
            }
        }
    } else {
        Segment *s = [tapSegments firstObject];
        if (!CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0) {
            for (Segment *ss in _level.segments) {
                ss.layer.zPosition = 0;
            }
            s.layer.zPosition = 1;
            _dragingSegment = s;
            _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
        }
    }
}
@end
