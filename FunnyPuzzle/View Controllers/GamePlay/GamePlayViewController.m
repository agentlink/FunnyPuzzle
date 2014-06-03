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
#import "FPSoundManager.h"

@interface GamePlayViewController () <ShakeHappendDelegate>

@property (nonatomic, weak) IBOutlet UIView *leftView;
@property (nonatomic, weak) IBOutlet UIView *centerView;
@property (nonatomic, weak) IBOutlet UIButton *next;
@property (nonatomic, weak) IBOutlet UIButton *prew;
@property (nonatomic, weak) IBOutlet UIButton *back;
@property (nonatomic) Segment *dragingSegment;
@property (nonatomic) CGPoint touchPoint;
@property (nonatomic) AccelerometerManager *accelerometerManager;

@property (nonatomic) UIDynamicAnimator *dAnimator;
@property (nonatomic) UISnapBehavior *snap;
@property (nonatomic) UISnapBehavior *basketSnap;
@property (nonatomic) UICollisionBehavior *collisions;
@property (nonatomic) UIPushBehavior *push;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIImageView *basketView;
@property (nonatomic) UIPushBehavior *basketPush;
@property (nonatomic) UIImageView *candyView;

@property (nonatomic) FPLevelManager *level;

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
    if (![GameModel sharedInstance].levelCompleet) {
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
    [[FPSoundManager sharedInstance] stopBackgroundMusic];
    [[FPSoundManager sharedInstance] playGameMusic];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopWinAnimations:self.view];
    [GameModel sharedInstance].level = nil;
    [self.view removeGestureRecognizer:[self.view.gestureRecognizers firstObject]];
    _dragingSegment=nil;
    _accelerometerManager=nil;
    _dAnimator=nil;
    _snap=nil;
    _collisions=nil;
    _push=nil;
    _label=nil;
    _level=nil;
}

- (void)shakedVector:(CGVector)vector
{
    [_push setPushDirection:vector];
    _push.active = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startConfiguration];
}

- (void) dealloc
{

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
    
    //[GameModel sharedInstance].gamePlayViewController = self;
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
    [self showBasket];
    UILabel *label = [[UILabel alloc] init];
    label.text = _level.levelName;
    label.font = [UIFont fontWithName:@"KBCuriousSoul" size:30];
    label.tag = 44;
    [label sizeToFit];
    label.layer.position = CGPointMake(CGRectGetMinX(_leftView.frame), CGRectGetMinY(_leftView.frame));
    [self.view addSubview:label];
    _snap = [[UISnapBehavior alloc] initWithItem:label snapToPoint:CGPointMake(CGRectGetMidX(_leftView.frame), CGRectGetMidY(_leftView.frame)+self.view.frame.size.width/5)];
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
    UIImageView *basketView = (UIImageView*)[self.view viewWithTag:99];
    res.layer.zPosition = -1;
    UILabel *label = (UILabel *)[self.view viewWithTag:44];
    [_dAnimator removeBehavior:_snap];
    [_dAnimator removeBehavior:_basketSnap];
    [_collisions removeItem:label];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.transform = CGAffineTransformMakeScale(0, 0);
        res.transform = CGAffineTransformMakeScale(0, 0);
        basketView.transform = CGAffineTransformMakeScale(0,0);
        res.alpha = 0;
        //label.transform = CGAffineTransformMakeScale(0, 0);
        label.alpha = 0;
    } completion:^(BOOL finished) {
        [label removeFromSuperview];
        [imageView removeFromSuperview];
        [res removeFromSuperview];
        [basketView removeFromSuperview];
        [_candyView removeFromSuperview];
    }];
     [_accelerometerManager stopShakeDetect];
    _push.active = NO;
    _basketPush.active = NO;
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
    if ([self presentingViewController]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - GestureRecognizers

- (void)panGestureRecognizer:(UIGestureRecognizer *)recognizer
{
    
   // if (recognizer.state == UIGestureRecognizerStateBegan)
    //{
    _dragingSegment.layer.anchorPoint = _touchPoint;
    _dragingSegment.layer.position = [recognizer locationInView:self.view];
    //_dragingSegment.attachPoint.anchorPoint = [recognizer locationInView:self.view];
        //NSLog(@"touchBegan");
    //}
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        [[GameModel sharedInstance] itemDrop];
        [[GameModel sharedInstance] checkForRightPlace:_dragingSegment];
    }
}

- (void)levelFinish
{
    [[GameModel sharedInstance] levelComplete:[GameModel sharedInstance].level.soundURL];
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
                [[GameModel sharedInstance] itemWillSelectFromPlace];
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
                [[GameModel sharedInstance] itemSelected];
            } else if (!_dragingSegment && !CGColorGetAlpha([[s colorOfPoint:[touch1 locationInView:s]] CGColor])==0) {
                s.layer.zPosition = 1;
                _dragingSegment = s;
                _touchPoint = CGPointMake([touch1 locationInView:s].x/s.frame.size.width, [touch1 locationInView:s].y/s.frame.size.height);
                [[GameModel sharedInstance] itemSelected];
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
            [[GameModel sharedInstance] itemSelected];
        }
    }
}

#pragma mark - Basket

- (void) showBasket{
    _basketView=[[UIImageView alloc] initWithFrame:CGRectMake(_leftView.center.x-75.5,-150, 120, 120) ];
    [_basketView setImage:[UIImage imageNamed:@"basket_full"]];
    _basketView.tag=99;
    [self.view addSubview:_basketView];
    _candyView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"candy_orange"]];
    _candyView.tag=98;
    _candyView.alpha=0;
    _candyView.frame = CGRectMake(_basketView.frame.origin.x+_basketView.frame.size.width/2.5, CGRectGetMidY(self.leftView.frame)-70, 55, 55);
    [self.view addSubview:_candyView];
    _basketSnap = [[UISnapBehavior alloc] initWithItem:_basketView snapToPoint:CGPointMake(CGRectGetMidX(self.leftView.frame), CGRectGetMidY(self.leftView.frame))];
    _basketSnap.damping = 0.8;
    [_basketPush addItem:_basketView];
    [_dAnimator addBehavior:_basketSnap];
    _basketPush.active = YES;
    [UIImageView animateWithDuration:1.2 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^(void){
        _candyView.alpha=1;
    }completion:^(BOOL finished){
        _basketView.layer.zPosition=2;
        _candyView.layer.zPosition=0;
            [self pickCandy];
    }];
}

- (void) pickCandy{
    CGRect frame=_candyView.frame;
    frame.origin.y+=50;
        [UIView animateWithDuration:0.6 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^(void){
            _candyView.frame = frame;
            } completion:^(BOOL finished){
                    if (finished){
                        [_candyView removeFromSuperview];
                        _candyView=nil;
                    }
            }];
}

@end
